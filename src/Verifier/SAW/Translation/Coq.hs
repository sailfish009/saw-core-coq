{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ViewPatterns #-}

{- |
Module      : Verifier.SAW.Translation.Coq
Copyright   : Galois, Inc. 2018
License     : BSD3
Maintainer  : atomb@galois.com
Stability   : experimental
Portability : portable
-}

module Verifier.SAW.Translation.Coq where

import Control.Lens (_1, _2, makeLenses, over, set, view)
import qualified Control.Monad.Except as Except
import qualified Control.Monad.Fail as Fail
import Control.Monad.Reader hiding (fail)
import Control.Monad.State hiding (fail, state)
import Data.List (intersperse)
import qualified Data.Map as Map
import Prelude hiding (fail)
import Text.PrettyPrint.ANSI.Leijen hiding ((<$>))

import qualified Language.Coq.AST as Coq
import qualified Language.Coq.Pretty as Coq
import Verifier.SAW.Module
import Verifier.SAW.Recognizer
import Verifier.SAW.SharedTerm
-- import Verifier.SAW.Term.CtxTerm
import Verifier.SAW.Term.Functor
--import Verifier.SAW.Term.Pretty
-- import qualified Verifier.SAW.UntypedAST as Un
import qualified Data.Vector as Vector (reverse, toList)

--import Debug.Trace

data TranslationError a
  = NotSupported a
  | NotExpr a
  | NotType a
  | LocalVarOutOfBounds a
  | BadTerm a

showError :: (a -> String) -> TranslationError a -> String
showError printer err = case err of
  NotSupported a -> "Not supported: " ++ printer a
  NotExpr a      -> "Expecting an expression term: " ++ printer a
  NotType a      -> "Expecting a type term: " ++ printer a
  LocalVarOutOfBounds a -> "Local variable reference is out of bounds: " ++ printer a
  BadTerm a -> "Malformed term: " ++ printer a

instance {-# OVERLAPPING #-} Show (TranslationError Term) where
  show = showError showTerm

instance {-# OVERLAPPABLE #-} Show a => Show (TranslationError a) where
  show = showError show

data TranslationConfiguration = TranslationConfiguration
  { translateVectorsAsCoqVectors :: Bool -- ^ when `False`, translate vectors as Coq lists
  , traverseConsts               :: Bool
  }

data TranslationState = TranslationState
  { _declarations :: [Coq.Decl]
  , _environment  :: [String]
  }
  deriving (Show)
makeLenses ''TranslationState

type MonadCoqTrans m =
  ( Except.MonadError (TranslationError Term)  m
  , MonadReader       TranslationConfiguration m
  , MonadState        TranslationState         m
  )

showFTermF :: FlatTermF Term -> String
showFTermF = show . Unshared . FTermF

data SpecialTreatment = SpecialTreatment
  { moduleRenaming        :: Map.Map ModuleName String
  , identSpecialTreatment :: Map.Map ModuleName (Map.Map String IdentSpecialTreatment)
  }

data IdentSpecialTreatment
  = MapsTo Ident  -- means "don't translate its definition, instead use provided"
  | Rename String -- means "translate its definition, but rename it"
  | Skip          -- means "don't translate its definition, no replacement"

mkCoqIdent :: String -> String -> Ident
mkCoqIdent coqModule coqIdent = mkIdent (mkModuleName [coqModule]) coqIdent

-- NOTE: while I initially did the mapping from SAW core names to the
-- corresponding Coq construct here, it makes the job of translating SAW core
-- axioms into Coq theorems much more annoying, because one needs to manually
-- rename every constant mentioned in the statement to its Coq counterpart.
-- Instead, I am now trying to keep the names the same as much as possible
-- during this translation (it is sometimes impossible, for instance, `at` is a
-- reserved keyword in Coq), so that primitives' and axioms' types can be
-- copy-pasted as is on the Coq side.
sawCorePreludeSpecialTreatmentMap :: Map.Map String IdentSpecialTreatment
sawCorePreludeSpecialTreatmentMap = Map.fromList $ []

  -- Unsafe SAW features
  ++
  [ ("error",             MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "error")
  , ("fix",               Skip)
  , ("unsafeAssert",      Skip)
  , ("unsafeCoerce",      Skip)
  , ("unsafeCoerce_same", Skip)
  ]

  -- coercions
  ++
  [ ("coerce",            MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "coerce")
  , ("coerce__def",       Skip)
  , ("coerce__eq",        Skip)
  , ("rcoerce",           Skip)
  ]

  -- Unit
  ++
  [ ("Unit",              MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Unit")
  , ("UnitType",          MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "UnitType")
  , ("UnitType__rec",     MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "UnitType__rec")
  ]

  -- Records
  ++
  [ ("EmptyType",         Skip)
  , ("EmptyType__rec",    Skip)
  , ("RecordType",        Skip)
  , ("RecordType__rec",   Skip)
  ]

  -- Decidable equality, does not make sense in Coq unless turned into a type
  -- class
  -- Apparently, this is not used much for Cryptol, so we can skip it.
  ++
  [ ("eq",                Skip) -- MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "eq")
  , ("eq_bitvector",      Skip)
  , ("eq_Bool",           Skip) -- MapsTo $ mkCoqIdent "CryptolToCow.SAW" "eq_Bool")
  , ("eq_Nat",            Skip)
  , ("eq_refl",           Skip) -- MapsTo $ mkCoqIdent "CryptolToCow.SAW" "eq_refl")
  , ("eq_VecBool",        Skip)
  , ("eq_VecVec",         Skip)
  , ("ite_eq_cong_1",     Skip)
  , ("ite_eq_cong_2",     Skip)
  ]

  -- Boolean
  ++
  [ ("and",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "and")
  , ("and__eq",           MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "and__eq")
  , ("Bool",              MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Bool")
  , ("boolEq",            MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "boolEq")
  , ("boolEq__eq",        MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "boolEq__eq")
  , ("False",             MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "False")
  , ("ite",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "ite")
  , ("iteDep",            MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "iteDep")
  , ("iteDep_True",       MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "iteDep_True")
  , ("iteDep_False",      MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "iteDep_False")
  , ("ite_bit",           Skip) -- FIXME: change this
  , ("ite_eq_iteDep",     MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "ite_eq_iteDep")
  , ("not",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "not")
  , ("not__eq",           MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "not__eq")
  , ("or",                MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "or")
  , ("or__eq",            MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "or__eq")
  , ("True",              MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "True")
  , ("xor",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "xor")
  , ("xor__eq",           MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "xor__eq")
  ]

  -- Pairs
  ++
  [ ("PairType",          MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "PairType")
  , ("PairValue",         MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "PairValue")
  , ("Pair__rec",         MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Pair__rec")
  , ("fst",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "fst")
  , ("snd",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "snd")
  ]

  -- Equality
  ++
  [ ("Eq",                MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Eq")
  , ("Eq__rec",           MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Eq__rec")
  , ("Refl",              MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Refl")
  ]

  -- Strings
  ++
  [ ("String",            MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "String")
  ]

  -- Utility functions
  ++
  [ ("id",                MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "id")
  ]

  -- Natural numbers
  ++
  [ ("divModNat",         MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "divModNat")
  , ("Nat",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Nat")
  , ("widthNat",          MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "widthNat")
  , ("Zero",              MapsTo $ mkCoqIdent "CryptolToCoq"     "Zero")
  , ("Succ",              MapsTo $ mkCoqIdent "CryptolToCoq"     "Succ")
  ]

  -- Vectors
  ++
  [ ("at",                Rename "sawAt") -- `at` is a reserved keyword in Coq
  , ("at_single",         Skip) -- is boring, could be proved on the Coq side
  , ("atWithDefault",     MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "atWithDefault")
  , ("coerceVec",         MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "coerceVec")
  , ("EmptyVec",          MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "EmptyVec")
  , ("eq_Vec",            Skip)
  , ("foldr",             MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "foldr")
  , ("gen",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "gen")
  , ("take0",             Skip)
  -- cannot map directly to Vector.t because arguments are in a different order
  , ("zip",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "zip")
  , ("Vec",               MapsTo $ mkCoqIdent "CryptolToCoq.SAW" "Vec")
  ]

cryptolPreludeSpecialTreatmentMap :: Map.Map String IdentSpecialTreatment
cryptolPreludeSpecialTreatmentMap = Map.fromList $ []

  ++
  [ ("Num_rec",               Skip) -- automatically defined
  , ("unsafeAssert_same_Num", Skip) -- unsafe and unused
  ]

specialTreatmentMap :: Map.Map ModuleName (Map.Map String IdentSpecialTreatment)
specialTreatmentMap = Map.fromList $
  over _1 (mkModuleName . (: [])) <$>
  [ ("Cryptol", cryptolPreludeSpecialTreatmentMap)
  , ("Prelude", sawCorePreludeSpecialTreatmentMap)
  ]

moduleRenamingMap :: Map.Map ModuleName ModuleName
moduleRenamingMap = Map.fromList $
  over _1 (mkModuleName . (: [])) <$>
  over _2 (mkModuleName . (: [])) <$>
  [ ("Prelude", "SAWCorePrelude")
  ]

translateModuleName :: ModuleName -> ModuleName
translateModuleName mn =
  Map.findWithDefault mn mn moduleRenamingMap

findSpecialTreatment :: Ident -> Maybe IdentSpecialTreatment
findSpecialTreatment ident =
  let moduleMap = Map.findWithDefault Map.empty (identModule ident) specialTreatmentMap in
  Map.findWithDefault Nothing (identName ident) (Just <$> moduleMap)

findIdentTranslation :: Ident -> Ident
findIdentTranslation i =
  case findSpecialTreatment i of
  Nothing -> mkIdent (translateModuleName (identModule i)) (identName i)
  Just st ->
    case st of
    MapsTo ident   -> ident
    Rename newName -> mkIdent (translateModuleName (identModule i)) newName
    Skip           -> i -- do we want a marker to indicate this will likely fail?

translateIdent :: Ident -> Coq.Ident
translateIdent = show . findIdentTranslation

translateIdentUnqualified :: Ident -> Coq.Ident
translateIdentUnqualified = identName .  findIdentTranslation

{-
traceFTermF :: String -> FlatTermF Term -> a -> a
traceFTermF ctx tf = traceTerm ctx (Unshared $ FTermF tf)

traceTerm :: String -> Term -> a -> a
traceTerm ctx t a = trace (ctx ++ ": " ++ showTerm t) a
-}

translateBinder ::
  MonadCoqTrans m =>
  (Ident, Term) -> m (Coq.Ident, Coq.Term)
translateBinder (ident, term) = (,) <$> pure (translateIdent ident) <*> translateTerm term

dropPi :: Coq.Term -> Coq.Term
dropPi (Coq.Pi (_ : t) r) = Coq.Pi t r
dropPi (Coq.Pi _       r) = dropPi r
dropPi t                  = t

-- dropModuleName :: String -> String
-- dropModuleName s =
--   case elemIndices '.' s of
--   [] -> s
--   indices ->
--     let lastIndex = last indices in
--     drop (lastIndex + 1) s

-- unqualifyTypeWithinConstructor :: Coq.Term -> Coq.Term
-- unqualifyTypeWithinConstructor = go
--   where
--     go (Coq.Pi bs t)  = Coq.Pi bs (go t)
--     go (Coq.App t as) = Coq.App (go t) as
--     go (Coq.Var v)    = Coq.Var (dropModuleName v)
--     go t              = error $ "Unexpected term in constructor: " ++ show t

translateCtor ::
  MonadCoqTrans m =>
  [Coq.Binder] -> -- list of parameters to drop from `ctorType`
  Ctor -> m Coq.Constructor
translateCtor inductiveParameters (Ctor {..}) = do
  let constructorName = translateIdentUnqualified ctorName
  constructorType <-
    -- Unfortunately, `ctorType` qualifies the inductive type's name in the
    -- return type.
    -- dropModuleNameWithinCtor <$>
    -- Unfortunately, `ctorType` comes with the inductive parameters universally
    -- quantified.
    (\ t -> iterate dropPi t !! length inductiveParameters) <$>
    translateTerm ctorType
  return $ Coq.Constructor
    { constructorName
    , constructorType
    }

translateDataType :: MonadCoqTrans m => DataType -> m Coq.Decl
translateDataType (DataType {..}) =
  case findSpecialTreatment dtName of
  Just st ->
    case st of
    MapsTo ident -> pure $ mapped  dtName ident
    Rename _     -> translate
    Skip         -> pure $ skipped dtName
  Nothing -> translate
  where
    translate = do
      let inductiveName = identName dtName -- TODO: do we want qualified?
      let mkParam (s, t) = do
            t' <- translateTerm t
            modify $ over environment (s :)
            return $ Coq.Binder s (Just t')
      let mkIndex (s, t) = do
            t' <- translateTerm t
            modify $ over environment (s :)
            let s' = case s of
                  "_" -> Nothing
                  _   -> Just s
            return $ Coq.PiBinder s' t'
      inductiveParameters   <- mapM mkParam dtParams
      inductiveIndices      <- mapM mkIndex dtIndices
      inductiveSort         <- translateSort dtSort
      inductiveConstructors <- mapM (translateCtor inductiveParameters) dtCtors
      return $ Coq.InductiveDecl $ Coq.Inductive
        { inductiveName
        , inductiveParameters
        , inductiveIndices
        , inductiveSort
        , inductiveConstructors
        }

translateModuleDecl :: MonadCoqTrans m => ModuleDecl -> m Coq.Decl
translateModuleDecl = \case
  TypeDecl dataType -> translateDataType dataType
  DefDecl definition -> translateDef definition

mapped :: Ident -> Ident -> Coq.Decl
mapped sawIdent newIdent =
  Coq.Comment $ show sawIdent ++ " is mapped to " ++ show newIdent

skipped :: Ident -> Coq.Decl
skipped sawIdent =
  Coq.Comment $ show sawIdent ++ " was skipped"

translateDef :: MonadCoqTrans m => Def -> m Coq.Decl
translateDef (Def {..}) =
  case findSpecialTreatment defIdent of
  Just st ->
    case st of
    MapsTo ident -> pure $ mapped  defIdent ident
    Rename _     -> translate
    Skip         -> pure $ skipped defIdent
  Nothing -> translate
  where
    translate =
      case defQualifier of
      NoQualifier ->
        case defBody of
        Nothing   -> error "Terms should have a body (unless axiom/primitive)"
        Just body -> Coq.Definition
                     <$> pure (translateIdentUnqualified defIdent)
                     <*> pure []
                     <*> (Just <$> translateTerm defType)
                     <*> translateTerm body
      AxiomQualifier -> Coq.Axiom
                        <$> pure (translateIdentUnqualified defIdent)
                        <*> translateTerm defType
      PrimQualifier -> Coq.Axiom
                       <$> pure (translateIdentUnqualified defIdent)
                       <*> translateTerm defType

translateSort :: MonadCoqTrans m => Sort -> m Coq.Sort
translateSort s = pure (if s == propSort then Coq.Prop else Coq.Type)

flatTermFToExpr ::
  MonadCoqTrans m =>
  (Term -> m Coq.Term) ->
  FlatTermF Term ->
  m Coq.Term
flatTermFToExpr go tf = -- traceFTermF "flatTermFToExpr" tf $
  case tf of
    GlobalDef i   -> pure (Coq.Var ("@" ++ translateIdent i))
    UnitValue     -> pure (Coq.Var "tt")
    UnitType      -> pure (Coq.Var "unit")
    PairValue x y -> Coq.App (Coq.Var "pair") <$> traverse go [x, y]
    PairType x y  -> Coq.App (Coq.Var "prod") <$> traverse go [x, y]
    PairLeft t    -> Coq.App (Coq.Var "fst") <$> traverse go [t]
    PairRight t   -> Coq.App (Coq.Var "snd") <$> traverse go [t]
    -- TODO: maybe have more customizable translation of data types
    DataTypeApp n is as -> do
      Coq.App (Coq.Var ("@" ++ translateIdentUnqualified n)) <$> traverse go (is ++ as)
    -- TODO: maybe have more customizable translation of data constructors
    CtorApp n is as -> do
      Coq.App (Coq.Var ("@" ++ translateIdentUnqualified n)) <$> traverse go (is ++ as)
    -- TODO: support this next!
    RecursorApp typeEliminated parameters motive eliminators indices termEliminated ->
      Coq.App (Coq.Var $ "@" ++ translateIdentUnqualified typeEliminated ++ "_rect") <$>
      (traverse go $
       parameters ++ [motive] ++ map snd eliminators ++ indices ++ [termEliminated]
      )
    Sort s -> Coq.Sort <$> translateSort s
    NatLit i -> pure (Coq.NatLit i)
    ArrayValue _ vec -> do
      config <- ask
      if translateVectorsAsCoqVectors config
        then
        let addElement accum element = do
              elementTerm <- go element
              return (Coq.App (Coq.Var "Vector.cons")
                      [Coq.Var "_", elementTerm, Coq.Var "_", accum]
                     )
        in
        foldM addElement (Coq.App (Coq.Var "Vector.nil") [Coq.Var "_"]) (Vector.reverse vec)
        else
        (Coq.List . Vector.toList) <$> traverse go vec  -- TODO: special case bit vectors?
    StringLit s -> pure (Coq.Scope (Coq.StringLit s) "string")
    ExtCns (EC _ _ _) -> notSupported

    -- NOTE: The following requires the coq-extensible-records library, because
    -- Coq records are nominal rather than structural
    -- In this library, record types are represented as:
    -- (record (Fields FSNil))                         is the type of the empty record
    -- (record (Fields (FSCons ("x" %e nat) FSNil)))   has one field "x" of type "nat"
    RecordType fs ->
      let makeField name typ = do
            typTerm <- go typ
            return (Coq.App (Coq.Var "@pair")
              [ Coq.Var "field"
              , Coq.Var "_"
              , Coq.Scope (Coq.StringLit name) "string"
              , typTerm
              ])
      in
      let addField accum (name, typ) = do
            fieldTerm <- makeField name typ
            return (Coq.App (Coq.Var "FScons") [fieldTerm, accum])
      in
      do
        fields <- foldM addField (Coq.Var "FSnil") fs
        return $ Coq.App (Coq.Var "record") [ Coq.App (Coq.Var "Fields") [fields] ]

    RecordValue fs ->
      let makeField name val = do
            valTerm <- go val
            return (Coq.App (Coq.Var "@record_singleton")
              [ Coq.Var "_"
              , Coq.Scope (Coq.StringLit name) "string"
              , valTerm
              ])
      in
      let addField accum (name, typ) = do
            fieldTerm <- makeField name typ
            return (Coq.App (Coq.Var "@Rjoin") [Coq.Var "_", Coq.Var "_", fieldTerm, accum])
      in
      foldM addField (Coq.Var "record_empty") fs
    RecordProj r f -> do
      rTerm <- go r
      return (Coq.App (Coq.Var "@Rget")
              [ Coq.Var "_"
              , rTerm
              , Coq.Scope (Coq.StringLit f) "string"
              , Coq.Var "_"
              , Coq.Ltac "simpl; exact eq_refl"
              ])
  where
    notSupported = Except.throwError $ NotSupported errorTerm
    --badTerm = throwError $ BadTerm errorTerm
    errorTerm = Unshared $ FTermF tf
    --asString (asFTermF -> Just (StringLit s)) = pure s
    --asString _ = badTerm

-- | Recognizes an $App (App "Cryptol.seq" n) x$ and returns ($n$, $x$).
asSeq :: Fail.MonadFail f => Recognizer f Term (Term, Term)
asSeq t = do (f, args) <- asApplyAllRecognizer t
             fid <- asGlobalDef f
             case (fid, args) of
               ("Cryptol.seq", [n, x]) -> return (n,x)
               _ -> Fail.fail "not a seq"

asApplyAllRecognizer :: Fail.MonadFail f => Recognizer f Term (Term, [Term])
asApplyAllRecognizer t = do _ <- asApp t
                            return $ asApplyAll t

mkDefinition :: Coq.Ident -> Coq.Term -> Coq.Decl
mkDefinition name (Coq.Lambda bs t) = Coq.Definition name bs Nothing t
mkDefinition name t = Coq.Definition name [] Nothing t

translateParams ::
  MonadCoqTrans m =>
  [(String, Term)] -> m [Coq.Binder]
translateParams [] = return []
translateParams ((n, ty):ps) = do
  ty' <- translateTerm ty
  modify $ over environment (n :)
  ps' <- translateParams ps
  return (Coq.Binder n (Just ty') : ps')

translatePiParams :: MonadCoqTrans m => [(String, Term)] -> m [Coq.PiBinder]
translatePiParams [] = return []
translatePiParams ((n, ty):ps) = do
  ty' <- translateTerm ty
  modify $ over environment (n :)
  ps' <- translatePiParams ps
  let n' = if n == "_" then Nothing else Just n
  return (Coq.PiBinder n' ty' : ps')

-- | Run a translation, but keep changes to the environment local to it,
-- restoring the current environment before returning.
withLocalEnvironment :: MonadCoqTrans m => m a -> m a
withLocalEnvironment action = do
  env <- view environment <$> get
  result <- action
  modify $ set environment env
  return result

-- | This is a convenient helper for when you want to add some bindings before
-- translating a term.
translateTermLocallyBinding :: MonadCoqTrans m => [String] -> Term -> m Coq.Term
translateTermLocallyBinding bindings term =
  withLocalEnvironment $ do
  modify $ over environment (bindings ++)
  translateTerm term

-- env is innermost first order
translateTerm :: MonadCoqTrans m => Term -> m Coq.Term
translateTerm t = withLocalEnvironment $ do -- traceTerm "translateTerm" t $
  env <- view environment <$> get
  case t of
    (asFTermF -> Just tf)  -> flatTermFToExpr (go env) tf
    (asPi -> Just _) -> do
      paramTerms <- translatePiParams params
      Coq.Pi <$> pure paramTerms
                 -- env is in innermost first (reverse) binder order
                 <*> go ((reverse paramNames) ++ env) e
        where
          -- params are in normal, outermost first, order
          (params, e) = asPiList t
          -- param names are in normal, outermost first, order
          paramNames = map fst $ params
    (asLambda -> Just _) -> do
      paramTerms <- translateParams params
      Coq.Lambda <$> pure paramTerms
                 -- env is in innermost first (reverse) binder order
                 <*> go ((reverse paramNames) ++ env) e
        where
          -- params are in normal, outermost first, order
          (params, e) = asLambdaList t
          -- param names are in normal, outermost first, order
          paramNames = map fst $ params
    (asApp -> Just _) ->
      -- asApplyAll: innermost argument first
      let (f, args) = asApplyAll t
      in case f of
           (asGlobalDef -> Just i) ->
             case i of
                "Prelude.ite" -> case args of
                  [_ty, c, tt, ft] ->
                    Coq.If <$> go env c <*> go env tt <*> go env ft
                  _ -> badTerm
                "Prelude.fix" -> case args of
                  [resultType, lambda] ->
                    case resultType of
                      -- TODO: check that 'n' is finite
                      (asSeq -> Just (n, _)) ->
                        case lambda of
                          (asLambda -> Just (x, ty, body)) | ty == resultType -> do
                              len <- go env n
                              -- let len = EC.App (EC.ModVar "size") [EC.ModVar x]
                              expr <- go (x:env) body
                              typ <- go env ty
                              return $ Coq.App (Coq.Var "iter") [len, Coq.Lambda [Coq.Binder x (Just typ)] expr, Coq.List []]
                          _ -> badTerm
                      _ -> notSupported
                  _ -> badTerm
                _ -> Coq.App <$> go env f
                             <*> traverse (go env) args

           _ -> Coq.App <$> go env f
                        <*> traverse (go env) args
    (asLocalVar -> Just n)
      | n < length env -> Coq.Var <$> pure (env !! n)
      | otherwise -> Except.throwError $ LocalVarOutOfBounds t
    (unwrapTermF -> Constant n body _) -> do
      configuration <- ask
      decls <- view declarations <$> get
      if | not (traverseConsts configuration) || any (matchDecl n) decls -> Coq.Var <$> pure n
         | otherwise -> do
             b <- go env body
             modify $ over declarations $ (mkDefinition n b :)
             Coq.Var <$> pure n
    _ -> {- trace "translateTerm fallthrough" -} notSupported
  where
    notSupported = Except.throwError $ NotSupported t
    badTerm = Except.throwError $ BadTerm t
    matchDecl n (Coq.Axiom n' _) = n == n'
    matchDecl _ (Coq.Comment _) = False
    matchDecl n (Coq.Definition n' _ _ _) = n == n'
    matchDecl n (Coq.InductiveDecl (Coq.Inductive n' _ _ _ _)) = n == n'
    go env term = do
      modify $ set environment env
      translateTerm term

runMonadCoqTrans ::
  TranslationConfiguration ->
  (forall m. MonadCoqTrans m => m a) ->
  Either (TranslationError Term) (a, TranslationState)
runMonadCoqTrans configuration m =
  runStateT (runReaderT m configuration) (TranslationState [] [])

-- Eventually, different modules will want different preambles, for now,
-- hardcoded.
preamblePlus :: Doc -> Doc
preamblePlus extraImports = vcat $
  [ "From Coq          Require Import Lists.List."
  , "From Coq          Require Import String."
  , "From Coq          Require Import Vectors.Vector."
  , "From CryptolToCoq Require Import Cryptol."
  , "From CryptolToCoq Require Import SAW."
  , "From Records      Require Import Records."
  , extraImports
  , ""
  , "Import ListNotations."
  , ""
  ]

preamble :: Doc
preamble = preamblePlus $ vcat []

translateTermToDocWith :: TranslationConfiguration -> (Coq.Term -> Doc) -> Term -> Either (TranslationError Term) Doc
translateTermToDocWith configuration _f t = do
  (_term, state) <- runMonadCoqTrans configuration (translateTerm t)
  let decls = view declarations state
  return
    $ ((vcat . intersperse hardline . map Coq.ppDecl . reverse) decls)
    -- <$$> (if null decls then empty else hardline)
    -- <$$> f term

translateDefDoc :: TranslationConfiguration -> Coq.Ident -> Term -> Either (TranslationError Term) Doc
translateDefDoc configuration name =
  translateTermToDocWith configuration (\ term -> Coq.ppDecl (mkDefinition name term))

translateTermAsDeclImports :: TranslationConfiguration -> Coq.Ident -> Term -> Either (TranslationError Term) Doc
translateTermAsDeclImports configuration name t = do
  doc <- translateDefDoc configuration name t
  return (preamble <$$> hardline <> doc)

translateDecl :: TranslationConfiguration -> ModuleDecl -> Doc
translateDecl configuration decl =
  case decl of
  TypeDecl td -> do
    case runMonadCoqTrans configuration (translateDataType td) of
      Left e -> error $ show e
      Right (tdecl, _) -> Coq.ppDecl tdecl
  DefDecl dd -> do
    case runMonadCoqTrans configuration (translateDef dd) of
      Left e -> error $ show e
      Right (tdecl, _) -> Coq.ppDecl tdecl

translateModule :: TranslationConfiguration -> Module -> Doc
translateModule configuration m =
  let name = show $ translateModuleName (moduleName m)
  in
  vcat $ []
  ++ [ text $ "Module " ++ name ++ "."
     , ""
     ]
  ++ [ translateDecl configuration decl | decl <- moduleDecls m ]
  ++ [ text $ "End " ++ name ++ "."
     ]
