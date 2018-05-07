open Prims
type goal =
  {
  context: FStar_TypeChecker_Env.env ;
  witness: FStar_Syntax_Syntax.term ;
  goal_ty: FStar_Syntax_Syntax.typ ;
  opts: FStar_Options.optionstate ;
  is_guard: Prims.bool }
let (__proj__Mkgoal__item__context : goal -> FStar_TypeChecker_Env.env) =
  fun projectee  ->
    match projectee with
    | { context = __fname__context; witness = __fname__witness;
        goal_ty = __fname__goal_ty; opts = __fname__opts;
        is_guard = __fname__is_guard;_} -> __fname__context
  
let (__proj__Mkgoal__item__witness : goal -> FStar_Syntax_Syntax.term) =
  fun projectee  ->
    match projectee with
    | { context = __fname__context; witness = __fname__witness;
        goal_ty = __fname__goal_ty; opts = __fname__opts;
        is_guard = __fname__is_guard;_} -> __fname__witness
  
let (__proj__Mkgoal__item__goal_ty : goal -> FStar_Syntax_Syntax.typ) =
  fun projectee  ->
    match projectee with
    | { context = __fname__context; witness = __fname__witness;
        goal_ty = __fname__goal_ty; opts = __fname__opts;
        is_guard = __fname__is_guard;_} -> __fname__goal_ty
  
let (__proj__Mkgoal__item__opts : goal -> FStar_Options.optionstate) =
  fun projectee  ->
    match projectee with
    | { context = __fname__context; witness = __fname__witness;
        goal_ty = __fname__goal_ty; opts = __fname__opts;
        is_guard = __fname__is_guard;_} -> __fname__opts
  
