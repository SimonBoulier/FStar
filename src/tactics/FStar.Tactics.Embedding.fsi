#light "off"
module FStar.Tactics.Embedding

open FStar.Ident
open FStar.Syntax.Syntax
open FStar.Syntax.Embeddings
open FStar.Tactics.Types
open FStar.Tactics.Result

val e_proofstate   : embedding<proofstate>
val e_result       : embedding<'a> -> embedding<__result<'a>>
val e_direction    : embedding<direction>
val e_guard_policy : embedding<guard_policy>

val unfold_lazy_proofstate : lazyinfo -> term

val t_proofstate : term
val t_guard_policy : term

val fstar_tactics_lid' : list<string> -> FStar.Ident.lid
