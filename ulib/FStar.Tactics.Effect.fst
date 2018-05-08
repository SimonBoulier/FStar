module FStar.Tactics.Effect

open FStar.Tactics.Types
open FStar.Tactics.Result

(* This module is extracted, don't add any `assume val`s or extraction
 * will break. (`synth_by_tactic` is fine) *)

let __tac (a:Type) = proofstate -> M (__result a)

(* monadic return *)
val __ret : a:Type -> x:a -> __tac a
let __ret a x = fun (s:proofstate) -> Success x s

(* monadic bind *)
let __bind (a:Type) (b:Type) (r1 r2:range) (t1:__tac a) (t2:a -> __tac b) : __tac b =
    fun ps ->
        let ps = set_proofstate_range ps (FStar.Range.prims_to_fstar_range r1) in
        let ps = incr_depth ps in
        let r = t1 ps in
        match r with
        | Success a ps' ->
            let ps' = set_proofstate_range ps' (FStar.Range.prims_to_fstar_range r2) in
            // Force evaluation of __tracepoint q
            begin match tracepoint ps' with
            | () -> t2 a (decr_depth ps')
            end
        | Failed msg ps' -> Failed msg ps'

(* Actions *)
let __get () : __tac proofstate = fun s0 -> Success s0 s0

let __tac_wp a = proofstate -> (__result a -> Tot Type0) -> Tot Type0

(*
 * The DMFF-generated `bind_wp` doesn't the contain the "don't duplicate the post-condition"
 * optimization, which causes VCs (for well-formedness of tactics) to blow up.
 *
 * Plus, we don't need to model the ranges and depths: they make no difference since the
 * proofstate type is abstract and the SMT never sees a concrete one.
 *
 * So, override `bind_wp` for the effect with an efficient one.
 *)
unfold let g_bind (a:Type) (b:Type) (wp:__tac_wp a) (f:a -> __tac_wp b) = fun ps post ->
    wp ps (fun m' -> match m' with
                     | Success a q -> f a q post
                     | Failed msg q -> post (Failed msg q))

unfold let g_compact (a:Type) (wp:__tac_wp a) : __tac_wp a =
    fun ps post -> forall k. (forall (r:__result a).{:pattern (guard_free (k r))} post r ==> k r) ==> wp ps k

unfold let __TAC_eff_override_bind_wp (r:range) (a:Type) (b:Type) (wp:__tac_wp a) (f:a -> __tac_wp b) =
    g_compact b (g_bind a b wp f)

(* total  *) //disable the termination check, although it remains reifiable
[@ dm4f_bind_range ]
reifiable reflectable new_effect {
  TAC : a:Type -> Effect
  with repr     = __tac
     ; bind     = __bind
     ; return   = __ret
     ; __get    = __get
}
effect Tac  (a:Type) = TAC a (fun i post -> forall j. post j)
effect TacF (a:Type) = TAC a (fun _ _ -> False) // A variant that doesn't prove totality (nor type safety!)

unfold
let lift_div_tac (a:Type) (wp:pure_wp a) : __tac_wp a =
    fun ps p -> wp (fun x -> p (Success x ps))

sub_effect DIV ~> TAC = lift_div_tac

abstract
let __by_tactic (t:__tac 'a) (p:Type) : Type = p

unfold let by_tactic (t : unit -> Tac 'a) (p:Type) : Type = __by_tactic (reify (t ())) p

// This will run the tactic in order to (try to) produce a term of type t
// It should not lead to any inconsistency, as any time this term appears
// during typechecking, it is forced to be fully applied and the tactic
// is run. A failure of the tactic is a typechecking failure.
// TODO: `a` is really fixed to unit for now. Make it consistent
assume val synth_by_tactic : (#t:Type) -> (unit -> Tac unit) -> Tot t

let assert_by_tactic (p:Type) (t:unit -> Tac unit)
  : Pure unit
         (requires (set_range_of (by_tactic t (squash p)) (range_of t)))
         (ensures (fun _ -> p))
  = ()

(* We don't peel off all `by_tactic`s in negative positions, so give the SMT a way to reason about them *)
val by_tactic_seman : a:Type -> tau:(unit -> Tac a) -> phi:Type -> Lemma (by_tactic tau phi ==> phi) [SMTPat (by_tactic tau phi)]
let by_tactic_seman a tau phi = ()

// TcTerm needs these two names typecheck tactics against
private let tactic a = unit -> TacF a // we don't care if the tactic is satisfiable before running it
private let reify_tactic (t : tactic 'a) : __tac 'a = reify (t ())
