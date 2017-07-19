module Lang

open FStar.Seq
open FStar.Set

type addr = nat

type heap = {
  
  set addr * (s:seq nat{length s = size})

let dom (s:heap) :set addr = fst s

let memory (s:heap) :(s:seq nat{length s = size}) = snd s

let equal (h1:heap) (h2:heap)

let op_String_Access (s:heap) (id:addr) :nat = index (memory s) id
let op_String_Assignment (s:heap) (id:addr) (v:nat) :heap = (dom s, Seq.upd (memory s) id v)
let contains (s:heap) (id:addr) :Type0 = Set.mem id (dom s)

let disjoint (s1:heap) (s2:heap) :Type0 = Set.disjoint (dom s1) (dom s2)

let join (s1:heap) (s2:heap{disjoint s1 s2}) :(s:heap{dom s == Set.union (dom s1) (dom s2)              /\
                                                      (forall (i:addr). s1 `contains` i ==> s.[i] == s1.[i]) /\
                                                      (forall (i:addr). s2 `contains` i ==> s.[i] == s2.[i])})
  = admit ()

type loop_result (a:Type0) =
  | Done : v:a   -> loop_result a
  | Again: acc:a -> loop_result a

noeq type command :Type0 -> Type =
  | Return: #a:Type -> v:a -> command a
  | Bind  : #a:Type0 -> #b:Type0 -> c1:command a -> c2:(a -> command b) -> command b
  | Loop  : #a:Type0 -> acc:a -> f:(a -> command (loop_result a)) -> command a
  | Fail  : #a:Type0 -> command a
  | Read  : id:addr -> command nat
  | Write : id:addr -> v:nat -> command unit
  | Alloc : command addr
  | Free  : id:addr -> command unit

(*
 * a bit hacky, since a program may not terminate
 *)
assume val interpreted_in (#a:Type0) (c:command a) (h:heap) :Tot (a * heap)

type heap_predicate = heap -> Type0

let emp (h:heap) :Type0 = dom h == Set.empty

let lemma_disjoint_emp (h1:heap) (h2:heap)
  :Lemma (requires (emp h2))
         (ensures  (disjoint h1 h2))
	 [SMTPat (disjoint h1 h2); SMTPat (emp h2)]
  = assert (Set.equal (Set.intersect (dom h1) (dom h2)) Set.empty)

let lemma_join_emp (h1:heap) (h2:heap)
  :Lemma (requires (emp h2))
         (ensures  (disjoint h1 h2 /\ join h1 h2 == h1))
  = assert (Set.equal (dom h1) (dom (join h1 h2)));
    assert (Seq.equal (memory h1) (memory (join h1 h2)))

let points_to (id:addr) (n:nat) (h:heap) :Type0 = dom h == Set.singleton id /\ h.[id] == n

let lift (phi:Type0) (h:heap) :Type0 = phi /\ emp h

let exists_x (#a:Type0) (pred:a -> heap_predicate) (h:heap) :Type0
  = exists (x:a). pred x h

let star (p:heap_predicate) (q:heap_predicate) (h:heap) :Type0
  = exists (h1:heap) (h2:heap). disjoint h1 h2 /\ h == join h1 h2 /\ p h1 /\ q h2

let iff (p:heap_predicate) (q:heap_predicate) :Type0 = forall (h:heap). p h <==> q h

let imp (p:heap_predicate) (q:heap_predicate) :Type0 = forall (h:heap). p h ==> q h

(* some algebraic laws on the predicates *)

let lemma1_helper (phi:Type0) (p:heap_predicate) (q:heap_predicate) (h:heap)
  :Lemma (requires ((phi ==> (p `imp` q)) /\
                    (star p (lift phi) h)))
         (ensures  (q h))
  = assert (exists (h1:heap) (h2:heap). disjoint h1 h2 /\ h == join h1 h2 /\ p h1 /\ ((lift phi) h2) /\ emp h2 /\ phi /\ q h1);
    admit ()



type c_pre            = heap_predicate
type c_post (a:Type0) = a -> heap_predicate

type hoare_triple (#a:Type0) (pre:c_pre) (c:command a) (post:c_post a)
  = forall (h0:heap) (h1:heap) (r:a). (pre h0 /\ (c `interpreted_in` h0 == (r, h1))) ==> post r h1

(* all the following rules are conditioned on termination *)
let lemma_return (#a:Type0) (v:a) (pre:c_pre)
  :Lemma (requires True)  
         (ensures (let post :(c_post a) = fun r -> pre `star` (lift (r == v)) in
                   hoare_triple pre (Return v) post))
  = admit ()

let lemma_bind (#a:Type0) (#b:Type0) (c1:command a) (c2:a -> command b)
  (pre:c_pre) (post:c_post b)
  :Lemma (requires (exists (q:c_post a). (hoare_triple pre c1 q /\ (forall (r:a). hoare_triple (q r) (c2 r) post))))
	 (ensures  (hoare_triple pre (Bind c1 c2) post))
  = admit ()

let lemma_loop (#a:Type0) (acc:a) (f:a -> command (loop_result a)) (inv:c_post (loop_result a))
  :Lemma (requires (forall (j:a). hoare_triple (inv (Again j)) (f j) inv))
         (ensures  (hoare_triple (inv (Again acc))
	                         (Loop acc f)
				 (fun r -> inv (Done r))))
  = admit ()

let lemma_fail (#a:Type0)
  :Lemma (requires True)
         (ensures  (hoare_triple (lift False) (Fail #a) (fun _ -> lift False)))
  = admit ()

(* making it let ... = admit () does not verify *)
assume val lemma_consequence (#a:Type0) (c:command a) (p':c_pre) (q':c_post a)
  :Lemma (requires (forall (p:c_pre) (q:c_post a). hoare_triple p c q /\ p' `imp` p /\ (forall (r:a). q r `imp` q' r)))
         (ensures  (hoare_triple p' c q'))

let lemma_read (id:addr) (r:c_post nat)
  :Lemma (requires True)
         (ensures  (hoare_triple (exists_x (fun v -> id `points_to` v `star` (r v)))
	                         (Read id)
				 (fun (x:nat) -> (id `points_to` x) `star` (r x))))
  = admit ()

let lemma_write (id:addr) (v:nat)
  :Lemma (requires True)
         (ensures  (hoare_triple (exists_x (fun v' -> id `points_to` v'))
	                         (Write id v)
				 (fun _ -> id `points_to` v)))
  = admit ()

let lemma_alloc (u:unit)
  :Lemma (requires True)
         (ensures  (hoare_triple emp Alloc (fun r -> r `points_to` 0)))
  = admit ()

let lemma_free (id:addr)
  :Lemma (requires True)
         (ensures  (hoare_triple (exists_x (fun v -> id `points_to` v))
	                         (Free id)
				 (fun _ -> emp)))
  = admit ()

(* get the nice x <-- c1; c2 syntax *)
let bind (#a:Type0) (#b:Type0) (c1:command a) (c2:a -> command b) :command b = Bind c1 c2


