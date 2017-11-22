module FStar.SepLogic.Heap

include FStar.Heap

type t = UInt64.t

type addr = ref t

abstract let restrict (h:heap) (r:addr) :heap
  = admit ()

abstract let minus (h:heap) (r:addr) :heap
  = admit ()

abstract let join (h1:heap) (h2:heap) :heap
  = admit ()

abstract let points_to (r:addr) (x:t) :heap
  = admit ()

abstract let sel (h:heap) (r:addr) :Tot t
  = admit ()

abstract let upd (h:heap) (r:addr) (x:t) :heap
  = admit ()


(***** Heap lemmas *****)

let lemma_join_restrict_minus (r:addr) (h:heap)
  :Lemma (requires True)
         (ensures  (join (restrict h r) (minus h r) == h))
	 [SMTPat (join (restrict h r) (minus h r))]
  = admit ()

let lemma_join_is_comm (h1:heap) (h2:heap)
  :Lemma (requires True)
         (ensures (join h1 h2) == (join h2 h1))
	 [SMTPat (join h1 h2)]
  = admit ()

let lemma_join_h_emp (h:heap)
  :Lemma (requires True)
         (ensures (join h emp) == h)
	 [SMTPat (join h emp)]
  = admit ()

let lemma_join_emp_h (h:heap)
  :Lemma (requires True)
         (ensures (join emp h) == h)
	 [SMTPat (join emp h)]
  = admit ()

let lemma_join_points_to_minus (h:heap) (r:addr) (x:t)
  :Lemma (requires True)
         (ensures join (points_to r x) (minus h r) == upd h r x)
	 [SMTPat (join (points_to r x) (minus h r))]
  = admit ()

let lemma_restrict_eq_points_to (r:addr) (h:heap)
  :Lemma (requires True)
         (ensures (restrict h r) == (points_to r (sel h r)))
	 [SMTPat (restrict h r)]
  = admit ()

let lemma_points_to_is_injective (r:addr) (x:t) (y:t)
  :Lemma (requires (points_to r x == points_to r y))
         (ensures  (x == y))
	 [SMTPat (points_to r x); SMTPat (points_to r y)]
  = admit ()


(***** Select lemmas *****)

let lemma_sel_r_update' (h:heap) (r:addr) (x:t) (n:t)
  :Lemma (requires x == n)
         (ensures sel (upd h r x) r == n)
  = admit ()

let lemma_sel_r1_update' (h:heap) (r:addr) (r1:addr) (x:t) (n:t)
  :Lemma (requires (addr_of r1 <> addr_of r) /\ (sel h r1 == n))
         (ensures sel (upd h r x) r1 == n)
  = admit ()

let lemma_sel_r_from_minus' (r:addr) (r1:addr) (h:heap) (n:t)
  :Lemma (requires (addr_of r1 <> addr_of r) /\ (sel h r == n))
         (ensures sel (minus h r1) r == n)
  = admit ()

let lemma_sel_r1_from_restrict' (h:heap) (r:addr) (r1:addr) (h1:heap) (n:t)
  :Lemma (requires (addr_of r1 <> addr_of r) /\ (sel h1 r1 == n))
         (ensures sel (join (restrict h r) h1) r1 == n)
  = admit ()


(***** Restrict lemmas *****)

let lemma_restrict_r_update' (h:heap) (r:addr) (x:t) (n:heap) (a:Type0)
  : Lemma (requires (points_to r x) == n <==> a)
          (ensures restrict (upd h r x) r == n <==> a)
  = admit ()
  
let lemma_restrict_r1_update' (h:heap) (r:addr) (r1:addr{addr_of r1 <> addr_of r}) (x:t) (n:heap) (a:Type0)
  :Lemma (requires restrict h r1 == n <==> a)
         (ensures restrict (upd h r x) r1 == n <==> a)
  = admit ()

let lemma_addr_not_eq_refl (r1:addr) (r2:addr)
  :Lemma (requires addr_of r1 <> addr_of r2)
         (ensures addr_of r2 <> addr_of r1)
	 [SMTPat (addr_of r1 <> addr_of r2)]
  = ()
