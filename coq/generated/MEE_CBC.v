From Coq          Require Import Lists.List.
Import            ListNotations.
From Coq          Require Import String.
From Coq          Require Import Vectors.Vector.
From CryptolToCoq Require Import SAWCoreScaffolding.
From CryptolToCoq Require Import SAWCoreVectorsAsCoqVectors.
From Records      Require Import Records.



From CryptolToCoq Require Import SAWCorePrelude.
Import SAWCorePrelude.
From CryptolToCoq Require Import CryptolScaffolding.
From CryptolToCoq Require Import CryptolPrimitivesForSAWCore.
Import CryptolPrimitives.
From CryptolToCoq Require Import CryptolPrimitivesForSAWCoreExtra.

Definition cbc_enc (n : (@Num)) (enc : ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (k : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (iv : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (ps : (@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))))  :=
  (iter (n) ((fun (cs : (@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) => (@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) (n))))) ((@CryptolPrimitives.seqMap ((prod ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) ((@SAWCorePrelude.uncurry ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((fun (p : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (c' : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) => (enc (k) ((@CryptolPrimitives.ecXor ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.PLogicSeq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PLogicSeqBool ((@TCNum (8))))))) (p) (c')))))))) ((@CryptolPrimitives.seqZip ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))) (ps) ((@CryptolPrimitives.ecCat ((@TCNum (1))) (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((Vector.cons (_) (iv) (_) ((Vector.nil (_))))) (cs)))))))))) ((CryptolPrimitives.seqConst (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((CryptolPrimitives.seqConst ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((CryptolPrimitives.seqConst ((@TCNum (8))) (@SAWCoreScaffolding.Bool) (SAWCoreScaffolding.False)))))))).

Definition cbc_dec (n : (@Num)) (dec : ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (k : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (iv : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (cs : (@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))))  :=
  (@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) (n))))) ((@CryptolPrimitives.seqMap ((prod ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.tcMin (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))))) ((@SAWCorePrelude.uncurry ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((fun (c : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (c' : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) => (@CryptolPrimitives.ecXor ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.PLogicSeq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PLogicSeqBool ((@TCNum (8))))))) ((dec (k) (c))) (c')))))) ((@CryptolPrimitives.seqZip ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (n) ((@CryptolPrimitives.tcAdd ((@TCNum (1))) (n))) (cs) ((@CryptolPrimitives.ecCat ((@TCNum (1))) (n) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((Vector.cons (_) (iv) (_) ((Vector.nil (_))))) (cs)))))))).

Definition repeat (n : (@Num)) (a : Type) (x : a)  :=
  (@CryptolPrimitives.seqMap (@SAWCoreScaffolding.Bool) (a) (n) ((fun (__p7 : @SAWCoreScaffolding.Bool) => x)) ((@CryptolPrimitives.ecZero ((@CryptolPrimitives.seq (n) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PZeroSeqBool (n)))))).

Definition pad (n : (@Num)) (p : (@Num)) (b : (@Num)) (msg : (@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (tag : (@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))  :=
  (@CryptolPrimitives.ecSplit ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (p))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (p))))) ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (p))))) ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))))))) ((@CryptolPrimitives.ecCat (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (p))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) (msg) ((@CryptolPrimitives.ecCat ((@TCNum (32))) (p) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) (tag) ((repeat (p) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.ecNumber (p) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PLiteralSeqBool ((@TCNum (8)))))))))))))))).

Definition take (front : (@Num)) (back : (@Num)) (a : Type) (__p1 : (@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd (front) (back))) (a)))  :=
  (fst ((@CryptolPrimitives.ecSplitAt (front) (back) (a) (__p1)))).

Definition drop (front : (@Num)) (back : (@Num)) (a : Type) (__p4 : (@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd (front) (back))) (a)))  :=
  (snd ((@CryptolPrimitives.ecSplitAt (front) (back) (a) (__p4)))).

Definition unpad (n : (@Num)) (p : (@Num)) (b : (@Num)) (ct : (@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))))  :=
  (pair ((take (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) (n))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) (n))))))))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))))))) ((@CryptolPrimitives.ecJoin ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) (ct))))))))) ((pair ((take ((@TCNum (32))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((drop (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd (n) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))))))))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))))))) ((@CryptolPrimitives.ecJoin ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) (ct))))))))))) ((@CryptolPrimitives.ecEq ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.PCmpSeq ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PCmpSeqBool ((@TCNum (8))))))) ((drop ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))))))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcMul ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))))) ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))))))) ((@CryptolPrimitives.ecJoin ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) (ct))))))))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq (p) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.seq_cong1 (p) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) (p) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))))) ((@CryptolPrimitives.tcAdd ((@TCNum (32))) (n))))))))) ((repeat (p) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.ecNumber (p) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PLiteralSeqBool ((@TCNum (8)))))))))))))))).