let (__proj__Mkgoal__item__is_guard : goal -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | { context = __fname__context; witness = __fname__witness;
        goal_ty = __fname__goal_ty; opts = __fname__opts;
        is_guard = __fname__is_guard;_} -> __fname__is_guard
  
let (subst_goal : FStar_Syntax_Syntax.subst_t -> goal -> goal) =
  fun subst1  ->
    fun goal  ->
      let uu___77_86 = goal  in
      let uu____87 = FStar_TypeChecker_Env.rename_env subst1 goal.context  in
      let uu____88 = FStar_Syntax_Subst.subst subst1 goal.witness  in
      let uu____89 = FStar_Syntax_Subst.subst subst1 goal.goal_ty  in
      {
        context = uu____87;
        witness = uu____88;
        goal_ty = uu____89;
        opts = (uu___77_86.opts);
        is_guard = (uu___77_86.is_guard)
      }
  
type guard_policy =
  | Goal 
  | SMT 
  | Force 
  | Drop 
let (uu___is_Goal : guard_policy -> Prims.bool) =
  fun projectee  -> match projectee with | Goal  -> true | uu____95 -> false 
let (uu___is_SMT : guard_policy -> Prims.bool) =
  fun projectee  -> match projectee with | SMT  -> true | uu____101 -> false 
let (uu___is_Force : guard_policy -> Prims.bool) =
  fun projectee  ->
    match projectee with | Force  -> true | uu____107 -> false
  
let (uu___is_Drop : guard_policy -> Prims.bool) =
  fun projectee  -> match projectee with | Drop  -> true | uu____113 -> false 
type proofstate =
  {
  main_context: FStar_TypeChecker_Env.env ;
  main_goal: goal ;
  all_implicits: FStar_TypeChecker_Env.implicits ;
  goals: goal Prims.list ;
  smt_goals: goal Prims.list ;
  depth: Prims.int ;
  __dump: proofstate -> Prims.string -> unit ;
  psc: FStar_TypeChecker_Normalize.psc ;
  entry_range: FStar_Range.range ;
  guard_policy: guard_policy ;
  freshness: Prims.int }
let (__proj__Mkproofstate__item__main_context :
  proofstate -> FStar_TypeChecker_Env.env) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__main_context
  
let (__proj__Mkproofstate__item__main_goal : proofstate -> goal) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__main_goal
  
let (__proj__Mkproofstate__item__all_implicits :
  proofstate -> FStar_TypeChecker_Env.implicits) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__all_implicits
  
let (__proj__Mkproofstate__item__goals : proofstate -> goal Prims.list) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__goals
  
let (__proj__Mkproofstate__item__smt_goals : proofstate -> goal Prims.list) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__smt_goals
  
let (__proj__Mkproofstate__item__depth : proofstate -> Prims.int) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__depth
  
let (__proj__Mkproofstate__item____dump :
  proofstate -> proofstate -> Prims.string -> unit) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname____dump
  
let (__proj__Mkproofstate__item__psc :
  proofstate -> FStar_TypeChecker_Normalize.psc) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__psc
  
let (__proj__Mkproofstate__item__entry_range :
  proofstate -> FStar_Range.range) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__entry_range
  
let (__proj__Mkproofstate__item__guard_policy : proofstate -> guard_policy) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__guard_policy
  
let (__proj__Mkproofstate__item__freshness : proofstate -> Prims.int) =
  fun projectee  ->
    match projectee with
    | { main_context = __fname__main_context; main_goal = __fname__main_goal;
        all_implicits = __fname__all_implicits; goals = __fname__goals;
        smt_goals = __fname__smt_goals; depth = __fname__depth;
        __dump = __fname____dump; psc = __fname__psc;
        entry_range = __fname__entry_range;
        guard_policy = __fname__guard_policy;
        freshness = __fname__freshness;_} -> __fname__freshness
  
let (subst_proof_state :
  FStar_Syntax_Syntax.subst_t -> proofstate -> proofstate) =
  fun subst1  ->
    fun ps  ->
      let uu____501 = FStar_Options.tactic_raw_binders ()  in
      if uu____501
      then ps
      else
        (let uu___78_503 = ps  in
         let uu____504 = subst_goal subst1 ps.main_goal  in
         let uu____505 = FStar_List.map (subst_goal subst1) ps.goals  in
         {
           main_context = (uu___78_503.main_context);
           main_goal = uu____504;
           all_implicits = (uu___78_503.all_implicits);
           goals = uu____505;
           smt_goals = (uu___78_503.smt_goals);
           depth = (uu___78_503.depth);
           __dump = (uu___78_503.__dump);
           psc = (uu___78_503.psc);
           entry_range = (uu___78_503.entry_range);
           guard_policy = (uu___78_503.guard_policy);
           freshness = (uu___78_503.freshness)
         })
  
let (decr_depth : proofstate -> proofstate) =
  fun ps  ->
    let uu___79_513 = ps  in
    {
      main_context = (uu___79_513.main_context);
      main_goal = (uu___79_513.main_goal);
      all_implicits = (uu___79_513.all_implicits);
      goals = (uu___79_513.goals);
      smt_goals = (uu___79_513.smt_goals);
      depth = (ps.depth - (Prims.parse_int "1"));
      __dump = (uu___79_513.__dump);
      psc = (uu___79_513.psc);
      entry_range = (uu___79_513.entry_range);
      guard_policy = (uu___79_513.guard_policy);
      freshness = (uu___79_513.freshness)
    }
  
let (incr_depth : proofstate -> proofstate) =
  fun ps  ->
    let uu___80_519 = ps  in
    {
      main_context = (uu___80_519.main_context);
      main_goal = (uu___80_519.main_goal);
      all_implicits = (uu___80_519.all_implicits);
      goals = (uu___80_519.goals);
      smt_goals = (uu___80_519.smt_goals);
      depth = (ps.depth + (Prims.parse_int "1"));
      __dump = (uu___80_519.__dump);
      psc = (uu___80_519.psc);
      entry_range = (uu___80_519.entry_range);
      guard_policy = (uu___80_519.guard_policy);
      freshness = (uu___80_519.freshness)
    }
  
let (tracepoint : proofstate -> unit) =
  fun ps  ->
    let uu____525 =
      (FStar_Options.tactic_trace ()) ||
        (let uu____527 = FStar_Options.tactic_trace_d ()  in
         ps.depth <= uu____527)
       in
    if uu____525
    then
      let uu____528 =
        let uu____529 = FStar_TypeChecker_Normalize.psc_subst ps.psc  in
        subst_proof_state uu____529 ps  in
      ps.__dump uu____528 "TRACE"
    else ()
  
let (set_ps_psc :
  FStar_TypeChecker_Normalize.psc -> proofstate -> proofstate) =
  fun psc  ->
    fun ps  ->
      let uu___81_541 = ps  in
      {
        main_context = (uu___81_541.main_context);
        main_goal = (uu___81_541.main_goal);
        all_implicits = (uu___81_541.all_implicits);
        goals = (uu___81_541.goals);
        smt_goals = (uu___81_541.smt_goals);
        depth = (uu___81_541.depth);
        __dump = (uu___81_541.__dump);
        psc;
        entry_range = (uu___81_541.entry_range);
        guard_policy = (uu___81_541.guard_policy);
        freshness = (uu___81_541.freshness)
      }
  
let (set_proofstate_range : proofstate -> FStar_Range.range -> proofstate) =
  fun ps  ->
    fun r  ->
      let uu___82_552 = ps  in
      let uu____553 =
        let uu____554 = FStar_Range.def_range r  in
        FStar_Range.set_def_range ps.entry_range uu____554  in
      {
        main_context = (uu___82_552.main_context);
        main_goal = (uu___82_552.main_goal);
        all_implicits = (uu___82_552.all_implicits);
        goals = (uu___82_552.goals);
        smt_goals = (uu___82_552.smt_goals);
        depth = (uu___82_552.depth);
        __dump = (uu___82_552.__dump);
        psc = (uu___82_552.psc);
        entry_range = uu____553;
        guard_policy = (uu___82_552.guard_policy);
        freshness = (uu___82_552.freshness)
      }
  
type direction =
  | TopDown 
  | BottomUp 
let (uu___is_TopDown : direction -> Prims.bool) =
  fun projectee  ->
    match projectee with | TopDown  -> true | uu____560 -> false
  
let (uu___is_BottomUp : direction -> Prims.bool) =
  fun projectee  ->
    match projectee with | BottomUp  -> true | uu____566 -> false
  