Definition unpad_pad_good_1000_256 (msg : (@CryptolPrimitives.seq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (tag : (@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))  :=
  (@CryptolPrimitives.ecEq ((prod ((@CryptolPrimitives.seq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((prod ((@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.PCmpPair ((@CryptolPrimitives.seq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((prod ((@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PCmpSeq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PCmpSeqBool ((@TCNum (8))))))) ((@CryptolPrimitives.PCmpPair ((@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (@SAWCoreScaffolding.Bool) ((@CryptolPrimitives.PCmpSeq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PCmpSeqBool ((@TCNum (8))))))) (@CryptolPrimitives.PCmpBit))))) ((unpad ((@TCNum (1000))) ((@TCNum (104))) ((@TCNum (69))) ((pad ((@TCNum (1000))) ((@TCNum (104))) ((@TCNum (69))) (msg) (tag))))) ((pair (msg) ((pair (tag) (@SAWCoreScaffolding.True)))))).

Definition mee_enc (n : (@Num)) (p : (@Num)) (b : (@Num)) (enc : ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (sign : ((@CryptolPrimitives.seq ((@TCNum (64))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (ekey : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (skey : (@CryptolPrimitives.seq ((@TCNum (64))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (iv : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (msg : (@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))  :=
  (cbc_enc ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) (enc) (ekey) (iv) ((pad (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) (b))) (n))) (b) (msg) ((sign (skey) (msg)))))).

Definition and (x : @SAWCoreScaffolding.Bool) (y : @SAWCoreScaffolding.Bool)  :=
  if x then y else @SAWCoreScaffolding.False.

Definition mee_dec (n : (@Num)) (p : (@Num)) (b : (@Num)) (dec : ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (sign : ((@CryptolPrimitives.seq ((@TCNum (64))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq (n) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (ekey : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (skey : (@CryptolPrimitives.seq ((@TCNum (64))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (iv : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (ct : (@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))))  :=
  (pair ((fst ((unpad (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) (b))) (n))) (b) ((cbc_dec ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) (dec) (ekey) (iv) (ct))))))) ((and ((snd ((snd ((unpad (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) (b))) (n))) (b) ((cbc_dec ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) (dec) (ekey) (iv) (ct))))))))) ((@CryptolPrimitives.ecEq ((@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@CryptolPrimitives.PCmpSeq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PCmpSeqBool ((@TCNum (8))))))) ((sign (skey) ((fst ((unpad (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) (b))) (n))) (b) ((cbc_dec ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) (dec) (ekey) (iv) (ct))))))))) ((fst ((snd ((unpad (n) ((@CryptolPrimitives.tcSub ((@CryptolPrimitives.tcMul ((@TCNum (16))) (b))) (n))) (b) ((cbc_dec ((@CryptolPrimitives.tcAdd ((@TCNum (2))) (b))) (dec) (ekey) (iv) (ct)))))))))))))).

Definition mee_enc_dec_good_1000 (enc : ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (dec : ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (sign : ((@CryptolPrimitives.seq ((@TCNum (64))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> ((@CryptolPrimitives.seq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) -> (@CryptolPrimitives.seq ((@TCNum (32))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (ekey : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (skey : (@CryptolPrimitives.seq ((@TCNum (64))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (iv : (@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (msg : (@CryptolPrimitives.seq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool)))))  :=
  (@CryptolPrimitives.ecEq ((prod ((@CryptolPrimitives.seq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PCmpPair ((@CryptolPrimitives.seq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) (@SAWCoreScaffolding.Bool) ((@CryptolPrimitives.PCmpSeq ((@TCNum (1000))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))) ((@CryptolPrimitives.PCmpSeqBool ((@TCNum (8))))))) (@CryptolPrimitives.PCmpBit))) ((mee_dec ((@TCNum (1000))) ((@TCNum (104))) ((@TCNum (69))) (dec) (sign) (ekey) (skey) (iv) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@TCNum (71))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd ((@TCNum (2))) ((@TCNum (69))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq_cong1 ((@TCNum (71))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) ((@TCNum (69))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@TCNum (71))) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) ((@TCNum (69))))))))) ((@SAWCoreScaffolding.coerce ((@CryptolPrimitives.seq ((@CryptolPrimitives.tcAdd ((@TCNum (2))) ((@TCNum (69))))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq ((@TCNum (71))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))))) ((@CryptolPrimitives.seq_cong1 ((@CryptolPrimitives.tcAdd ((@TCNum (2))) ((@TCNum (69))))) ((@TCNum (71))) ((@CryptolPrimitives.seq ((@TCNum (16))) ((@CryptolPrimitives.seq ((@TCNum (8))) (@SAWCoreScaffolding.Bool))))) ((@SAWCorePrelude.sawUnsafeAssert ((@Num)) ((@CryptolPrimitives.tcAdd ((@TCNum (2))) ((@TCNum (69))))) ((@TCNum (71))))))) ((mee_enc ((@TCNum (1000))) ((@TCNum (104))) ((@TCNum (69))) (enc) (sign) (ekey) (skey) (iv) (msg))))))))) ((pair (msg) (@SAWCoreScaffolding.True)))).
