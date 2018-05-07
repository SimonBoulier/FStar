open Prims
let (desugar_disjunctive_pattern :
  FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t Prims.list ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.branch Prims.list)
  =
  fun pats  ->
    fun when_opt  ->
      fun branch1  ->
        FStar_All.pipe_right pats
          (FStar_List.map
             (fun pat  -> FStar_Syntax_Util.branch (pat, when_opt, branch1)))
  
let (trans_aqual :
  FStar_Parser_AST.arg_qualifier FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
  =
  fun uu___111_66  ->
    match uu___111_66 with
    | FStar_Pervasives_Native.Some (FStar_Parser_AST.Implicit ) ->
        FStar_Pervasives_Native.Some FStar_Syntax_Syntax.imp_tag
    | FStar_Pervasives_Native.Some (FStar_Parser_AST.Equality ) ->
        FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Equality
    | uu____71 -> FStar_Pervasives_Native.None
  
let (trans_qual :
  FStar_Range.range ->
    FStar_Ident.lident FStar_Pervasives_Native.option ->
      FStar_Parser_AST.qualifier -> FStar_Syntax_Syntax.qualifier)
  =
  fun r  ->
    fun maybe_effect_id  ->
      fun uu___112_90  ->
        match uu___112_90 with
        | FStar_Parser_AST.Private  -> FStar_Syntax_Syntax.Private
        | FStar_Parser_AST.Assumption  -> FStar_Syntax_Syntax.Assumption
        | FStar_Parser_AST.Unfold_for_unification_and_vcgen  ->
            FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen
        | FStar_Parser_AST.Inline_for_extraction  ->
            FStar_Syntax_Syntax.Inline_for_extraction
        | FStar_Parser_AST.NoExtract  -> FStar_Syntax_Syntax.NoExtract
        | FStar_Parser_AST.Irreducible  -> FStar_Syntax_Syntax.Irreducible
        | FStar_Parser_AST.Logic  -> FStar_Syntax_Syntax.Logic
        | FStar_Parser_AST.TotalEffect  -> FStar_Syntax_Syntax.TotalEffect
        | FStar_Parser_AST.Effect_qual  -> FStar_Syntax_Syntax.Effect
        | FStar_Parser_AST.New  -> FStar_Syntax_Syntax.New
        | FStar_Parser_AST.Abstract  -> FStar_Syntax_Syntax.Abstract
        | FStar_Parser_AST.Opaque  ->
            (FStar_Errors.log_issue r
               (FStar_Errors.Warning_DeprecatedOpaqueQualifier,
                 "The 'opaque' qualifier is deprecated since its use was strangely schizophrenic. There were two overloaded uses: (1) Given 'opaque val f : t', the behavior was to exclude the definition of 'f' to the SMT solver. This corresponds roughly to the new 'irreducible' qualifier. (2) Given 'opaque type t = t'', the behavior was to provide the definition of 't' to the SMT solver, but not to inline it, unless absolutely required for unification. This corresponds roughly to the behavior of 'unfoldable' (which is currently the default).");
             FStar_Syntax_Syntax.Visible_default)
        | FStar_Parser_AST.Reflectable  ->
            (match maybe_effect_id with
             | FStar_Pervasives_Native.None  ->
                 FStar_Errors.raise_error
                   (FStar_Errors.Fatal_ReflectOnlySupportedOnEffects,
                     "Qualifier reflect only supported on effects") r
             | FStar_Pervasives_Native.Some effect_id ->
                 FStar_Syntax_Syntax.Reflectable effect_id)
        | FStar_Parser_AST.Reifiable  -> FStar_Syntax_Syntax.Reifiable
        | FStar_Parser_AST.Noeq  -> FStar_Syntax_Syntax.Noeq
        | FStar_Parser_AST.Unopteq  -> FStar_Syntax_Syntax.Unopteq
        | FStar_Parser_AST.DefaultEffect  ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_DefaultQualifierNotAllowedOnEffects,
                "The 'default' qualifier on effects is no longer supported")
              r
        | FStar_Parser_AST.Inline  ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_UnsupportedQualifier,
                "Unsupported qualifier") r
        | FStar_Parser_AST.Visible  ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_UnsupportedQualifier,
                "Unsupported qualifier") r
  
let (trans_pragma : FStar_Parser_AST.pragma -> FStar_Syntax_Syntax.pragma) =
  fun uu___113_99  ->
    match uu___113_99 with
    | FStar_Parser_AST.SetOptions s -> FStar_Syntax_Syntax.SetOptions s
    | FStar_Parser_AST.ResetOptions sopt ->
        FStar_Syntax_Syntax.ResetOptions sopt
    | FStar_Parser_AST.LightOff  -> FStar_Syntax_Syntax.LightOff
  
let (as_imp :
  FStar_Parser_AST.imp ->
    FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
  =
  fun uu___114_110  ->
    match uu___114_110 with
    | FStar_Parser_AST.Hash  ->
        FStar_Pervasives_Native.Some FStar_Syntax_Syntax.imp_tag
    | uu____113 -> FStar_Pervasives_Native.None
  
let arg_withimp_e :
  'Auu____120 .
    FStar_Parser_AST.imp ->
      'Auu____120 ->
        ('Auu____120,FStar_Syntax_Syntax.arg_qualifier
                       FStar_Pervasives_Native.option)
          FStar_Pervasives_Native.tuple2
  = fun imp  -> fun t  -> (t, (as_imp imp)) 
let arg_withimp_t :
  'Auu____145 .
    FStar_Parser_AST.imp ->
      'Auu____145 ->
        ('Auu____145,FStar_Syntax_Syntax.arg_qualifier
                       FStar_Pervasives_Native.option)
          FStar_Pervasives_Native.tuple2
  =
  fun imp  ->
    fun t  ->
      match imp with
      | FStar_Parser_AST.Hash  ->
          (t, (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.imp_tag))
      | uu____164 -> (t, FStar_Pervasives_Native.None)
  
let (contains_binder : FStar_Parser_AST.binder Prims.list -> Prims.bool) =
  fun binders  ->
    FStar_All.pipe_right binders
      (FStar_Util.for_some
         (fun b  ->
            match b.FStar_Parser_AST.b with
            | FStar_Parser_AST.Annotated uu____181 -> true
            | uu____186 -> false))
  
let rec (unparen : FStar_Parser_AST.term -> FStar_Parser_AST.term) =
  fun t  ->
    match t.FStar_Parser_AST.tm with
    | FStar_Parser_AST.Paren t1 -> unparen t1
    | uu____193 -> t
  
let (tm_type_z : FStar_Range.range -> FStar_Parser_AST.term) =
  fun r  ->
    let uu____199 =
      let uu____200 = FStar_Ident.lid_of_path ["Type0"] r  in
      FStar_Parser_AST.Name uu____200  in
    FStar_Parser_AST.mk_term uu____199 r FStar_Parser_AST.Kind
  
let (tm_type : FStar_Range.range -> FStar_Parser_AST.term) =
  fun r  ->
    let uu____206 =
      let uu____207 = FStar_Ident.lid_of_path ["Type"] r  in
      FStar_Parser_AST.Name uu____207  in
    FStar_Parser_AST.mk_term uu____206 r FStar_Parser_AST.Kind
  
let rec (is_comp_type :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> Prims.bool) =
  fun env  ->
    fun t  ->
      let uu____218 =
        let uu____219 = unparen t  in uu____219.FStar_Parser_AST.tm  in
      match uu____218 with
      | FStar_Parser_AST.Name l ->
          let uu____221 = FStar_Syntax_DsEnv.try_lookup_effect_name env l  in
          FStar_All.pipe_right uu____221 FStar_Option.isSome
      | FStar_Parser_AST.Construct (l,uu____227) ->
          let uu____240 = FStar_Syntax_DsEnv.try_lookup_effect_name env l  in
          FStar_All.pipe_right uu____240 FStar_Option.isSome
      | FStar_Parser_AST.App (head1,uu____246,uu____247) ->
          is_comp_type env head1
      | FStar_Parser_AST.Paren t1 -> failwith "impossible"
      | FStar_Parser_AST.Ascribed (t1,uu____250,uu____251) ->
          is_comp_type env t1
      | FStar_Parser_AST.LetOpen (uu____256,t1) -> is_comp_type env t1
      | uu____258 -> false
  
let (unit_ty : FStar_Parser_AST.term) =
  FStar_Parser_AST.mk_term
    (FStar_Parser_AST.Name FStar_Parser_Const.unit_lid)
    FStar_Range.dummyRange FStar_Parser_AST.Type_level
  
let (compile_op_lid :
  Prims.int -> Prims.string -> FStar_Range.range -> FStar_Ident.lident) =
  fun n1  ->
    fun s  ->
      fun r  ->
        let uu____274 =
          let uu____277 =
            let uu____278 =
              let uu____283 = FStar_Parser_AST.compile_op n1 s r  in
              (uu____283, r)  in
            FStar_Ident.mk_ident uu____278  in
          [uu____277]  in
        FStar_All.pipe_right uu____274 FStar_Ident.lid_of_ids
  
let op_as_term :
  'Auu____296 .
    FStar_Syntax_DsEnv.env ->
      Prims.int ->
        'Auu____296 ->
          FStar_Ident.ident ->
            FStar_Syntax_Syntax.term FStar_Pervasives_Native.option
  =
  fun env  ->
    fun arity  ->
      fun rng  ->
        fun op  ->
          let r l dd =
            let uu____332 =
              let uu____333 =
                let uu____334 =
                  FStar_Ident.set_lid_range l op.FStar_Ident.idRange  in
                FStar_Syntax_Syntax.lid_as_fv uu____334 dd
                  FStar_Pervasives_Native.None
                 in
              FStar_All.pipe_right uu____333 FStar_Syntax_Syntax.fv_to_tm  in
            FStar_Pervasives_Native.Some uu____332  in
          let fallback uu____342 =
            let uu____343 = FStar_Ident.text_of_id op  in
            match uu____343 with
            | "=" ->
                r FStar_Parser_Const.op_Eq
                  FStar_Syntax_Syntax.delta_equational
            | ":=" ->
                r FStar_Parser_Const.write_lid
                  FStar_Syntax_Syntax.delta_equational
            | "<" ->
                r FStar_Parser_Const.op_LT
                  FStar_Syntax_Syntax.delta_equational
            | "<=" ->
                r FStar_Parser_Const.op_LTE
                  FStar_Syntax_Syntax.delta_equational
            | ">" ->
                r FStar_Parser_Const.op_GT
                  FStar_Syntax_Syntax.delta_equational
            | ">=" ->
                r FStar_Parser_Const.op_GTE
                  FStar_Syntax_Syntax.delta_equational
            | "&&" ->
                r FStar_Parser_Const.op_And
                  FStar_Syntax_Syntax.delta_equational
            | "||" ->
                r FStar_Parser_Const.op_Or
                  FStar_Syntax_Syntax.delta_equational
            | "+" ->
                r FStar_Parser_Const.op_Addition
                  FStar_Syntax_Syntax.delta_equational
            | "-" when arity = (Prims.parse_int "1") ->
                r FStar_Parser_Const.op_Minus
                  FStar_Syntax_Syntax.delta_equational
            | "-" ->
                r FStar_Parser_Const.op_Subtraction
                  FStar_Syntax_Syntax.delta_equational
            | "/" ->
                r FStar_Parser_Const.op_Division
                  FStar_Syntax_Syntax.delta_equational
            | "%" ->
                r FStar_Parser_Const.op_Modulus
                  FStar_Syntax_Syntax.delta_equational
            | "!" ->
                r FStar_Parser_Const.read_lid
                  FStar_Syntax_Syntax.delta_equational
            | "@" ->
                let uu____346 = FStar_Options.ml_ish ()  in
                if uu____346
                then
                  r FStar_Parser_Const.list_append_lid
                    FStar_Syntax_Syntax.delta_equational
                else
                  r FStar_Parser_Const.list_tot_append_lid
                    FStar_Syntax_Syntax.delta_equational
            | "^" ->
                r FStar_Parser_Const.strcat_lid
                  FStar_Syntax_Syntax.delta_equational
            | "|>" ->
                r FStar_Parser_Const.pipe_right_lid
                  FStar_Syntax_Syntax.delta_equational
            | "<|" ->
                r FStar_Parser_Const.pipe_left_lid
                  FStar_Syntax_Syntax.delta_equational
            | "<>" ->
                r FStar_Parser_Const.op_notEq
                  FStar_Syntax_Syntax.delta_equational
            | "~" ->
                r FStar_Parser_Const.not_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "2"))
            | "==" ->
                r FStar_Parser_Const.eq2_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "2"))
            | "<<" ->
                r FStar_Parser_Const.precedes_lid
                  FStar_Syntax_Syntax.delta_constant
            | "/\\" ->
                r FStar_Parser_Const.and_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "1"))
            | "\\/" ->
                r FStar_Parser_Const.or_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "1"))
            | "==>" ->
                r FStar_Parser_Const.imp_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "1"))
            | "<==>" ->
                r FStar_Parser_Const.iff_lid
                  (FStar_Syntax_Syntax.Delta_constant_at_level
                     (Prims.parse_int "2"))
            | uu____350 -> FStar_Pervasives_Native.None  in
          let uu____351 =
            let uu____358 =
              compile_op_lid arity op.FStar_Ident.idText
                op.FStar_Ident.idRange
               in
            FStar_Syntax_DsEnv.try_lookup_lid env uu____358  in
          match uu____351 with
          | FStar_Pervasives_Native.Some t ->
              FStar_Pervasives_Native.Some (FStar_Pervasives_Native.fst t)
          | uu____370 -> fallback ()
  
let (sort_ftv : FStar_Ident.ident Prims.list -> FStar_Ident.ident Prims.list)
  =
  fun ftv  ->
    let uu____388 =
      FStar_Util.remove_dups
        (fun x  -> fun y  -> x.FStar_Ident.idText = y.FStar_Ident.idText) ftv
       in
    FStar_All.pipe_left
      (FStar_Util.sort_with
         (fun x  ->
            fun y  ->
              FStar_String.compare x.FStar_Ident.idText y.FStar_Ident.idText))
      uu____388
  
let rec (free_type_vars_b :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder ->
      (FStar_Syntax_DsEnv.env,FStar_Ident.ident Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun binder  ->
      match binder.FStar_Parser_AST.b with
      | FStar_Parser_AST.Variable uu____435 -> (env, [])
      | FStar_Parser_AST.TVariable x ->
          let uu____439 = FStar_Syntax_DsEnv.push_bv env x  in
          (match uu____439 with | (env1,uu____451) -> (env1, [x]))
      | FStar_Parser_AST.Annotated (uu____454,term) ->
          let uu____456 = free_type_vars env term  in (env, uu____456)
      | FStar_Parser_AST.TAnnotated (id1,uu____462) ->
          let uu____463 = FStar_Syntax_DsEnv.push_bv env id1  in
          (match uu____463 with | (env1,uu____475) -> (env1, []))
      | FStar_Parser_AST.NoName t ->
          let uu____479 = free_type_vars env t  in (env, uu____479)

and (free_type_vars :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.term -> FStar_Ident.ident Prims.list)
  =
  fun env  ->
    fun t  ->
      let uu____486 =
        let uu____487 = unparen t  in uu____487.FStar_Parser_AST.tm  in
      match uu____486 with
      | FStar_Parser_AST.Labeled uu____490 ->
          failwith "Impossible --- labeled source term"
      | FStar_Parser_AST.Tvar a ->
          let uu____500 = FStar_Syntax_DsEnv.try_lookup_id env a  in
          (match uu____500 with
           | FStar_Pervasives_Native.None  -> [a]
           | uu____513 -> [])
      | FStar_Parser_AST.Wild  -> []
      | FStar_Parser_AST.Const uu____520 -> []
      | FStar_Parser_AST.Uvar uu____521 -> []
      | FStar_Parser_AST.Var uu____522 -> []
      | FStar_Parser_AST.Projector uu____523 -> []
      | FStar_Parser_AST.Discrim uu____528 -> []
      | FStar_Parser_AST.Name uu____529 -> []
      | FStar_Parser_AST.Requires (t1,uu____531) -> free_type_vars env t1
      | FStar_Parser_AST.Ensures (t1,uu____537) -> free_type_vars env t1
      | FStar_Parser_AST.NamedTyp (uu____542,t1) -> free_type_vars env t1
      | FStar_Parser_AST.Paren t1 -> failwith "impossible"
      | FStar_Parser_AST.Ascribed (t1,t',tacopt) ->
          let ts = t1 :: t' ::
            (match tacopt with
             | FStar_Pervasives_Native.None  -> []
             | FStar_Pervasives_Native.Some t2 -> [t2])
             in
          FStar_List.collect (free_type_vars env) ts
      | FStar_Parser_AST.Construct (uu____560,ts) ->
          FStar_List.collect
            (fun uu____581  ->
               match uu____581 with | (t1,uu____589) -> free_type_vars env t1)
            ts
      | FStar_Parser_AST.Op (uu____590,ts) ->
          FStar_List.collect (free_type_vars env) ts
      | FStar_Parser_AST.App (t1,t2,uu____598) ->
          let uu____599 = free_type_vars env t1  in
          let uu____602 = free_type_vars env t2  in
          FStar_List.append uu____599 uu____602
      | FStar_Parser_AST.Refine (b,t1) ->
          let uu____607 = free_type_vars_b env b  in
          (match uu____607 with
           | (env1,f) ->
               let uu____622 = free_type_vars env1 t1  in
               FStar_List.append f uu____622)
      | FStar_Parser_AST.Product (binders,body) ->
          let uu____631 =
            FStar_List.fold_left
              (fun uu____651  ->
                 fun binder  ->
                   match uu____651 with
                   | (env1,free) ->
                       let uu____671 = free_type_vars_b env1 binder  in
                       (match uu____671 with
                        | (env2,f) -> (env2, (FStar_List.append f free))))
              (env, []) binders
             in
          (match uu____631 with
           | (env1,free) ->
               let uu____702 = free_type_vars env1 body  in
               FStar_List.append free uu____702)
      | FStar_Parser_AST.Sum (binders,body) ->
          let uu____711 =
            FStar_List.fold_left
              (fun uu____731  ->
                 fun binder  ->
                   match uu____731 with
                   | (env1,free) ->
                       let uu____751 = free_type_vars_b env1 binder  in
                       (match uu____751 with
                        | (env2,f) -> (env2, (FStar_List.append f free))))
              (env, []) binders
             in
          (match uu____711 with
           | (env1,free) ->
               let uu____782 = free_type_vars env1 body  in
               FStar_List.append free uu____782)
      | FStar_Parser_AST.Project (t1,uu____786) -> free_type_vars env t1
      | FStar_Parser_AST.Attributes cattributes ->
          FStar_List.collect (free_type_vars env) cattributes
      | FStar_Parser_AST.Abs uu____790 -> []
      | FStar_Parser_AST.Let uu____797 -> []
      | FStar_Parser_AST.LetOpen uu____818 -> []
      | FStar_Parser_AST.If uu____823 -> []
      | FStar_Parser_AST.QForall uu____830 -> []
      | FStar_Parser_AST.QExists uu____843 -> []
      | FStar_Parser_AST.Record uu____856 -> []
      | FStar_Parser_AST.Match uu____869 -> []
      | FStar_Parser_AST.TryWith uu____884 -> []
      | FStar_Parser_AST.Bind uu____899 -> []
      | FStar_Parser_AST.Quote uu____906 -> []
      | FStar_Parser_AST.VQuote uu____911 -> []
      | FStar_Parser_AST.Antiquote uu____912 -> []
      | FStar_Parser_AST.Seq uu____917 -> []

let (head_and_args :
  FStar_Parser_AST.term ->
    (FStar_Parser_AST.term,(FStar_Parser_AST.term,FStar_Parser_AST.imp)
                             FStar_Pervasives_Native.tuple2 Prims.list)
      FStar_Pervasives_Native.tuple2)
  =
  fun t  ->
    let rec aux args t1 =
      let uu____970 =
        let uu____971 = unparen t1  in uu____971.FStar_Parser_AST.tm  in
      match uu____970 with
      | FStar_Parser_AST.App (t2,arg,imp) -> aux ((arg, imp) :: args) t2
      | FStar_Parser_AST.Construct (l,args') ->
          ({
             FStar_Parser_AST.tm = (FStar_Parser_AST.Name l);
             FStar_Parser_AST.range = (t1.FStar_Parser_AST.range);
             FStar_Parser_AST.level = (t1.FStar_Parser_AST.level)
           }, (FStar_List.append args' args))
      | uu____1013 -> (t1, args)  in
    aux [] t
  
let (close :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Parser_AST.term) =
  fun env  ->
    fun t  ->
      let ftv =
        let uu____1037 = free_type_vars env t  in
        FStar_All.pipe_left sort_ftv uu____1037  in
      if (FStar_List.length ftv) = (Prims.parse_int "0")
      then t
      else
        (let binders =
           FStar_All.pipe_right ftv
             (FStar_List.map
                (fun x  ->
                   let uu____1055 =
                     let uu____1056 =
                       let uu____1061 = tm_type x.FStar_Ident.idRange  in
                       (x, uu____1061)  in
                     FStar_Parser_AST.TAnnotated uu____1056  in
                   FStar_Parser_AST.mk_binder uu____1055
                     x.FStar_Ident.idRange FStar_Parser_AST.Type_level
                     (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)))
            in
         let result =
           FStar_Parser_AST.mk_term (FStar_Parser_AST.Product (binders, t))
             t.FStar_Parser_AST.range t.FStar_Parser_AST.level
            in
         result)
  
let (close_fun :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Parser_AST.term) =
  fun env  ->
    fun t  ->
      let ftv =
        let uu____1078 = free_type_vars env t  in
        FStar_All.pipe_left sort_ftv uu____1078  in
      if (FStar_List.length ftv) = (Prims.parse_int "0")
      then t
      else
        (let binders =
           FStar_All.pipe_right ftv
             (FStar_List.map
                (fun x  ->
                   let uu____1096 =
                     let uu____1097 =
                       let uu____1102 = tm_type x.FStar_Ident.idRange  in
                       (x, uu____1102)  in
                     FStar_Parser_AST.TAnnotated uu____1097  in
                   FStar_Parser_AST.mk_binder uu____1096
                     x.FStar_Ident.idRange FStar_Parser_AST.Type_level
                     (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)))
            in
         let t1 =
           let uu____1104 =
             let uu____1105 = unparen t  in uu____1105.FStar_Parser_AST.tm
              in
           match uu____1104 with
           | FStar_Parser_AST.Product uu____1106 -> t
           | uu____1113 ->
               FStar_Parser_AST.mk_term
                 (FStar_Parser_AST.App
                    ((FStar_Parser_AST.mk_term
                        (FStar_Parser_AST.Name
                           FStar_Parser_Const.effect_Tot_lid)
                        t.FStar_Parser_AST.range t.FStar_Parser_AST.level),
                      t, FStar_Parser_AST.Nothing)) t.FStar_Parser_AST.range
                 t.FStar_Parser_AST.level
            in
         let result =
           FStar_Parser_AST.mk_term (FStar_Parser_AST.Product (binders, t1))
             t1.FStar_Parser_AST.range t1.FStar_Parser_AST.level
            in
         result)
  
let rec (uncurry :
  FStar_Parser_AST.binder Prims.list ->
    FStar_Parser_AST.term ->
      (FStar_Parser_AST.binder Prims.list,FStar_Parser_AST.term)
        FStar_Pervasives_Native.tuple2)
  =
  fun bs  ->
    fun t  ->
      match t.FStar_Parser_AST.tm with
      | FStar_Parser_AST.Product (binders,t1) ->
          uncurry (FStar_List.append bs binders) t1
      | uu____1149 -> (bs, t)
  
let rec (is_var_pattern : FStar_Parser_AST.pattern -> Prims.bool) =
  fun p  ->
    match p.FStar_Parser_AST.pat with
    | FStar_Parser_AST.PatWild  -> true
    | FStar_Parser_AST.PatTvar (uu____1157,uu____1158) -> true
    | FStar_Parser_AST.PatVar (uu____1163,uu____1164) -> true
    | FStar_Parser_AST.PatAscribed (p1,uu____1170) -> is_var_pattern p1
    | uu____1183 -> false
  
let rec (is_app_pattern : FStar_Parser_AST.pattern -> Prims.bool) =
  fun p  ->
    match p.FStar_Parser_AST.pat with
    | FStar_Parser_AST.PatAscribed (p1,uu____1190) -> is_app_pattern p1
    | FStar_Parser_AST.PatApp
        ({ FStar_Parser_AST.pat = FStar_Parser_AST.PatVar uu____1203;
           FStar_Parser_AST.prange = uu____1204;_},uu____1205)
        -> true
    | uu____1216 -> false
  
let (replace_unit_pattern :
  FStar_Parser_AST.pattern -> FStar_Parser_AST.pattern) =
  fun p  ->
    match p.FStar_Parser_AST.pat with
    | FStar_Parser_AST.PatConst (FStar_Const.Const_unit ) ->
        FStar_Parser_AST.mk_pattern
          (FStar_Parser_AST.PatAscribed
             ((FStar_Parser_AST.mk_pattern FStar_Parser_AST.PatWild
                 p.FStar_Parser_AST.prange),
               (unit_ty, FStar_Pervasives_Native.None)))
          p.FStar_Parser_AST.prange
    | uu____1230 -> p
  
let rec (destruct_app_pattern :
  FStar_Syntax_DsEnv.env ->
    Prims.bool ->
      FStar_Parser_AST.pattern ->
        ((FStar_Ident.ident,FStar_Ident.lident) FStar_Util.either,FStar_Parser_AST.pattern
                                                                    Prims.list,
          (FStar_Parser_AST.term,FStar_Parser_AST.term
                                   FStar_Pervasives_Native.option)
            FStar_Pervasives_Native.tuple2 FStar_Pervasives_Native.option)
          FStar_Pervasives_Native.tuple3)
  =
  fun env  ->
    fun is_top_level1  ->
      fun p  ->
        match p.FStar_Parser_AST.pat with
        | FStar_Parser_AST.PatAscribed (p1,t) ->
            let uu____1300 = destruct_app_pattern env is_top_level1 p1  in
            (match uu____1300 with
             | (name,args,uu____1343) ->
                 (name, args, (FStar_Pervasives_Native.Some t)))
        | FStar_Parser_AST.PatApp
            ({
               FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                 (id1,uu____1393);
               FStar_Parser_AST.prange = uu____1394;_},args)
            when is_top_level1 ->
            let uu____1404 =
              let uu____1409 = FStar_Syntax_DsEnv.qualify env id1  in
              FStar_Util.Inr uu____1409  in
            (uu____1404, args, FStar_Pervasives_Native.None)
        | FStar_Parser_AST.PatApp
            ({
               FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                 (id1,uu____1431);
               FStar_Parser_AST.prange = uu____1432;_},args)
            -> ((FStar_Util.Inl id1), args, FStar_Pervasives_Native.None)
        | uu____1462 -> failwith "Not an app pattern"
  
let rec (gather_pattern_bound_vars_maybe_top :
  FStar_Ident.ident FStar_Util.set ->
    FStar_Parser_AST.pattern -> FStar_Ident.ident FStar_Util.set)
  =
  fun acc  ->
    fun p  ->
      let gather_pattern_bound_vars_from_list =
        FStar_List.fold_left gather_pattern_bound_vars_maybe_top acc  in
      match p.FStar_Parser_AST.pat with
      | FStar_Parser_AST.PatWild  -> acc
      | FStar_Parser_AST.PatConst uu____1512 -> acc
      | FStar_Parser_AST.PatVar
          (uu____1513,FStar_Pervasives_Native.Some (FStar_Parser_AST.Implicit
           ))
          -> acc
      | FStar_Parser_AST.PatName uu____1516 -> acc
      | FStar_Parser_AST.PatTvar uu____1517 -> acc
      | FStar_Parser_AST.PatOp uu____1524 -> acc
      | FStar_Parser_AST.PatApp (phead,pats) ->
          gather_pattern_bound_vars_from_list (phead :: pats)
      | FStar_Parser_AST.PatVar (x,uu____1532) -> FStar_Util.set_add x acc
      | FStar_Parser_AST.PatList pats ->
          gather_pattern_bound_vars_from_list pats
      | FStar_Parser_AST.PatTuple (pats,uu____1541) ->
          gather_pattern_bound_vars_from_list pats
      | FStar_Parser_AST.PatOr pats ->
          gather_pattern_bound_vars_from_list pats
      | FStar_Parser_AST.PatRecord guarded_pats ->
          let uu____1556 =
            FStar_List.map FStar_Pervasives_Native.snd guarded_pats  in
          gather_pattern_bound_vars_from_list uu____1556
      | FStar_Parser_AST.PatAscribed (pat,uu____1564) ->
          gather_pattern_bound_vars_maybe_top acc pat
  
let (gather_pattern_bound_vars :
  FStar_Parser_AST.pattern -> FStar_Ident.ident FStar_Util.set) =
  let acc =
    FStar_Util.new_set
      (fun id1  ->
         fun id2  ->
           if id1.FStar_Ident.idText = id2.FStar_Ident.idText
           then (Prims.parse_int "0")
           else (Prims.parse_int "1"))
     in
  fun p  -> gather_pattern_bound_vars_maybe_top acc p 
type bnd =
  | LocalBinder of (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
  FStar_Pervasives_Native.tuple2 
  | LetBinder of
  (FStar_Ident.lident,(FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term
                                                  FStar_Pervasives_Native.option)
                        FStar_Pervasives_Native.tuple2)
  FStar_Pervasives_Native.tuple2 
let (uu___is_LocalBinder : bnd -> Prims.bool) =
  fun projectee  ->
    match projectee with | LocalBinder _0 -> true | uu____1626 -> false
  
let (__proj__LocalBinder__item___0 :
  bnd ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | LocalBinder _0 -> _0 
let (uu___is_LetBinder : bnd -> Prims.bool) =
  fun projectee  ->
    match projectee with | LetBinder _0 -> true | uu____1662 -> false
  
let (__proj__LetBinder__item___0 :
  bnd ->
    (FStar_Ident.lident,(FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.term
                                                    FStar_Pervasives_Native.option)
                          FStar_Pervasives_Native.tuple2)
      FStar_Pervasives_Native.tuple2)
  = fun projectee  -> match projectee with | LetBinder _0 -> _0 
let (binder_of_bnd :
  bnd ->
    (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
      FStar_Pervasives_Native.tuple2)
  =
  fun uu___115_1708  ->
    match uu___115_1708 with
    | LocalBinder (a,aq) -> (a, aq)
    | uu____1715 -> failwith "Impossible"
  
let (as_binder :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.arg_qualifier FStar_Pervasives_Native.option ->
      (FStar_Ident.ident FStar_Pervasives_Native.option,FStar_Syntax_Syntax.term)
        FStar_Pervasives_Native.tuple2 ->
        (FStar_Syntax_Syntax.binder,FStar_Syntax_DsEnv.env)
          FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun imp  ->
      fun uu___116_1746  ->
        match uu___116_1746 with
        | (FStar_Pervasives_Native.None ,k) ->
            let uu____1762 = FStar_Syntax_Syntax.null_binder k  in
            (uu____1762, env)
        | (FStar_Pervasives_Native.Some a,k) ->
            let uu____1767 = FStar_Syntax_DsEnv.push_bv env a  in
            (match uu____1767 with
             | (env1,a1) ->
                 (((let uu___140_1787 = a1  in
                    {
                      FStar_Syntax_Syntax.ppname =
                        (uu___140_1787.FStar_Syntax_Syntax.ppname);
                      FStar_Syntax_Syntax.index =
                        (uu___140_1787.FStar_Syntax_Syntax.index);
                      FStar_Syntax_Syntax.sort = k
                    }), (trans_aqual imp)), env1))
  
type env_t = FStar_Syntax_DsEnv.env
type lenv_t = FStar_Syntax_Syntax.bv Prims.list
let (mk_lb :
  (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list,(FStar_Syntax_Syntax.bv,
                                                                    FStar_Syntax_Syntax.fv)
                                                                    FStar_Util.either,
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,FStar_Syntax_Syntax.term'
                                                           FStar_Syntax_Syntax.syntax,
    FStar_Range.range) FStar_Pervasives_Native.tuple5 ->
    FStar_Syntax_Syntax.letbinding)
  =
  fun uu____1816  ->
    match uu____1816 with
    | (attrs,n1,t,e,pos) ->
        {
          FStar_Syntax_Syntax.lbname = n1;
          FStar_Syntax_Syntax.lbunivs = [];
          FStar_Syntax_Syntax.lbtyp = t;
          FStar_Syntax_Syntax.lbeff = FStar_Parser_Const.effect_ALL_lid;
          FStar_Syntax_Syntax.lbdef = e;
          FStar_Syntax_Syntax.lbattrs = attrs;
          FStar_Syntax_Syntax.lbpos = pos
        }
  
let (no_annot_abs :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun bs  ->
    fun t  -> FStar_Syntax_Util.abs bs t FStar_Pervasives_Native.None
  
let (mk_ref_read :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun tm  ->
    let tm' =
      let uu____1890 =
        let uu____1905 =
          let uu____1906 =
            FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.sread_lid
              FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
             in
          FStar_Syntax_Syntax.fv_to_tm uu____1906  in
        let uu____1907 =
          let uu____1916 =
            let uu____1923 = FStar_Syntax_Syntax.as_implicit false  in
            (tm, uu____1923)  in
          [uu____1916]  in
        (uu____1905, uu____1907)  in
      FStar_Syntax_Syntax.Tm_app uu____1890  in
    FStar_Syntax_Syntax.mk tm' FStar_Pervasives_Native.None
      tm.FStar_Syntax_Syntax.pos
  
let (mk_ref_alloc :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun tm  ->
    let tm' =
      let uu____1958 =
        let uu____1973 =
          let uu____1974 =
            FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.salloc_lid
              FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
             in
          FStar_Syntax_Syntax.fv_to_tm uu____1974  in
        let uu____1975 =
          let uu____1984 =
            let uu____1991 = FStar_Syntax_Syntax.as_implicit false  in
            (tm, uu____1991)  in
          [uu____1984]  in
        (uu____1973, uu____1975)  in
      FStar_Syntax_Syntax.Tm_app uu____1958  in
    FStar_Syntax_Syntax.mk tm' FStar_Pervasives_Native.None
      tm.FStar_Syntax_Syntax.pos
  
let (mk_ref_assign :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Range.range ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t1  ->
    fun t2  ->
      fun pos  ->
        let tm =
          let uu____2040 =
            let uu____2055 =
              let uu____2056 =
                FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.swrite_lid
                  FStar_Syntax_Syntax.delta_constant
                  FStar_Pervasives_Native.None
                 in
              FStar_Syntax_Syntax.fv_to_tm uu____2056  in
            let uu____2057 =
              let uu____2066 =
                let uu____2073 = FStar_Syntax_Syntax.as_implicit false  in
                (t1, uu____2073)  in
              let uu____2076 =
                let uu____2085 =
                  let uu____2092 = FStar_Syntax_Syntax.as_implicit false  in
                  (t2, uu____2092)  in
                [uu____2085]  in
              uu____2066 :: uu____2076  in
            (uu____2055, uu____2057)  in
          FStar_Syntax_Syntax.Tm_app uu____2040  in
        FStar_Syntax_Syntax.mk tm FStar_Pervasives_Native.None pos
  
let (is_special_effect_combinator : Prims.string -> Prims.bool) =
  fun uu___117_2125  ->
    match uu___117_2125 with
    | "repr" -> true
    | "post" -> true
    | "pre" -> true
    | "wp" -> true
    | uu____2126 -> false
  
let rec (sum_to_universe :
  FStar_Syntax_Syntax.universe -> Prims.int -> FStar_Syntax_Syntax.universe)
  =
  fun u  ->
    fun n1  ->
      if n1 = (Prims.parse_int "0")
      then u
      else
        (let uu____2138 = sum_to_universe u (n1 - (Prims.parse_int "1"))  in
         FStar_Syntax_Syntax.U_succ uu____2138)
  
let (int_to_universe : Prims.int -> FStar_Syntax_Syntax.universe) =
  fun n1  -> sum_to_universe FStar_Syntax_Syntax.U_zero n1 
let rec (desugar_maybe_non_constant_universe :
  FStar_Parser_AST.term ->
    (Prims.int,FStar_Syntax_Syntax.universe) FStar_Util.either)
  =
  fun t  ->
    let uu____2157 =
      let uu____2158 = unparen t  in uu____2158.FStar_Parser_AST.tm  in
    match uu____2157 with
    | FStar_Parser_AST.Wild  ->
        let uu____2163 =
          let uu____2164 = FStar_Syntax_Unionfind.univ_fresh ()  in
          FStar_Syntax_Syntax.U_unif uu____2164  in
        FStar_Util.Inr uu____2163
    | FStar_Parser_AST.Uvar u ->
        FStar_Util.Inr (FStar_Syntax_Syntax.U_name u)
    | FStar_Parser_AST.Const (FStar_Const.Const_int (repr,uu____2175)) ->
        let n1 = FStar_Util.int_of_string repr  in
        (if n1 < (Prims.parse_int "0")
         then
           FStar_Errors.raise_error
             (FStar_Errors.Fatal_NegativeUniverseConstFatal_NotSupported,
               (Prims.strcat
                  "Negative universe constant  are not supported : " repr))
             t.FStar_Parser_AST.range
         else ();
         FStar_Util.Inl n1)
    | FStar_Parser_AST.Op (op_plus,t1::t2::[]) ->
        let u1 = desugar_maybe_non_constant_universe t1  in
        let u2 = desugar_maybe_non_constant_universe t2  in
        (match (u1, u2) with
         | (FStar_Util.Inl n1,FStar_Util.Inl n2) -> FStar_Util.Inl (n1 + n2)
         | (FStar_Util.Inl n1,FStar_Util.Inr u) ->
             let uu____2240 = sum_to_universe u n1  in
             FStar_Util.Inr uu____2240
         | (FStar_Util.Inr u,FStar_Util.Inl n1) ->
             let uu____2251 = sum_to_universe u n1  in
             FStar_Util.Inr uu____2251
         | (FStar_Util.Inr u11,FStar_Util.Inr u21) ->
             let uu____2262 =
               let uu____2267 =
                 let uu____2268 = FStar_Parser_AST.term_to_string t  in
                 Prims.strcat
                   "This universe might contain a sum of two universe variables "
                   uu____2268
                  in
               (FStar_Errors.Fatal_UniverseMightContainSumOfTwoUnivVars,
                 uu____2267)
                in
             FStar_Errors.raise_error uu____2262 t.FStar_Parser_AST.range)
    | FStar_Parser_AST.App uu____2273 ->
        let rec aux t1 univargs =
          let uu____2307 =
            let uu____2308 = unparen t1  in uu____2308.FStar_Parser_AST.tm
             in
          match uu____2307 with
          | FStar_Parser_AST.App (t2,targ,uu____2315) ->
              let uarg = desugar_maybe_non_constant_universe targ  in
              aux t2 (uarg :: univargs)
          | FStar_Parser_AST.Var max_lid1 ->
              if
                FStar_List.existsb
                  (fun uu___118_2338  ->
                     match uu___118_2338 with
                     | FStar_Util.Inr uu____2343 -> true
                     | uu____2344 -> false) univargs
              then
                let uu____2349 =
                  let uu____2350 =
                    FStar_List.map
                      (fun uu___119_2359  ->
                         match uu___119_2359 with
                         | FStar_Util.Inl n1 -> int_to_universe n1
                         | FStar_Util.Inr u -> u) univargs
                     in
                  FStar_Syntax_Syntax.U_max uu____2350  in
                FStar_Util.Inr uu____2349
              else
                (let nargs =
                   FStar_List.map
                     (fun uu___120_2376  ->
                        match uu___120_2376 with
                        | FStar_Util.Inl n1 -> n1
                        | FStar_Util.Inr uu____2382 -> failwith "impossible")
                     univargs
                    in
                 let uu____2383 =
                   FStar_List.fold_left
                     (fun m  -> fun n1  -> if m > n1 then m else n1)
                     (Prims.parse_int "0") nargs
                    in
                 FStar_Util.Inl uu____2383)
          | uu____2389 ->
              let uu____2390 =
                let uu____2395 =
                  let uu____2396 =
                    let uu____2397 = FStar_Parser_AST.term_to_string t1  in
                    Prims.strcat uu____2397 " in universe context"  in
                  Prims.strcat "Unexpected term " uu____2396  in
                (FStar_Errors.Fatal_UnexpectedTermInUniverse, uu____2395)  in
              FStar_Errors.raise_error uu____2390 t1.FStar_Parser_AST.range
           in
        aux t []
    | uu____2406 ->
        let uu____2407 =
          let uu____2412 =
            let uu____2413 =
              let uu____2414 = FStar_Parser_AST.term_to_string t  in
              Prims.strcat uu____2414 " in universe context"  in
            Prims.strcat "Unexpected term " uu____2413  in
          (FStar_Errors.Fatal_UnexpectedTermInUniverse, uu____2412)  in
        FStar_Errors.raise_error uu____2407 t.FStar_Parser_AST.range
  
let rec (desugar_universe :
  FStar_Parser_AST.term -> FStar_Syntax_Syntax.universe) =
  fun t  ->
    let u = desugar_maybe_non_constant_universe t  in
    match u with
    | FStar_Util.Inl n1 -> int_to_universe n1
    | FStar_Util.Inr u1 -> u1
  
let (check_no_aq : FStar_Syntax_Syntax.antiquotations -> unit) =
  fun aq  ->
    match aq with
    | [] -> ()
    | (bv,b,e)::uu____2447 ->
        let uu____2470 =
          let uu____2475 =
            let uu____2476 = FStar_Syntax_Print.term_to_string e  in
            FStar_Util.format2 "Unexpected antiquotation: %s(%s)"
              (if b then "`@" else "`#") uu____2476
             in
          (FStar_Errors.Fatal_UnexpectedAntiquotation, uu____2475)  in
        FStar_Errors.raise_error uu____2470 e.FStar_Syntax_Syntax.pos
  
let check_fields :
  'Auu____2486 .
    FStar_Syntax_DsEnv.env ->
      (FStar_Ident.lident,'Auu____2486) FStar_Pervasives_Native.tuple2
        Prims.list -> FStar_Range.range -> FStar_Syntax_DsEnv.record_or_dc
  =
  fun env  ->
    fun fields  ->
      fun rg  ->
        let uu____2514 = FStar_List.hd fields  in
        match uu____2514 with
        | (f,uu____2524) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env f;
             (let record =
                FStar_Syntax_DsEnv.fail_or env
                  (FStar_Syntax_DsEnv.try_lookup_record_by_field_name env) f
                 in
              let check_field uu____2536 =
                match uu____2536 with
                | (f',uu____2542) ->
                    (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env f';
                     (let uu____2544 =
                        FStar_Syntax_DsEnv.belongs_to_record env f' record
                         in
                      if uu____2544
                      then ()
                      else
                        (let msg =
                           FStar_Util.format3
                             "Field %s belongs to record type %s, whereas field %s does not"
                             f.FStar_Ident.str
                             (record.FStar_Syntax_DsEnv.typename).FStar_Ident.str
                             f'.FStar_Ident.str
                            in
                         FStar_Errors.raise_error
                           (FStar_Errors.Fatal_FieldsNotBelongToSameRecordType,
                             msg) rg)))
                 in
              (let uu____2548 = FStar_List.tl fields  in
               FStar_List.iter check_field uu____2548);
              (match () with | () -> record)))
  
let rec (desugar_data_pat :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.pattern ->
      Prims.bool ->
        (env_t,bnd,FStar_Syntax_Syntax.pat Prims.list)
          FStar_Pervasives_Native.tuple3)
  =
  fun env  ->
    fun p  ->
      fun is_mut  ->
        let check_linear_pattern_variables pats r =
          let rec pat_vars p1 =
            match p1.FStar_Syntax_Syntax.v with
            | FStar_Syntax_Syntax.Pat_dot_term uu____2895 ->
                FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_wild uu____2902 ->
                FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_constant uu____2903 ->
                FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_var x ->
                FStar_Util.set_add x FStar_Syntax_Syntax.no_names
            | FStar_Syntax_Syntax.Pat_cons (uu____2905,pats1) ->
                let aux out uu____2943 =
                  match uu____2943 with
                  | (p2,uu____2955) ->
                      let intersection =
                        let uu____2963 = pat_vars p2  in
                        FStar_Util.set_intersect uu____2963 out  in
                      let uu____2966 = FStar_Util.set_is_empty intersection
                         in
                      if uu____2966
                      then
                        let uu____2969 = pat_vars p2  in
                        FStar_Util.set_union out uu____2969
                      else
                        (let duplicate_bv =
                           let uu____2974 =
                             FStar_Util.set_elements intersection  in
                           FStar_List.hd uu____2974  in
                         let uu____2977 =
                           let uu____2982 =
                             FStar_Util.format1
                               "Non-linear patterns are not permitted. %s appears more than once in this pattern."
                               (duplicate_bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                              in
                           (FStar_Errors.Fatal_NonLinearPatternNotPermitted,
                             uu____2982)
                            in
                         FStar_Errors.raise_error uu____2977 r)
                   in
                FStar_List.fold_left aux FStar_Syntax_Syntax.no_names pats1
             in
          match pats with
          | [] -> ()
          | p1::[] ->
              let uu____3002 = pat_vars p1  in
              FStar_All.pipe_right uu____3002 (fun a237  -> ())
          | p1::ps ->
              let pvars = pat_vars p1  in
              let aux p2 =
                let uu____3024 =
                  let uu____3025 = pat_vars p2  in
                  FStar_Util.set_eq pvars uu____3025  in
                if uu____3024
                then ()
                else
                  (let nonlinear_vars =
                     let uu____3032 = pat_vars p2  in
                     FStar_Util.set_symmetric_difference pvars uu____3032  in
                   let first_nonlinear_var =
                     let uu____3036 = FStar_Util.set_elements nonlinear_vars
                        in
                     FStar_List.hd uu____3036  in
                   let uu____3039 =
                     let uu____3044 =
                       FStar_Util.format1
                         "Patterns in this match are incoherent, variable %s is bound in some but not all patterns."
                         (first_nonlinear_var.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                        in
                     (FStar_Errors.Fatal_IncoherentPatterns, uu____3044)  in
                   FStar_Errors.raise_error uu____3039 r)
                 in
              FStar_List.iter aux ps
           in
        (match (is_mut, (p.FStar_Parser_AST.pat)) with
         | (false ,uu____3048) -> ()
         | (true ,FStar_Parser_AST.PatVar uu____3049) -> ()
         | (true ,uu____3056) ->
             FStar_Errors.raise_error
               (FStar_Errors.Fatal_LetMutableForVariablesOnly,
                 "let-mutable is for variables only")
               p.FStar_Parser_AST.prange);
        (let resolvex l e x =
           let uu____3079 =
             FStar_All.pipe_right l
               (FStar_Util.find_opt
                  (fun y  ->
                     (y.FStar_Syntax_Syntax.ppname).FStar_Ident.idText =
                       x.FStar_Ident.idText))
              in
           match uu____3079 with
           | FStar_Pervasives_Native.Some y -> (l, e, y)
           | uu____3093 ->
               let uu____3096 =
                 if is_mut
                 then FStar_Syntax_DsEnv.push_bv_mutable e x
                 else FStar_Syntax_DsEnv.push_bv e x  in
               (match uu____3096 with | (e1,x1) -> ((x1 :: l), e1, x1))
            in
         let rec aux' top loc env1 p1 =
           let pos q =
             FStar_Syntax_Syntax.withinfo q p1.FStar_Parser_AST.prange  in
           let pos_r r q = FStar_Syntax_Syntax.withinfo q r  in
           let orig = p1  in
           match p1.FStar_Parser_AST.pat with
           | FStar_Parser_AST.PatOr uu____3208 -> failwith "impossible"
           | FStar_Parser_AST.PatOp op ->
               let uu____3224 =
                 let uu____3225 =
                   let uu____3226 =
                     let uu____3233 =
                       let uu____3234 =
                         let uu____3239 =
                           FStar_Parser_AST.compile_op (Prims.parse_int "0")
                             op.FStar_Ident.idText op.FStar_Ident.idRange
                            in
                         (uu____3239, (op.FStar_Ident.idRange))  in
                       FStar_Ident.mk_ident uu____3234  in
                     (uu____3233, FStar_Pervasives_Native.None)  in
                   FStar_Parser_AST.PatVar uu____3226  in
                 {
                   FStar_Parser_AST.pat = uu____3225;
                   FStar_Parser_AST.prange = (p1.FStar_Parser_AST.prange)
                 }  in
               aux loc env1 uu____3224
           | FStar_Parser_AST.PatAscribed (p2,(t,tacopt)) ->
               ((match tacopt with
                 | FStar_Pervasives_Native.None  -> ()
                 | FStar_Pervasives_Native.Some uu____3256 ->
                     FStar_Errors.raise_error
                       (FStar_Errors.Fatal_TypeWithinPatternsAllowedOnVariablesOnly,
                         "Type ascriptions within patterns are cannot be associated with a tactic")
                       orig.FStar_Parser_AST.prange);
                (let uu____3257 = aux loc env1 p2  in
                 match uu____3257 with
                 | (loc1,env',binder,p3,imp) ->
                     let annot_pat_var p4 t1 =
                       match p4.FStar_Syntax_Syntax.v with
                       | FStar_Syntax_Syntax.Pat_var x ->
                           let uu___141_3315 = p4  in
                           {
                             FStar_Syntax_Syntax.v =
                               (FStar_Syntax_Syntax.Pat_var
                                  (let uu___142_3320 = x  in
                                   {
                                     FStar_Syntax_Syntax.ppname =
                                       (uu___142_3320.FStar_Syntax_Syntax.ppname);
                                     FStar_Syntax_Syntax.index =
                                       (uu___142_3320.FStar_Syntax_Syntax.index);
                                     FStar_Syntax_Syntax.sort = t1
                                   }));
                             FStar_Syntax_Syntax.p =
                               (uu___141_3315.FStar_Syntax_Syntax.p)
                           }
                       | FStar_Syntax_Syntax.Pat_wild x ->
                           let uu___143_3322 = p4  in
                           {
                             FStar_Syntax_Syntax.v =
                               (FStar_Syntax_Syntax.Pat_wild
                                  (let uu___144_3327 = x  in
                                   {
                                     FStar_Syntax_Syntax.ppname =
                                       (uu___144_3327.FStar_Syntax_Syntax.ppname);
                                     FStar_Syntax_Syntax.index =
                                       (uu___144_3327.FStar_Syntax_Syntax.index);
                                     FStar_Syntax_Syntax.sort = t1
                                   }));
                             FStar_Syntax_Syntax.p =
                               (uu___143_3322.FStar_Syntax_Syntax.p)
                           }
                       | uu____3328 when top -> p4
                       | uu____3329 ->
                           FStar_Errors.raise_error
                             (FStar_Errors.Fatal_TypeWithinPatternsAllowedOnVariablesOnly,
                               "Type ascriptions within patterns are only allowed on variables")
                             orig.FStar_Parser_AST.prange
                        in
                     let uu____3332 =
                       match binder with
                       | LetBinder uu____3345 -> failwith "impossible"
                       | LocalBinder (x,aq) ->
                           let t1 =
                             let uu____3365 = close_fun env1 t  in
                             desugar_term env1 uu____3365  in
                           (if
                              (match (x.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n
                               with
                               | FStar_Syntax_Syntax.Tm_unknown  -> false
                               | uu____3367 -> true)
                            then
                              (let uu____3368 =
                                 let uu____3373 =
                                   let uu____3374 =
                                     FStar_Syntax_Print.bv_to_string x  in
                                   let uu____3375 =
                                     FStar_Syntax_Print.term_to_string
                                       x.FStar_Syntax_Syntax.sort
                                      in
                                   let uu____3376 =
                                     FStar_Syntax_Print.term_to_string t1  in
                                   FStar_Util.format3
                                     "Multiple ascriptions for %s in pattern, type %s was shadowed by %s\n"
                                     uu____3374 uu____3375 uu____3376
                                    in
                                 (FStar_Errors.Warning_MultipleAscriptions,
                                   uu____3373)
                                  in
                               FStar_Errors.log_issue
                                 orig.FStar_Parser_AST.prange uu____3368)
                            else ();
                            (let uu____3378 = annot_pat_var p3 t1  in
                             (uu____3378,
                               (LocalBinder
                                  ((let uu___145_3384 = x  in
                                    {
                                      FStar_Syntax_Syntax.ppname =
                                        (uu___145_3384.FStar_Syntax_Syntax.ppname);
                                      FStar_Syntax_Syntax.index =
                                        (uu___145_3384.FStar_Syntax_Syntax.index);
                                      FStar_Syntax_Syntax.sort = t1
                                    }), aq)))))
                        in
                     (match uu____3332 with
                      | (p4,binder1) -> (loc1, env', binder1, p4, imp))))
           | FStar_Parser_AST.PatWild  ->
               let x =
                 FStar_Syntax_Syntax.new_bv
                   (FStar_Pervasives_Native.Some (p1.FStar_Parser_AST.prange))
                   FStar_Syntax_Syntax.tun
                  in
               let uu____3406 =
                 FStar_All.pipe_left pos (FStar_Syntax_Syntax.Pat_wild x)  in
               (loc, env1, (LocalBinder (x, FStar_Pervasives_Native.None)),
                 uu____3406, false)
           | FStar_Parser_AST.PatConst c ->
               let x =
                 FStar_Syntax_Syntax.new_bv
                   (FStar_Pervasives_Native.Some (p1.FStar_Parser_AST.prange))
                   FStar_Syntax_Syntax.tun
                  in
               let uu____3417 =
                 FStar_All.pipe_left pos (FStar_Syntax_Syntax.Pat_constant c)
                  in
               (loc, env1, (LocalBinder (x, FStar_Pervasives_Native.None)),
                 uu____3417, false)
           | FStar_Parser_AST.PatTvar (x,aq) ->
               let imp =
                 aq =
                   (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)
                  in
               let aq1 = trans_aqual aq  in
               let uu____3438 = resolvex loc env1 x  in
               (match uu____3438 with
                | (loc1,env2,xbv) ->
                    let uu____3460 =
                      FStar_All.pipe_left pos
                        (FStar_Syntax_Syntax.Pat_var xbv)
                       in
                    (loc1, env2, (LocalBinder (xbv, aq1)), uu____3460, imp))
           | FStar_Parser_AST.PatVar (x,aq) ->
               let imp =
                 aq =
                   (FStar_Pervasives_Native.Some FStar_Parser_AST.Implicit)
                  in
               let aq1 = trans_aqual aq  in
               let uu____3481 = resolvex loc env1 x  in
               (match uu____3481 with
                | (loc1,env2,xbv) ->
                    let uu____3503 =
                      FStar_All.pipe_left pos
                        (FStar_Syntax_Syntax.Pat_var xbv)
                       in
                    (loc1, env2, (LocalBinder (xbv, aq1)), uu____3503, imp))
           | FStar_Parser_AST.PatName l ->
               let l1 =
                 FStar_Syntax_DsEnv.fail_or env1
                   (FStar_Syntax_DsEnv.try_lookup_datacon env1) l
                  in
               let x =
                 FStar_Syntax_Syntax.new_bv
                   (FStar_Pervasives_Native.Some (p1.FStar_Parser_AST.prange))
                   FStar_Syntax_Syntax.tun
                  in
               let uu____3515 =
                 FStar_All.pipe_left pos
                   (FStar_Syntax_Syntax.Pat_cons (l1, []))
                  in
               (loc, env1, (LocalBinder (x, FStar_Pervasives_Native.None)),
                 uu____3515, false)
           | FStar_Parser_AST.PatApp
               ({ FStar_Parser_AST.pat = FStar_Parser_AST.PatName l;
                  FStar_Parser_AST.prange = uu____3539;_},args)
               ->
               let uu____3545 =
                 FStar_List.fold_right
                   (fun arg  ->
                      fun uu____3586  ->
                        match uu____3586 with
                        | (loc1,env2,args1) ->
                            let uu____3634 = aux loc1 env2 arg  in
                            (match uu____3634 with
                             | (loc2,env3,uu____3663,arg1,imp) ->
                                 (loc2, env3, ((arg1, imp) :: args1)))) args
                   (loc, env1, [])
                  in
               (match uu____3545 with
                | (loc1,env2,args1) ->
                    let l1 =
                      FStar_Syntax_DsEnv.fail_or env2
                        (FStar_Syntax_DsEnv.try_lookup_datacon env2) l
                       in
                    let x =
                      FStar_Syntax_Syntax.new_bv
                        (FStar_Pervasives_Native.Some
                           (p1.FStar_Parser_AST.prange))
                        FStar_Syntax_Syntax.tun
                       in
                    let uu____3733 =
                      FStar_All.pipe_left pos
                        (FStar_Syntax_Syntax.Pat_cons (l1, args1))
                       in
                    (loc1, env2,
                      (LocalBinder (x, FStar_Pervasives_Native.None)),
                      uu____3733, false))
           | FStar_Parser_AST.PatApp uu____3750 ->
               FStar_Errors.raise_error
                 (FStar_Errors.Fatal_UnexpectedPattern, "Unexpected pattern")
                 p1.FStar_Parser_AST.prange
           | FStar_Parser_AST.PatList pats ->
               let uu____3772 =
                 FStar_List.fold_right
                   (fun pat  ->
                      fun uu____3805  ->
                        match uu____3805 with
                        | (loc1,env2,pats1) ->
                            let uu____3837 = aux loc1 env2 pat  in
                            (match uu____3837 with
                             | (loc2,env3,uu____3862,pat1,uu____3864) ->
                                 (loc2, env3, (pat1 :: pats1)))) pats
                   (loc, env1, [])
                  in
               (match uu____3772 with
                | (loc1,env2,pats1) ->
                    let pat =
                      let uu____3907 =
                        let uu____3910 =
                          let uu____3917 =
                            FStar_Range.end_range p1.FStar_Parser_AST.prange
                             in
                          pos_r uu____3917  in
                        let uu____3918 =
                          let uu____3919 =
                            let uu____3932 =
                              FStar_Syntax_Syntax.lid_as_fv
                                FStar_Parser_Const.nil_lid
                                FStar_Syntax_Syntax.delta_constant
                                (FStar_Pervasives_Native.Some
                                   FStar_Syntax_Syntax.Data_ctor)
                               in
                            (uu____3932, [])  in
                          FStar_Syntax_Syntax.Pat_cons uu____3919  in
                        FStar_All.pipe_left uu____3910 uu____3918  in
                      FStar_List.fold_right
                        (fun hd1  ->
                           fun tl1  ->
                             let r =
                               FStar_Range.union_ranges
                                 hd1.FStar_Syntax_Syntax.p
                                 tl1.FStar_Syntax_Syntax.p
                                in
                             let uu____3964 =
                               let uu____3965 =
                                 let uu____3978 =
                                   FStar_Syntax_Syntax.lid_as_fv
                                     FStar_Parser_Const.cons_lid
                                     FStar_Syntax_Syntax.delta_constant
                                     (FStar_Pervasives_Native.Some
                                        FStar_Syntax_Syntax.Data_ctor)
                                    in
                                 (uu____3978, [(hd1, false); (tl1, false)])
                                  in
                               FStar_Syntax_Syntax.Pat_cons uu____3965  in
                             FStar_All.pipe_left (pos_r r) uu____3964) pats1
                        uu____3907
                       in
                    let x =
                      FStar_Syntax_Syntax.new_bv
                        (FStar_Pervasives_Native.Some
                           (p1.FStar_Parser_AST.prange))
                        FStar_Syntax_Syntax.tun
                       in
                    (loc1, env2,
                      (LocalBinder (x, FStar_Pervasives_Native.None)), pat,
                      false))
           | FStar_Parser_AST.PatTuple (args,dep1) ->
               let uu____4022 =
                 FStar_List.fold_left
                   (fun uu____4062  ->
                      fun p2  ->
                        match uu____4062 with
                        | (loc1,env2,pats) ->
                            let uu____4111 = aux loc1 env2 p2  in
                            (match uu____4111 with
                             | (loc2,env3,uu____4140,pat,uu____4142) ->
                                 (loc2, env3, ((pat, false) :: pats))))
                   (loc, env1, []) args
                  in
               (match uu____4022 with
                | (loc1,env2,args1) ->
                    let args2 = FStar_List.rev args1  in
                    let l =
                      if dep1
                      then
                        FStar_Parser_Const.mk_dtuple_data_lid
                          (FStar_List.length args2)
                          p1.FStar_Parser_AST.prange
                      else
                        FStar_Parser_Const.mk_tuple_data_lid
                          (FStar_List.length args2)
                          p1.FStar_Parser_AST.prange
                       in
                    let uu____4237 =
                      FStar_Syntax_DsEnv.fail_or env2
                        (FStar_Syntax_DsEnv.try_lookup_lid env2) l
                       in
                    (match uu____4237 with
                     | (constr,uu____4259) ->
                         let l1 =
                           match constr.FStar_Syntax_Syntax.n with
                           | FStar_Syntax_Syntax.Tm_fvar fv -> fv
                           | uu____4262 -> failwith "impossible"  in
                         let x =
                           FStar_Syntax_Syntax.new_bv
                             (FStar_Pervasives_Native.Some
                                (p1.FStar_Parser_AST.prange))
                             FStar_Syntax_Syntax.tun
                            in
                         let uu____4264 =
                           FStar_All.pipe_left pos
                             (FStar_Syntax_Syntax.Pat_cons (l1, args2))
                            in
                         (loc1, env2,
                           (LocalBinder (x, FStar_Pervasives_Native.None)),
                           uu____4264, false)))
           | FStar_Parser_AST.PatRecord [] ->
               FStar_Errors.raise_error
                 (FStar_Errors.Fatal_UnexpectedPattern, "Unexpected pattern")
                 p1.FStar_Parser_AST.prange
           | FStar_Parser_AST.PatRecord fields ->
               let record =
                 check_fields env1 fields p1.FStar_Parser_AST.prange  in
               let fields1 =
                 FStar_All.pipe_right fields
                   (FStar_List.map
                      (fun uu____4335  ->
                         match uu____4335 with
                         | (f,p2) -> ((f.FStar_Ident.ident), p2)))
                  in
               let args =
                 FStar_All.pipe_right record.FStar_Syntax_DsEnv.fields
                   (FStar_List.map
                      (fun uu____4365  ->
                         match uu____4365 with
                         | (f,uu____4371) ->
                             let uu____4372 =
                               FStar_All.pipe_right fields1
                                 (FStar_List.tryFind
                                    (fun uu____4398  ->
                                       match uu____4398 with
                                       | (g,uu____4404) ->
                                           f.FStar_Ident.idText =
                                             g.FStar_Ident.idText))
                                in
                             (match uu____4372 with
                              | FStar_Pervasives_Native.None  ->
                                  FStar_Parser_AST.mk_pattern
                                    FStar_Parser_AST.PatWild
                                    p1.FStar_Parser_AST.prange
                              | FStar_Pervasives_Native.Some (uu____4409,p2)
                                  -> p2)))
                  in
               let app =
                 let uu____4416 =
                   let uu____4417 =
                     let uu____4424 =
                       let uu____4425 =
                         let uu____4426 =
                           FStar_Ident.lid_of_ids
                             (FStar_List.append
                                (record.FStar_Syntax_DsEnv.typename).FStar_Ident.ns
                                [record.FStar_Syntax_DsEnv.constrname])
                            in
                         FStar_Parser_AST.PatName uu____4426  in
                       FStar_Parser_AST.mk_pattern uu____4425
                         p1.FStar_Parser_AST.prange
                        in
                     (uu____4424, args)  in
                   FStar_Parser_AST.PatApp uu____4417  in
                 FStar_Parser_AST.mk_pattern uu____4416
                   p1.FStar_Parser_AST.prange
                  in
               let uu____4429 = aux loc env1 app  in
               (match uu____4429 with
                | (env2,e,b,p2,uu____4458) ->
                    let p3 =
                      match p2.FStar_Syntax_Syntax.v with
                      | FStar_Syntax_Syntax.Pat_cons (fv,args1) ->
                          let uu____4486 =
                            let uu____4487 =
                              let uu____4500 =
                                let uu___146_4501 = fv  in
                                let uu____4502 =
                                  let uu____4505 =
                                    let uu____4506 =
                                      let uu____4513 =
                                        FStar_All.pipe_right
                                          record.FStar_Syntax_DsEnv.fields
                                          (FStar_List.map
                                             FStar_Pervasives_Native.fst)
                                         in
                                      ((record.FStar_Syntax_DsEnv.typename),
                                        uu____4513)
                                       in
                                    FStar_Syntax_Syntax.Record_ctor
                                      uu____4506
                                     in
                                  FStar_Pervasives_Native.Some uu____4505  in
                                {
                                  FStar_Syntax_Syntax.fv_name =
                                    (uu___146_4501.FStar_Syntax_Syntax.fv_name);
                                  FStar_Syntax_Syntax.fv_delta =
                                    (uu___146_4501.FStar_Syntax_Syntax.fv_delta);
                                  FStar_Syntax_Syntax.fv_qual = uu____4502
                                }  in
                              (uu____4500, args1)  in
                            FStar_Syntax_Syntax.Pat_cons uu____4487  in
                          FStar_All.pipe_left pos uu____4486
                      | uu____4540 -> p2  in
                    (env2, e, b, p3, false))
         
         and aux loc env1 p1 = aux' false loc env1 p1
          in
         let aux_maybe_or env1 p1 =
           let loc = []  in
           match p1.FStar_Parser_AST.pat with
           | FStar_Parser_AST.PatOr [] -> failwith "impossible"
           | FStar_Parser_AST.PatOr (p2::ps) ->
               let uu____4594 = aux' true loc env1 p2  in
               (match uu____4594 with
                | (loc1,env2,var,p3,uu____4621) ->
                    let uu____4626 =
                      FStar_List.fold_left
                        (fun uu____4658  ->
                           fun p4  ->
                             match uu____4658 with
                             | (loc2,env3,ps1) ->
                                 let uu____4691 = aux' true loc2 env3 p4  in
                                 (match uu____4691 with
                                  | (loc3,env4,uu____4716,p5,uu____4718) ->
                                      (loc3, env4, (p5 :: ps1))))
                        (loc1, env2, []) ps
                       in
                    (match uu____4626 with
                     | (loc2,env3,ps1) ->
                         let pats = p3 :: (FStar_List.rev ps1)  in
                         (env3, var, pats)))
           | uu____4769 ->
               let uu____4770 = aux' true loc env1 p1  in
               (match uu____4770 with
                | (loc1,env2,vars,pat,b) -> (env2, vars, [pat]))
            in
         let uu____4810 = aux_maybe_or env p  in
         match uu____4810 with
         | (env1,b,pats) ->
             (check_linear_pattern_variables pats p.FStar_Parser_AST.prange;
              (env1, b, pats)))

and (desugar_binding_pat_maybe_top :
  Prims.bool ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.pattern ->
        Prims.bool ->
          (env_t,bnd,FStar_Syntax_Syntax.pat Prims.list)
            FStar_Pervasives_Native.tuple3)
  =
  fun top  ->
    fun env  ->
      fun p  ->
        fun is_mut  ->
          let mklet x =
            let uu____4871 =
              let uu____4872 =
                let uu____4883 = FStar_Syntax_DsEnv.qualify env x  in
                (uu____4883,
                  (FStar_Syntax_Syntax.tun, FStar_Pervasives_Native.None))
                 in
              LetBinder uu____4872  in
            (env, uu____4871, [])  in
          if top
          then
            match p.FStar_Parser_AST.pat with
            | FStar_Parser_AST.PatOp x ->
                let uu____4911 =
                  let uu____4912 =
                    let uu____4917 =
                      FStar_Parser_AST.compile_op (Prims.parse_int "0")
                        x.FStar_Ident.idText x.FStar_Ident.idRange
                       in
                    (uu____4917, (x.FStar_Ident.idRange))  in
                  FStar_Ident.mk_ident uu____4912  in
                mklet uu____4911
            | FStar_Parser_AST.PatVar (x,uu____4919) -> mklet x
            | FStar_Parser_AST.PatAscribed
                ({
                   FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                     (x,uu____4925);
                   FStar_Parser_AST.prange = uu____4926;_},(t,tacopt))
                ->
                let tacopt1 = FStar_Util.map_opt tacopt (desugar_term env)
                   in
                let uu____4946 =
                  let uu____4947 =
                    let uu____4958 = FStar_Syntax_DsEnv.qualify env x  in
                    let uu____4959 =
                      let uu____4966 = desugar_term env t  in
                      (uu____4966, tacopt1)  in
                    (uu____4958, uu____4959)  in
                  LetBinder uu____4947  in
                (env, uu____4946, [])
            | uu____4977 ->
                FStar_Errors.raise_error
                  (FStar_Errors.Fatal_UnexpectedPattern,
                    "Unexpected pattern at the top-level")
                  p.FStar_Parser_AST.prange
          else
            (let uu____4987 = desugar_data_pat env p is_mut  in
             match uu____4987 with
             | (env1,binder,p1) ->
                 let p2 =
                   match p1 with
                   | {
                       FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_var
                         uu____5016;
                       FStar_Syntax_Syntax.p = uu____5017;_}::[] -> []
                   | {
                       FStar_Syntax_Syntax.v = FStar_Syntax_Syntax.Pat_wild
                         uu____5022;
                       FStar_Syntax_Syntax.p = uu____5023;_}::[] -> []
                   | uu____5028 -> p1  in
                 (env1, binder, p2))

and (desugar_binding_pat :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.pattern ->
      (env_t,bnd,FStar_Syntax_Syntax.pat Prims.list)
        FStar_Pervasives_Native.tuple3)
  = fun env  -> fun p  -> desugar_binding_pat_maybe_top false env p false

and (desugar_match_pat_maybe_top :
  Prims.bool ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.pattern ->
        (env_t,FStar_Syntax_Syntax.pat Prims.list)
          FStar_Pervasives_Native.tuple2)
  =
  fun uu____5035  ->
    fun env  ->
      fun pat  ->
        let uu____5038 = desugar_data_pat env pat false  in
        match uu____5038 with | (env1,uu____5054,pat1) -> (env1, pat1)

and (desugar_match_pat :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.pattern ->
      (env_t,FStar_Syntax_Syntax.pat Prims.list)
        FStar_Pervasives_Native.tuple2)
  = fun env  -> fun p  -> desugar_match_pat_maybe_top false env p

and (desugar_term_aq :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.term ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.antiquotations)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun e  ->
      let env1 = FStar_Syntax_DsEnv.set_expect_typ env false  in
      desugar_term_maybe_top false env1 e

and (desugar_term :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      let uu____5073 = desugar_term_aq env e  in
      match uu____5073 with | (t,aq) -> (check_no_aq aq; t)

and (desugar_typ_aq :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.term ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.antiquotations)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun e  ->
      let env1 = FStar_Syntax_DsEnv.set_expect_typ env true  in
      desugar_term_maybe_top false env1 e

and (desugar_typ :
  FStar_Syntax_DsEnv.env -> FStar_Parser_AST.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun e  ->
      let uu____5090 = desugar_typ_aq env e  in
      match uu____5090 with | (t,aq) -> (check_no_aq aq; t)

and (desugar_machine_integer :
  FStar_Syntax_DsEnv.env ->
    Prims.string ->
      (FStar_Const.signedness,FStar_Const.width)
        FStar_Pervasives_Native.tuple2 ->
        FStar_Range.range -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun repr  ->
      fun uu____5100  ->
        fun range  ->
          match uu____5100 with
          | (signedness,width) ->
              let tnm =
                Prims.strcat "FStar."
                  (Prims.strcat
                     (match signedness with
                      | FStar_Const.Unsigned  -> "U"
                      | FStar_Const.Signed  -> "")
                     (Prims.strcat "Int"
                        (match width with
                         | FStar_Const.Int8  -> "8"
                         | FStar_Const.Int16  -> "16"
                         | FStar_Const.Int32  -> "32"
                         | FStar_Const.Int64  -> "64")))
                 in
              ((let uu____5110 =
                  let uu____5111 =
                    FStar_Const.within_bounds repr signedness width  in
                  Prims.op_Negation uu____5111  in
                if uu____5110
                then
                  let uu____5112 =
                    let uu____5117 =
                      FStar_Util.format2
                        "%s is not in the expected range for %s" repr tnm
                       in
                    (FStar_Errors.Error_OutOfRange, uu____5117)  in
                  FStar_Errors.log_issue range uu____5112
                else ());
               (let private_intro_nm =
                  Prims.strcat tnm
                    (Prims.strcat ".__"
                       (Prims.strcat
                          (match signedness with
                           | FStar_Const.Unsigned  -> "u"
                           | FStar_Const.Signed  -> "") "int_to_t"))
                   in
                let intro_nm =
                  Prims.strcat tnm
                    (Prims.strcat "."
                       (Prims.strcat
                          (match signedness with
                           | FStar_Const.Unsigned  -> "u"
                           | FStar_Const.Signed  -> "") "int_to_t"))
                   in
                let lid =
                  let uu____5122 = FStar_Ident.path_of_text intro_nm  in
                  FStar_Ident.lid_of_path uu____5122 range  in
                let lid1 =
                  let uu____5126 = FStar_Syntax_DsEnv.try_lookup_lid env lid
                     in
                  match uu____5126 with
                  | FStar_Pervasives_Native.Some (intro_term,uu____5136) ->
                      (match intro_term.FStar_Syntax_Syntax.n with
                       | FStar_Syntax_Syntax.Tm_fvar fv ->
                           let private_lid =
                             let uu____5145 =
                               FStar_Ident.path_of_text private_intro_nm  in
                             FStar_Ident.lid_of_path uu____5145 range  in
                           let private_fv =
                             let uu____5147 =
                               FStar_Syntax_Util.incr_delta_depth
                                 fv.FStar_Syntax_Syntax.fv_delta
                                in
                             FStar_Syntax_Syntax.lid_as_fv private_lid
                               uu____5147 fv.FStar_Syntax_Syntax.fv_qual
                              in
                           let uu___147_5148 = intro_term  in
                           {
                             FStar_Syntax_Syntax.n =
                               (FStar_Syntax_Syntax.Tm_fvar private_fv);
                             FStar_Syntax_Syntax.pos =
                               (uu___147_5148.FStar_Syntax_Syntax.pos);
                             FStar_Syntax_Syntax.vars =
                               (uu___147_5148.FStar_Syntax_Syntax.vars)
                           }
                       | uu____5149 ->
                           failwith
                             (Prims.strcat "Unexpected non-fvar for "
                                intro_nm))
                  | FStar_Pervasives_Native.None  ->
                      let uu____5156 =
                        let uu____5161 =
                          FStar_Util.format1
                            "Unexpected numeric literal.  Restart F* to load %s."
                            tnm
                           in
                        (FStar_Errors.Fatal_UnexpectedNumericLiteral,
                          uu____5161)
                         in
                      FStar_Errors.raise_error uu____5156 range
                   in
                let repr1 =
                  FStar_Syntax_Syntax.mk
                    (FStar_Syntax_Syntax.Tm_constant
                       (FStar_Const.Const_int
                          (repr, FStar_Pervasives_Native.None)))
                    FStar_Pervasives_Native.None range
                   in
                let uu____5177 =
                  let uu____5184 =
                    let uu____5185 =
                      let uu____5200 =
                        let uu____5209 =
                          let uu____5216 =
                            FStar_Syntax_Syntax.as_implicit false  in
                          (repr1, uu____5216)  in
                        [uu____5209]  in
                      (lid1, uu____5200)  in
                    FStar_Syntax_Syntax.Tm_app uu____5185  in
                  FStar_Syntax_Syntax.mk uu____5184  in
                uu____5177 FStar_Pervasives_Native.None range))

and (desugar_name :
  (FStar_Syntax_Syntax.term' -> FStar_Syntax_Syntax.term) ->
    (FStar_Syntax_Syntax.term ->
       FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
      -> env_t -> Prims.bool -> FStar_Ident.lid -> FStar_Syntax_Syntax.term)
  =
  fun mk1  ->
    fun setpos  ->
      fun env  ->
        fun resolve  ->
          fun l  ->
            let uu____5255 =
              FStar_Syntax_DsEnv.fail_or env
                ((if resolve
                  then FStar_Syntax_DsEnv.try_lookup_lid_with_attributes
                  else
                    FStar_Syntax_DsEnv.try_lookup_lid_with_attributes_no_resolve)
                   env) l
               in
            match uu____5255 with
            | (tm,mut,attrs) ->
                let warn_if_deprecated attrs1 =
                  FStar_List.iter
                    (fun a  ->
                       match a.FStar_Syntax_Syntax.n with
                       | FStar_Syntax_Syntax.Tm_app
                           ({
                              FStar_Syntax_Syntax.n =
                                FStar_Syntax_Syntax.Tm_fvar fv;
                              FStar_Syntax_Syntax.pos = uu____5304;
                              FStar_Syntax_Syntax.vars = uu____5305;_},args)
                           when
                           FStar_Ident.lid_equals
                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                             FStar_Parser_Const.deprecated_attr
                           ->
                           let msg =
                             let uu____5328 =
                               FStar_Syntax_Print.term_to_string tm  in
                             Prims.strcat uu____5328 " is deprecated"  in
                           let msg1 =
                             if
                               (FStar_List.length args) >
                                 (Prims.parse_int "0")
                             then
                               let uu____5336 =
                                 let uu____5337 =
                                   let uu____5340 = FStar_List.hd args  in
                                   FStar_Pervasives_Native.fst uu____5340  in
                                 uu____5337.FStar_Syntax_Syntax.n  in
                               match uu____5336 with
                               | FStar_Syntax_Syntax.Tm_constant
                                   (FStar_Const.Const_string (s,uu____5356))
                                   when
                                   Prims.op_Negation
                                     ((FStar_Util.trim_string s) = "")
                                   ->
                                   Prims.strcat msg
                                     (Prims.strcat ", use "
                                        (Prims.strcat s " instead"))
                               | uu____5357 -> msg
                             else msg  in
                           let uu____5359 = FStar_Ident.range_of_lid l  in
                           FStar_Errors.log_issue uu____5359
                             (FStar_Errors.Warning_DeprecatedDefinition,
                               msg1)
                       | FStar_Syntax_Syntax.Tm_fvar fv when
                           FStar_Ident.lid_equals
                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                             FStar_Parser_Const.deprecated_attr
                           ->
                           let msg =
                             let uu____5362 =
                               FStar_Syntax_Print.term_to_string tm  in
                             Prims.strcat uu____5362 " is deprecated"  in
                           let uu____5363 = FStar_Ident.range_of_lid l  in
                           FStar_Errors.log_issue uu____5363
                             (FStar_Errors.Warning_DeprecatedDefinition, msg)
                       | uu____5364 -> ()) attrs1
                   in
                (warn_if_deprecated attrs;
                 (let tm1 = setpos tm  in
                  if mut
                  then
                    let uu____5369 =
                      let uu____5370 =
                        let uu____5377 = mk_ref_read tm1  in
                        (uu____5377,
                          (FStar_Syntax_Syntax.Meta_desugared
                             FStar_Syntax_Syntax.Mutable_rval))
                         in
                      FStar_Syntax_Syntax.Tm_meta uu____5370  in
                    FStar_All.pipe_left mk1 uu____5369
                  else tm1))

and (desugar_attributes :
  env_t ->
    FStar_Parser_AST.term Prims.list -> FStar_Syntax_Syntax.cflags Prims.list)
  =
  fun env  ->
    fun cattributes  ->
      let desugar_attribute t =
        let uu____5395 =
          let uu____5396 = unparen t  in uu____5396.FStar_Parser_AST.tm  in
        match uu____5395 with
        | FStar_Parser_AST.Var
            { FStar_Ident.ns = uu____5397; FStar_Ident.ident = uu____5398;
              FStar_Ident.nsstr = uu____5399; FStar_Ident.str = "cps";_}
            -> FStar_Syntax_Syntax.CPS
        | uu____5402 ->
            let uu____5403 =
              let uu____5408 =
                let uu____5409 = FStar_Parser_AST.term_to_string t  in
                Prims.strcat "Unknown attribute " uu____5409  in
              (FStar_Errors.Fatal_UnknownAttribute, uu____5408)  in
            FStar_Errors.raise_error uu____5403 t.FStar_Parser_AST.range
         in
      FStar_List.map desugar_attribute cattributes

and (desugar_term_maybe_top :
  Prims.bool ->
    env_t ->
      FStar_Parser_AST.term ->
        (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.antiquotations)
          FStar_Pervasives_Native.tuple2)
  =
  fun top_level  ->
    fun env  ->
      fun top  ->
        let mk1 e =
          FStar_Syntax_Syntax.mk e FStar_Pervasives_Native.None
            top.FStar_Parser_AST.range
           in
        let noaqs = []  in
        let join_aqs aqs = FStar_List.flatten aqs  in
        let setpos e =
          let uu___148_5504 = e  in
          {
            FStar_Syntax_Syntax.n = (uu___148_5504.FStar_Syntax_Syntax.n);
            FStar_Syntax_Syntax.pos = (top.FStar_Parser_AST.range);
            FStar_Syntax_Syntax.vars =
              (uu___148_5504.FStar_Syntax_Syntax.vars)
          }  in
        let uu____5507 =
          let uu____5508 = unparen top  in uu____5508.FStar_Parser_AST.tm  in
        match uu____5507 with
        | FStar_Parser_AST.Wild  -> ((setpos FStar_Syntax_Syntax.tun), noaqs)
        | FStar_Parser_AST.Labeled uu____5525 ->
            let uu____5532 = desugar_formula env top  in (uu____5532, noaqs)
        | FStar_Parser_AST.Requires (t,lopt) ->
            let uu____5549 = desugar_formula env t  in (uu____5549, noaqs)
        | FStar_Parser_AST.Ensures (t,lopt) ->
            let uu____5566 = desugar_formula env t  in (uu____5566, noaqs)
        | FStar_Parser_AST.Attributes ts ->
            failwith
              "Attributes should not be desugared by desugar_term_maybe_top"
        | FStar_Parser_AST.Const (FStar_Const.Const_int
            (i,FStar_Pervasives_Native.Some size)) ->
            let uu____5600 =
              desugar_machine_integer env i size top.FStar_Parser_AST.range
               in
            (uu____5600, noaqs)
        | FStar_Parser_AST.Const c ->
            let uu____5612 = mk1 (FStar_Syntax_Syntax.Tm_constant c)  in
            (uu____5612, noaqs)
        | FStar_Parser_AST.Op
            ({ FStar_Ident.idText = "=!="; FStar_Ident.idRange = r;_},args)
            ->
            let e =
              let uu____5634 =
                let uu____5635 =
                  let uu____5642 = FStar_Ident.mk_ident ("==", r)  in
                  (uu____5642, args)  in
                FStar_Parser_AST.Op uu____5635  in
              FStar_Parser_AST.mk_term uu____5634 top.FStar_Parser_AST.range
                top.FStar_Parser_AST.level
               in
            let uu____5645 =
              let uu____5646 =
                let uu____5647 =
                  let uu____5654 = FStar_Ident.mk_ident ("~", r)  in
                  (uu____5654, [e])  in
                FStar_Parser_AST.Op uu____5647  in
              FStar_Parser_AST.mk_term uu____5646 top.FStar_Parser_AST.range
                top.FStar_Parser_AST.level
               in
            desugar_term_aq env uu____5645
        | FStar_Parser_AST.Op (op_star,uu____5658::uu____5659::[]) when
            (let uu____5664 = FStar_Ident.text_of_id op_star  in
             uu____5664 = "*") &&
              (let uu____5666 =
                 op_as_term env (Prims.parse_int "2")
                   top.FStar_Parser_AST.range op_star
                  in
               FStar_All.pipe_right uu____5666 FStar_Option.isNone)
            ->
            let rec flatten1 t =
              match t.FStar_Parser_AST.tm with
              | FStar_Parser_AST.Op
                  ({ FStar_Ident.idText = "*";
                     FStar_Ident.idRange = uu____5681;_},t1::t2::[])
                  ->
                  let uu____5686 = flatten1 t1  in
                  FStar_List.append uu____5686 [t2]
              | uu____5689 -> [t]  in
            let uu____5690 =
              let uu____5699 =
                let uu____5706 =
                  let uu____5709 = unparen top  in flatten1 uu____5709  in
                FStar_All.pipe_right uu____5706
                  (FStar_List.map
                     (fun t  ->
                        let uu____5728 = desugar_typ_aq env t  in
                        match uu____5728 with
                        | (t',aq) ->
                            let uu____5739 = FStar_Syntax_Syntax.as_arg t'
                               in
                            (uu____5739, aq)))
                 in
              FStar_All.pipe_right uu____5699 FStar_List.unzip  in
            (match uu____5690 with
             | (targs,aqs) ->
                 let uu____5768 =
                   let uu____5773 =
                     FStar_Parser_Const.mk_tuple_lid
                       (FStar_List.length targs) top.FStar_Parser_AST.range
                      in
                   FStar_Syntax_DsEnv.fail_or env
                     (FStar_Syntax_DsEnv.try_lookup_lid env) uu____5773
                    in
                 (match uu____5768 with
                  | (tup,uu____5783) ->
                      let uu____5784 =
                        mk1 (FStar_Syntax_Syntax.Tm_app (tup, targs))  in
                      (uu____5784, (join_aqs aqs))))
        | FStar_Parser_AST.Tvar a ->
            let uu____5802 =
              let uu____5805 =
                let uu____5808 =
                  FStar_Syntax_DsEnv.fail_or2
                    (FStar_Syntax_DsEnv.try_lookup_id env) a
                   in
                FStar_Pervasives_Native.fst uu____5808  in
              FStar_All.pipe_left setpos uu____5805  in
            (uu____5802, noaqs)
        | FStar_Parser_AST.Uvar u ->
            let uu____5834 =
              let uu____5839 =
                let uu____5840 =
                  let uu____5841 = FStar_Ident.text_of_id u  in
                  Prims.strcat uu____5841 " in non-universe context"  in
                Prims.strcat "Unexpected universe variable " uu____5840  in
              (FStar_Errors.Fatal_UnexpectedUniverseVariable, uu____5839)  in
            FStar_Errors.raise_error uu____5834 top.FStar_Parser_AST.range
        | FStar_Parser_AST.Op (s,args) ->
            let uu____5852 =
              op_as_term env (FStar_List.length args)
                top.FStar_Parser_AST.range s
               in
            (match uu____5852 with
             | FStar_Pervasives_Native.None  ->
                 let uu____5859 =
                   let uu____5864 =
                     let uu____5865 = FStar_Ident.text_of_id s  in
                     Prims.strcat "Unexpected or unbound operator: "
                       uu____5865
                      in
                   (FStar_Errors.Fatal_UnepxectedOrUnboundOperator,
                     uu____5864)
                    in
                 FStar_Errors.raise_error uu____5859
                   top.FStar_Parser_AST.range
             | FStar_Pervasives_Native.Some op ->
                 if (FStar_List.length args) > (Prims.parse_int "0")
                 then
                   let uu____5875 =
                     let uu____5890 =
                       FStar_All.pipe_right args
                         (FStar_List.map
                            (fun t  ->
                               let uu____5932 = desugar_term_aq env t  in
                               match uu____5932 with
                               | (t',s1) ->
                                   ((t', FStar_Pervasives_Native.None), s1)))
                        in
                     FStar_All.pipe_right uu____5890 FStar_List.unzip  in
                   (match uu____5875 with
                    | (args1,aqs) ->
                        let uu____6015 =
                          mk1 (FStar_Syntax_Syntax.Tm_app (op, args1))  in
                        (uu____6015, (join_aqs aqs)))
                 else (op, noaqs))
        | FStar_Parser_AST.Construct (n1,(a,uu____6051)::[]) when
            n1.FStar_Ident.str = "SMTPat" ->
            let uu____6066 =
              let uu___149_6067 = top  in
              let uu____6068 =
                let uu____6069 =
                  let uu____6076 =
                    let uu___150_6077 = top  in
                    let uu____6078 =
                      let uu____6079 =
                        FStar_Ident.lid_of_path ["Prims"; "smt_pat"]
                          top.FStar_Parser_AST.range
                         in
                      FStar_Parser_AST.Var uu____6079  in
                    {
                      FStar_Parser_AST.tm = uu____6078;
                      FStar_Parser_AST.range =
                        (uu___150_6077.FStar_Parser_AST.range);
                      FStar_Parser_AST.level =
                        (uu___150_6077.FStar_Parser_AST.level)
                    }  in
                  (uu____6076, a, FStar_Parser_AST.Nothing)  in
                FStar_Parser_AST.App uu____6069  in
              {
                FStar_Parser_AST.tm = uu____6068;
                FStar_Parser_AST.range =
                  (uu___149_6067.FStar_Parser_AST.range);
                FStar_Parser_AST.level =
                  (uu___149_6067.FStar_Parser_AST.level)
              }  in
            desugar_term_maybe_top top_level env uu____6066
        | FStar_Parser_AST.Construct (n1,(a,uu____6082)::[]) when
            n1.FStar_Ident.str = "SMTPatT" ->
            (FStar_Errors.log_issue top.FStar_Parser_AST.range
               (FStar_Errors.Warning_SMTPatTDeprecated,
                 "SMTPatT is deprecated; please just use SMTPat");
             (let uu____6098 =
                let uu___151_6099 = top  in
                let uu____6100 =
                  let uu____6101 =
                    let uu____6108 =
                      let uu___152_6109 = top  in
                      let uu____6110 =
                        let uu____6111 =
                          FStar_Ident.lid_of_path ["Prims"; "smt_pat"]
                            top.FStar_Parser_AST.range
                           in
                        FStar_Parser_AST.Var uu____6111  in
                      {
                        FStar_Parser_AST.tm = uu____6110;
                        FStar_Parser_AST.range =
                          (uu___152_6109.FStar_Parser_AST.range);
                        FStar_Parser_AST.level =
                          (uu___152_6109.FStar_Parser_AST.level)
                      }  in
                    (uu____6108, a, FStar_Parser_AST.Nothing)  in
                  FStar_Parser_AST.App uu____6101  in
                {
                  FStar_Parser_AST.tm = uu____6100;
                  FStar_Parser_AST.range =
                    (uu___151_6099.FStar_Parser_AST.range);
                  FStar_Parser_AST.level =
                    (uu___151_6099.FStar_Parser_AST.level)
                }  in
              desugar_term_maybe_top top_level env uu____6098))
        | FStar_Parser_AST.Construct (n1,(a,uu____6114)::[]) when
            n1.FStar_Ident.str = "SMTPatOr" ->
            let uu____6129 =
              let uu___153_6130 = top  in
              let uu____6131 =
                let uu____6132 =
                  let uu____6139 =
                    let uu___154_6140 = top  in
                    let uu____6141 =
                      let uu____6142 =
                        FStar_Ident.lid_of_path ["Prims"; "smt_pat_or"]
                          top.FStar_Parser_AST.range
                         in
                      FStar_Parser_AST.Var uu____6142  in
                    {
                      FStar_Parser_AST.tm = uu____6141;
                      FStar_Parser_AST.range =
                        (uu___154_6140.FStar_Parser_AST.range);
                      FStar_Parser_AST.level =
                        (uu___154_6140.FStar_Parser_AST.level)
                    }  in
                  (uu____6139, a, FStar_Parser_AST.Nothing)  in
                FStar_Parser_AST.App uu____6132  in
              {
                FStar_Parser_AST.tm = uu____6131;
                FStar_Parser_AST.range =
                  (uu___153_6130.FStar_Parser_AST.range);
                FStar_Parser_AST.level =
                  (uu___153_6130.FStar_Parser_AST.level)
              }  in
            desugar_term_maybe_top top_level env uu____6129
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____6143; FStar_Ident.ident = uu____6144;
              FStar_Ident.nsstr = uu____6145; FStar_Ident.str = "Type0";_}
            ->
            let uu____6148 =
              mk1 (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_zero)
               in
            (uu____6148, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____6163; FStar_Ident.ident = uu____6164;
              FStar_Ident.nsstr = uu____6165; FStar_Ident.str = "Type";_}
            ->
            let uu____6168 =
              mk1 (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_unknown)
               in
            (uu____6168, noaqs)
        | FStar_Parser_AST.Construct
            ({ FStar_Ident.ns = uu____6183; FStar_Ident.ident = uu____6184;
               FStar_Ident.nsstr = uu____6185; FStar_Ident.str = "Type";_},
             (t,FStar_Parser_AST.UnivApp )::[])
            ->
            let uu____6203 =
              let uu____6206 =
                let uu____6207 = desugar_universe t  in
                FStar_Syntax_Syntax.Tm_type uu____6207  in
              mk1 uu____6206  in
            (uu____6203, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____6220; FStar_Ident.ident = uu____6221;
              FStar_Ident.nsstr = uu____6222; FStar_Ident.str = "Effect";_}
            ->
            let uu____6225 =
              mk1 (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_effect)
               in
            (uu____6225, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____6240; FStar_Ident.ident = uu____6241;
              FStar_Ident.nsstr = uu____6242; FStar_Ident.str = "True";_}
            ->
            let uu____6245 =
              let uu____6246 =
                FStar_Ident.set_lid_range FStar_Parser_Const.true_lid
                  top.FStar_Parser_AST.range
                 in
              FStar_Syntax_Syntax.fvar uu____6246
                FStar_Syntax_Syntax.delta_constant
                FStar_Pervasives_Native.None
               in
            (uu____6245, noaqs)
        | FStar_Parser_AST.Name
            { FStar_Ident.ns = uu____6257; FStar_Ident.ident = uu____6258;
              FStar_Ident.nsstr = uu____6259; FStar_Ident.str = "False";_}
            ->
            let uu____6262 =
              let uu____6263 =
                FStar_Ident.set_lid_range FStar_Parser_Const.false_lid
                  top.FStar_Parser_AST.range
                 in
              FStar_Syntax_Syntax.fvar uu____6263
                FStar_Syntax_Syntax.delta_constant
                FStar_Pervasives_Native.None
               in
            (uu____6262, noaqs)
        | FStar_Parser_AST.Projector
            (eff_name,{ FStar_Ident.idText = txt;
                        FStar_Ident.idRange = uu____6276;_})
            when
            (is_special_effect_combinator txt) &&
              (FStar_Syntax_DsEnv.is_effect_name env eff_name)
            ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env eff_name;
             (let uu____6278 =
                FStar_Syntax_DsEnv.try_lookup_effect_defn env eff_name  in
              match uu____6278 with
              | FStar_Pervasives_Native.Some ed ->
                  let lid = FStar_Syntax_Util.dm4f_lid ed txt  in
                  let uu____6287 =
                    FStar_Syntax_Syntax.fvar lid
                      (FStar_Syntax_Syntax.Delta_constant_at_level
                         (Prims.parse_int "1")) FStar_Pervasives_Native.None
                     in
                  (uu____6287, noaqs)
              | FStar_Pervasives_Native.None  ->
                  let uu____6298 =
                    let uu____6299 = FStar_Ident.text_of_lid eff_name  in
                    FStar_Util.format2
                      "Member %s of effect %s is not accessible (using an effect abbreviation instead of the original effect ?)"
                      uu____6299 txt
                     in
                  failwith uu____6298))
        | FStar_Parser_AST.Var l ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let uu____6306 = desugar_name mk1 setpos env true l  in
              (uu____6306, noaqs)))
        | FStar_Parser_AST.Name l ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let uu____6319 = desugar_name mk1 setpos env true l  in
              (uu____6319, noaqs)))
        | FStar_Parser_AST.Projector (l,i) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let name =
                let uu____6340 = FStar_Syntax_DsEnv.try_lookup_datacon env l
                   in
                match uu____6340 with
                | FStar_Pervasives_Native.Some uu____6349 ->
                    FStar_Pervasives_Native.Some (true, l)
                | FStar_Pervasives_Native.None  ->
                    let uu____6354 =
                      FStar_Syntax_DsEnv.try_lookup_root_effect_name env l
                       in
                    (match uu____6354 with
                     | FStar_Pervasives_Native.Some new_name ->
                         FStar_Pervasives_Native.Some (false, new_name)
                     | uu____6368 -> FStar_Pervasives_Native.None)
                 in
              match name with
              | FStar_Pervasives_Native.Some (resolve,new_name) ->
                  let uu____6385 =
                    let uu____6386 =
                      FStar_Syntax_Util.mk_field_projector_name_from_ident
                        new_name i
                       in
                    desugar_name mk1 setpos env resolve uu____6386  in
                  (uu____6385, noaqs)
              | uu____6397 ->
                  let uu____6404 =
                    let uu____6409 =
                      FStar_Util.format1
                        "Data constructor or effect %s not found"
                        l.FStar_Ident.str
                       in
                    (FStar_Errors.Fatal_EffectNotFound, uu____6409)  in
                  FStar_Errors.raise_error uu____6404
                    top.FStar_Parser_AST.range))
        | FStar_Parser_AST.Discrim lid ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env lid;
             (let uu____6416 = FStar_Syntax_DsEnv.try_lookup_datacon env lid
                 in
              match uu____6416 with
              | FStar_Pervasives_Native.None  ->
                  let uu____6423 =
                    let uu____6428 =
                      FStar_Util.format1 "Data constructor %s not found"
                        lid.FStar_Ident.str
                       in
                    (FStar_Errors.Fatal_DataContructorNotFound, uu____6428)
                     in
                  FStar_Errors.raise_error uu____6423
                    top.FStar_Parser_AST.range
              | uu____6433 ->
                  let lid' = FStar_Syntax_Util.mk_discriminator lid  in
                  let uu____6437 = desugar_name mk1 setpos env true lid'  in
                  (uu____6437, noaqs)))
        | FStar_Parser_AST.Construct (l,args) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env l;
             (let uu____6463 = FStar_Syntax_DsEnv.try_lookup_datacon env l
                 in
              match uu____6463 with
              | FStar_Pervasives_Native.Some head1 ->
                  let head2 = mk1 (FStar_Syntax_Syntax.Tm_fvar head1)  in
                  (match args with
                   | [] -> (head2, noaqs)
                   | uu____6494 ->
                       let uu____6501 =
                         FStar_Util.take
                           (fun uu____6525  ->
                              match uu____6525 with
                              | (uu____6530,imp) ->
                                  imp = FStar_Parser_AST.UnivApp) args
                          in
                       (match uu____6501 with
                        | (universes,args1) ->
                            let universes1 =
                              FStar_List.map
                                (fun x  ->
                                   desugar_universe
                                     (FStar_Pervasives_Native.fst x))
                                universes
                               in
                            let uu____6575 =
                              let uu____6590 =
                                FStar_List.map
                                  (fun uu____6623  ->
                                     match uu____6623 with
                                     | (t,imp) ->
                                         let uu____6640 =
                                           desugar_term_aq env t  in
                                         (match uu____6640 with
                                          | (te,aq) ->
                                              ((arg_withimp_e imp te), aq)))
                                  args1
                                 in
                              FStar_All.pipe_right uu____6590
                                FStar_List.unzip
                               in
                            (match uu____6575 with
                             | (args2,aqs) ->
                                 let head3 =
                                   if universes1 = []
                                   then head2
                                   else
                                     mk1
                                       (FStar_Syntax_Syntax.Tm_uinst
                                          (head2, universes1))
                                    in
                                 let uu____6733 =
                                   mk1
                                     (FStar_Syntax_Syntax.Tm_app
                                        (head3, args2))
                                    in
                                 (uu____6733, (join_aqs aqs)))))
              | FStar_Pervasives_Native.None  ->
                  let err =
                    let uu____6763 =
                      FStar_Syntax_DsEnv.try_lookup_effect_name env l  in
                    match uu____6763 with
                    | FStar_Pervasives_Native.None  ->
                        (FStar_Errors.Fatal_ConstructorNotFound,
                          (Prims.strcat "Constructor "
                             (Prims.strcat l.FStar_Ident.str " not found")))
                    | FStar_Pervasives_Native.Some uu____6770 ->
                        (FStar_Errors.Fatal_UnexpectedEffect,
                          (Prims.strcat "Effect "
                             (Prims.strcat l.FStar_Ident.str
                                " used at an unexpected position")))
                     in
                  FStar_Errors.raise_error err top.FStar_Parser_AST.range))
        | FStar_Parser_AST.Sum (binders,t) ->
            let uu____6781 =
              FStar_List.fold_left
                (fun uu____6826  ->
                   fun b  ->
                     match uu____6826 with
                     | (env1,tparams,typs) ->
                         let uu____6883 = desugar_binder env1 b  in
                         (match uu____6883 with
                          | (xopt,t1) ->
                              let uu____6912 =
                                match xopt with
                                | FStar_Pervasives_Native.None  ->
                                    let uu____6921 =
                                      FStar_Syntax_Syntax.new_bv
                                        (FStar_Pervasives_Native.Some
                                           (top.FStar_Parser_AST.range))
                                        FStar_Syntax_Syntax.tun
                                       in
                                    (env1, uu____6921)
                                | FStar_Pervasives_Native.Some x ->
                                    FStar_Syntax_DsEnv.push_bv env1 x
                                 in
                              (match uu____6912 with
                               | (env2,x) ->
                                   let uu____6941 =
                                     let uu____6944 =
                                       let uu____6947 =
                                         let uu____6948 =
                                           no_annot_abs tparams t1  in
                                         FStar_All.pipe_left
                                           FStar_Syntax_Syntax.as_arg
                                           uu____6948
                                          in
                                       [uu____6947]  in
                                     FStar_List.append typs uu____6944  in
                                   (env2,
                                     (FStar_List.append tparams
                                        [(((let uu___155_6974 = x  in
                                            {
                                              FStar_Syntax_Syntax.ppname =
                                                (uu___155_6974.FStar_Syntax_Syntax.ppname);
                                              FStar_Syntax_Syntax.index =
                                                (uu___155_6974.FStar_Syntax_Syntax.index);
                                              FStar_Syntax_Syntax.sort = t1
                                            })),
                                           FStar_Pervasives_Native.None)]),
                                     uu____6941)))) (env, [], [])
                (FStar_List.append binders
                   [FStar_Parser_AST.mk_binder (FStar_Parser_AST.NoName t)
                      t.FStar_Parser_AST.range FStar_Parser_AST.Type_level
                      FStar_Pervasives_Native.None])
               in
            (match uu____6781 with
             | (env1,uu____7002,targs) ->
                 let uu____7024 =
                   let uu____7029 =
                     FStar_Parser_Const.mk_dtuple_lid
                       (FStar_List.length targs) top.FStar_Parser_AST.range
                      in
                   FStar_Syntax_DsEnv.fail_or env1
                     (FStar_Syntax_DsEnv.try_lookup_lid env1) uu____7029
                    in
                 (match uu____7024 with
                  | (tup,uu____7039) ->
                      let uu____7040 =
                        FStar_All.pipe_left mk1
                          (FStar_Syntax_Syntax.Tm_app (tup, targs))
                         in
                      (uu____7040, noaqs)))
        | FStar_Parser_AST.Product (binders,t) ->
            let uu____7065 = uncurry binders t  in
            (match uu____7065 with
             | (bs,t1) ->
                 let rec aux env1 bs1 uu___121_7107 =
                   match uu___121_7107 with
                   | [] ->
                       let cod =
                         desugar_comp top.FStar_Parser_AST.range env1 t1  in
                       let uu____7121 =
                         FStar_Syntax_Util.arrow (FStar_List.rev bs1) cod  in
                       FStar_All.pipe_left setpos uu____7121
                   | hd1::tl1 ->
                       let bb = desugar_binder env1 hd1  in
                       let uu____7143 =
                         as_binder env1 hd1.FStar_Parser_AST.aqual bb  in
                       (match uu____7143 with
                        | (b,env2) -> aux env2 (b :: bs1) tl1)
                    in
                 let uu____7152 = aux env [] bs  in (uu____7152, noaqs))
        | FStar_Parser_AST.Refine (b,f) ->
            let uu____7173 = desugar_binder env b  in
            (match uu____7173 with
             | (FStar_Pervasives_Native.None ,uu____7184) ->
                 failwith "Missing binder in refinement"
             | b1 ->
                 let uu____7198 =
                   as_binder env FStar_Pervasives_Native.None b1  in
                 (match uu____7198 with
                  | ((x,uu____7208),env1) ->
                      let f1 = desugar_formula env1 f  in
                      let uu____7215 =
                        let uu____7218 = FStar_Syntax_Util.refine x f1  in
                        FStar_All.pipe_left setpos uu____7218  in
                      (uu____7215, noaqs)))
        | FStar_Parser_AST.Abs (binders,body) ->
            let binders1 =
              FStar_All.pipe_right binders
                (FStar_List.map replace_unit_pattern)
               in
            let uu____7250 =
              FStar_List.fold_left
                (fun uu____7270  ->
                   fun pat  ->
                     match uu____7270 with
                     | (env1,ftvs) ->
                         (match pat.FStar_Parser_AST.pat with
                          | FStar_Parser_AST.PatAscribed
                              (uu____7296,(t,FStar_Pervasives_Native.None ))
                              ->
                              let uu____7306 =
                                let uu____7309 = free_type_vars env1 t  in
                                FStar_List.append uu____7309 ftvs  in
                              (env1, uu____7306)
                          | FStar_Parser_AST.PatAscribed
                              (uu____7314,(t,FStar_Pervasives_Native.Some
                                           tac))
                              ->
                              let uu____7325 =
                                let uu____7328 = free_type_vars env1 t  in
                                let uu____7331 =
                                  let uu____7334 = free_type_vars env1 tac
                                     in
                                  FStar_List.append uu____7334 ftvs  in
                                FStar_List.append uu____7328 uu____7331  in
                              (env1, uu____7325)
                          | uu____7339 -> (env1, ftvs))) (env, []) binders1
               in
            (match uu____7250 with
             | (uu____7348,ftv) ->
                 let ftv1 = sort_ftv ftv  in
                 let binders2 =
                   let uu____7360 =
                     FStar_All.pipe_right ftv1
                       (FStar_List.map
                          (fun a  ->
                             FStar_Parser_AST.mk_pattern
                               (FStar_Parser_AST.PatTvar
                                  (a,
                                    (FStar_Pervasives_Native.Some
                                       FStar_Parser_AST.Implicit)))
                               top.FStar_Parser_AST.range))
                      in
                   FStar_List.append uu____7360 binders1  in
                 let rec aux env1 bs sc_pat_opt uu___122_7413 =
                   match uu___122_7413 with
                   | [] ->
                       let uu____7436 = desugar_term_aq env1 body  in
                       (match uu____7436 with
                        | (body1,aq) ->
                            let body2 =
                              match sc_pat_opt with
                              | FStar_Pervasives_Native.Some (sc,pat) ->
                                  let body2 =
                                    let uu____7467 =
                                      let uu____7468 =
                                        FStar_Syntax_Syntax.pat_bvs pat  in
                                      FStar_All.pipe_right uu____7468
                                        (FStar_List.map
                                           FStar_Syntax_Syntax.mk_binder)
                                       in
                                    FStar_Syntax_Subst.close uu____7467 body1
                                     in
                                  FStar_Syntax_Syntax.mk
                                    (FStar_Syntax_Syntax.Tm_match
                                       (sc,
                                         [(pat, FStar_Pervasives_Native.None,
                                            body2)]))
                                    FStar_Pervasives_Native.None
                                    body2.FStar_Syntax_Syntax.pos
                              | FStar_Pervasives_Native.None  -> body1  in
                            let uu____7521 =
                              let uu____7524 =
                                no_annot_abs (FStar_List.rev bs) body2  in
                              setpos uu____7524  in
                            (uu____7521, aq))
                   | p::rest ->
                       let uu____7537 = desugar_binding_pat env1 p  in
                       (match uu____7537 with
                        | (env2,b,pat) ->
                            let pat1 =
                              match pat with
                              | [] -> FStar_Pervasives_Native.None
                              | p1::[] -> FStar_Pervasives_Native.Some p1
                              | uu____7565 ->
                                  FStar_Errors.raise_error
                                    (FStar_Errors.Fatal_UnsupportedDisjuctivePatterns,
                                      "Disjunctive patterns are not supported in abstractions")
                                    p.FStar_Parser_AST.prange
                               in
                            let uu____7570 =
                              match b with
                              | LetBinder uu____7603 -> failwith "Impossible"
                              | LocalBinder (x,aq) ->
                                  let sc_pat_opt1 =
                                    match (pat1, sc_pat_opt) with
                                    | (FStar_Pervasives_Native.None
                                       ,uu____7659) -> sc_pat_opt
                                    | (FStar_Pervasives_Native.Some
                                       p1,FStar_Pervasives_Native.None ) ->
                                        let uu____7695 =
                                          let uu____7700 =
                                            FStar_Syntax_Syntax.bv_to_name x
                                             in
                                          (uu____7700, p1)  in
                                        FStar_Pervasives_Native.Some
                                          uu____7695
                                    | (FStar_Pervasives_Native.Some
                                       p1,FStar_Pervasives_Native.Some
                                       (sc,p')) ->
                                        (match ((sc.FStar_Syntax_Syntax.n),
                                                 (p'.FStar_Syntax_Syntax.v))
                                         with
                                         | (FStar_Syntax_Syntax.Tm_name
                                            uu____7736,uu____7737) ->
                                             let tup2 =
                                               let uu____7739 =
                                                 FStar_Parser_Const.mk_tuple_data_lid
                                                   (Prims.parse_int "2")
                                                   top.FStar_Parser_AST.range
                                                  in
                                               FStar_Syntax_Syntax.lid_as_fv
                                                 uu____7739
                                                 FStar_Syntax_Syntax.delta_constant
                                                 (FStar_Pervasives_Native.Some
                                                    FStar_Syntax_Syntax.Data_ctor)
                                                in
                                             let sc1 =
                                               let uu____7743 =
                                                 let uu____7750 =
                                                   let uu____7751 =
                                                     let uu____7766 =
                                                       mk1
                                                         (FStar_Syntax_Syntax.Tm_fvar
                                                            tup2)
                                                        in
                                                     let uu____7769 =
                                                       let uu____7772 =
                                                         FStar_Syntax_Syntax.as_arg
                                                           sc
                                                          in
                                                       let uu____7773 =
                                                         let uu____7776 =
                                                           let uu____7777 =
                                                             FStar_Syntax_Syntax.bv_to_name
                                                               x
                                                              in
                                                           FStar_All.pipe_left
                                                             FStar_Syntax_Syntax.as_arg
                                                             uu____7777
                                                            in
                                                         [uu____7776]  in
                                                       uu____7772 ::
                                                         uu____7773
                                                        in
                                                     (uu____7766, uu____7769)
                                                      in
                                                   FStar_Syntax_Syntax.Tm_app
                                                     uu____7751
                                                    in
                                                 FStar_Syntax_Syntax.mk
                                                   uu____7750
                                                  in
                                               uu____7743
                                                 FStar_Pervasives_Native.None
                                                 top.FStar_Parser_AST.range
                                                in
                                             let p2 =
                                               let uu____7788 =
                                                 FStar_Range.union_ranges
                                                   p'.FStar_Syntax_Syntax.p
                                                   p1.FStar_Syntax_Syntax.p
                                                  in
                                               FStar_Syntax_Syntax.withinfo
                                                 (FStar_Syntax_Syntax.Pat_cons
                                                    (tup2,
                                                      [(p', false);
                                                      (p1, false)]))
                                                 uu____7788
                                                in
                                             FStar_Pervasives_Native.Some
                                               (sc1, p2)
                                         | (FStar_Syntax_Syntax.Tm_app
                                            (uu____7819,args),FStar_Syntax_Syntax.Pat_cons
                                            (uu____7821,pats)) ->
                                             let tupn =
                                               let uu____7860 =
                                                 FStar_Parser_Const.mk_tuple_data_lid
                                                   ((Prims.parse_int "1") +
                                                      (FStar_List.length args))
                                                   top.FStar_Parser_AST.range
                                                  in
                                               FStar_Syntax_Syntax.lid_as_fv
                                                 uu____7860
                                                 FStar_Syntax_Syntax.delta_constant
                                                 (FStar_Pervasives_Native.Some
                                                    FStar_Syntax_Syntax.Data_ctor)
                                                in
                                             let sc1 =
                                               let uu____7870 =
                                                 let uu____7871 =
                                                   let uu____7886 =
                                                     mk1
                                                       (FStar_Syntax_Syntax.Tm_fvar
                                                          tupn)
                                                      in
                                                   let uu____7889 =
                                                     let uu____7898 =
                                                       let uu____7907 =
                                                         let uu____7908 =
                                                           FStar_Syntax_Syntax.bv_to_name
                                                             x
                                                            in
                                                         FStar_All.pipe_left
                                                           FStar_Syntax_Syntax.as_arg
                                                           uu____7908
                                                          in
                                                       [uu____7907]  in
                                                     FStar_List.append args
                                                       uu____7898
                                                      in
                                                   (uu____7886, uu____7889)
                                                    in
                                                 FStar_Syntax_Syntax.Tm_app
                                                   uu____7871
                                                  in
                                               mk1 uu____7870  in
                                             let p2 =
                                               let uu____7928 =
                                                 FStar_Range.union_ranges
                                                   p'.FStar_Syntax_Syntax.p
                                                   p1.FStar_Syntax_Syntax.p
                                                  in
                                               FStar_Syntax_Syntax.withinfo
                                                 (FStar_Syntax_Syntax.Pat_cons
                                                    (tupn,
                                                      (FStar_List.append pats
                                                         [(p1, false)])))
                                                 uu____7928
                                                in
                                             FStar_Pervasives_Native.Some
                                               (sc1, p2)
                                         | uu____7963 ->
                                             failwith "Impossible")
                                     in
                                  ((x, aq), sc_pat_opt1)
                               in
                            (match uu____7570 with
                             | (b1,sc_pat_opt1) ->
                                 aux env2 (b1 :: bs) sc_pat_opt1 rest))
                    in
                 aux env [] FStar_Pervasives_Native.None binders2)
        | FStar_Parser_AST.App
            (uu____8034,uu____8035,FStar_Parser_AST.UnivApp ) ->
            let rec aux universes e =
              let uu____8057 =
                let uu____8058 = unparen e  in uu____8058.FStar_Parser_AST.tm
                 in
              match uu____8057 with
              | FStar_Parser_AST.App (e1,t,FStar_Parser_AST.UnivApp ) ->
                  let univ_arg = desugar_universe t  in
                  aux (univ_arg :: universes) e1
              | uu____8068 ->
                  let uu____8069 = desugar_term_aq env e  in
                  (match uu____8069 with
                   | (head1,aq) ->
                       let uu____8082 =
                         mk1
                           (FStar_Syntax_Syntax.Tm_uinst (head1, universes))
                          in
                       (uu____8082, aq))
               in
            aux [] top
        | FStar_Parser_AST.App uu____8089 ->
            let rec aux args aqs e =
              let uu____8148 =
                let uu____8149 = unparen e  in uu____8149.FStar_Parser_AST.tm
                 in
              match uu____8148 with
              | FStar_Parser_AST.App (e1,t,imp) when
                  imp <> FStar_Parser_AST.UnivApp ->
                  let uu____8169 = desugar_term_aq env t  in
                  (match uu____8169 with
                   | (t1,aq) ->
                       let arg = arg_withimp_e imp t1  in
                       aux (arg :: args) (aq :: aqs) e1)
              | uu____8205 ->
                  let uu____8206 = desugar_term_aq env e  in
                  (match uu____8206 with
                   | (head1,aq) ->
                       let uu____8229 =
                         mk1 (FStar_Syntax_Syntax.Tm_app (head1, args))  in
                       (uu____8229, (join_aqs (aq :: aqs))))
               in
            aux [] [] top
        | FStar_Parser_AST.Bind (x,t1,t2) ->
            let xpat =
              FStar_Parser_AST.mk_pattern
                (FStar_Parser_AST.PatVar (x, FStar_Pervasives_Native.None))
                x.FStar_Ident.idRange
               in
            let k =
              FStar_Parser_AST.mk_term (FStar_Parser_AST.Abs ([xpat], t2))
                t2.FStar_Parser_AST.range t2.FStar_Parser_AST.level
               in
            let bind_lid =
              FStar_Ident.lid_of_path ["bind"] x.FStar_Ident.idRange  in
            let bind1 =
              FStar_Parser_AST.mk_term (FStar_Parser_AST.Var bind_lid)
                x.FStar_Ident.idRange FStar_Parser_AST.Expr
               in
            let uu____8269 =
              FStar_Parser_AST.mkExplicitApp bind1 [t1; k]
                top.FStar_Parser_AST.range
               in
            desugar_term_aq env uu____8269
        | FStar_Parser_AST.Seq (t1,t2) ->
            let t =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.Let
                   (FStar_Parser_AST.NoLetQualifier,
                     [(FStar_Pervasives_Native.None,
                        ((FStar_Parser_AST.mk_pattern
                            FStar_Parser_AST.PatWild
                            t1.FStar_Parser_AST.range), t1))], t2))
                top.FStar_Parser_AST.range FStar_Parser_AST.Expr
               in
            let uu____8321 = desugar_term_aq env t  in
            (match uu____8321 with
             | (tm,s) ->
                 let uu____8332 =
                   mk1
                     (FStar_Syntax_Syntax.Tm_meta
                        (tm,
                          (FStar_Syntax_Syntax.Meta_desugared
                             FStar_Syntax_Syntax.Sequence)))
                    in
                 (uu____8332, s))
        | FStar_Parser_AST.LetOpen (lid,e) ->
            let env1 = FStar_Syntax_DsEnv.push_namespace env lid  in
            let uu____8340 =
              let uu____8353 = FStar_Syntax_DsEnv.expect_typ env1  in
              if uu____8353 then desugar_typ_aq else desugar_term_aq  in
            uu____8340 env1 e
        | FStar_Parser_AST.Let (qual,lbs,body) ->
            let is_rec = qual = FStar_Parser_AST.Rec  in
            let ds_let_rec_or_app uu____8408 =
              let bindings = lbs  in
              let funs =
                FStar_All.pipe_right bindings
                  (FStar_List.map
                     (fun uu____8551  ->
                        match uu____8551 with
                        | (attr_opt,(p,def)) ->
                            let uu____8609 = is_app_pattern p  in
                            if uu____8609
                            then
                              let uu____8640 =
                                destruct_app_pattern env top_level p  in
                              (attr_opt, uu____8640, def)
                            else
                              (match FStar_Parser_AST.un_function p def with
                               | FStar_Pervasives_Native.Some (p1,def1) ->
                                   let uu____8722 =
                                     destruct_app_pattern env top_level p1
                                      in
                                   (attr_opt, uu____8722, def1)
                               | uu____8767 ->
                                   (match p.FStar_Parser_AST.pat with
                                    | FStar_Parser_AST.PatAscribed
                                        ({
                                           FStar_Parser_AST.pat =
                                             FStar_Parser_AST.PatVar
                                             (id1,uu____8805);
                                           FStar_Parser_AST.prange =
                                             uu____8806;_},t)
                                        ->
                                        if top_level
                                        then
                                          let uu____8854 =
                                            let uu____8875 =
                                              let uu____8880 =
                                                FStar_Syntax_DsEnv.qualify
                                                  env id1
                                                 in
                                              FStar_Util.Inr uu____8880  in
                                            (uu____8875, [],
                                              (FStar_Pervasives_Native.Some t))
                                             in
                                          (attr_opt, uu____8854, def)
                                        else
                                          (attr_opt,
                                            ((FStar_Util.Inl id1), [],
                                              (FStar_Pervasives_Native.Some t)),
                                            def)
                                    | FStar_Parser_AST.PatVar
                                        (id1,uu____8971) ->
                                        if top_level
                                        then
                                          let uu____9006 =
                                            let uu____9027 =
                                              let uu____9032 =
                                                FStar_Syntax_DsEnv.qualify
                                                  env id1
                                                 in
                                              FStar_Util.Inr uu____9032  in
                                            (uu____9027, [],
                                              FStar_Pervasives_Native.None)
                                             in
                                          (attr_opt, uu____9006, def)
                                        else
                                          (attr_opt,
                                            ((FStar_Util.Inl id1), [],
                                              FStar_Pervasives_Native.None),
                                            def)
                                    | uu____9122 ->
                                        FStar_Errors.raise_error
                                          (FStar_Errors.Fatal_UnexpectedLetBinding,
                                            "Unexpected let binding")
                                          p.FStar_Parser_AST.prange))))
                 in
              let uu____9153 =
                FStar_List.fold_left
                  (fun uu____9226  ->
                     fun uu____9227  ->
                       match (uu____9226, uu____9227) with
                       | ((env1,fnames,rec_bindings),(_attr_opt,(f,uu____9335,uu____9336),uu____9337))
                           ->
                           let uu____9454 =
                             match f with
                             | FStar_Util.Inl x ->
                                 let uu____9480 =
                                   FStar_Syntax_DsEnv.push_bv env1 x  in
                                 (match uu____9480 with
                                  | (env2,xx) ->
                                      let uu____9499 =
                                        let uu____9502 =
                                          FStar_Syntax_Syntax.mk_binder xx
                                           in
                                        uu____9502 :: rec_bindings  in
                                      (env2, (FStar_Util.Inl xx), uu____9499))
                             | FStar_Util.Inr l ->
                                 let uu____9510 =
                                   FStar_Syntax_DsEnv.push_top_level_rec_binding
                                     env1 l.FStar_Ident.ident
                                     FStar_Syntax_Syntax.delta_equational
                                    in
                                 (uu____9510, (FStar_Util.Inr l),
                                   rec_bindings)
                              in
                           (match uu____9454 with
                            | (env2,lbname,rec_bindings1) ->
                                (env2, (lbname :: fnames), rec_bindings1)))
                  (env, [], []) funs
                 in
              match uu____9153 with
              | (env',fnames,rec_bindings) ->
                  let fnames1 = FStar_List.rev fnames  in
                  let rec_bindings1 = FStar_List.rev rec_bindings  in
                  let desugar_one_def env1 lbname uu____9658 =
                    match uu____9658 with
                    | (attrs_opt,(uu____9694,args,result_t),def) ->
                        let args1 =
                          FStar_All.pipe_right args
                            (FStar_List.map replace_unit_pattern)
                           in
                        let pos = def.FStar_Parser_AST.range  in
                        let def1 =
                          match result_t with
                          | FStar_Pervasives_Native.None  -> def
                          | FStar_Pervasives_Native.Some (t,tacopt) ->
                              let t1 =
                                let uu____9782 = is_comp_type env1 t  in
                                if uu____9782
                                then
                                  ((let uu____9784 =
                                      FStar_All.pipe_right args1
                                        (FStar_List.tryFind
                                           (fun x  ->
                                              let uu____9794 =
                                                is_var_pattern x  in
                                              Prims.op_Negation uu____9794))
                                       in
                                    match uu____9784 with
                                    | FStar_Pervasives_Native.None  -> ()
                                    | FStar_Pervasives_Native.Some p ->
                                        FStar_Errors.raise_error
                                          (FStar_Errors.Fatal_ComputationTypeNotAllowed,
                                            "Computation type annotations are only permitted on let-bindings without inlined patterns; replace this pattern with a variable")
                                          p.FStar_Parser_AST.prange);
                                   t)
                                else
                                  (let uu____9797 =
                                     ((FStar_Options.ml_ish ()) &&
                                        (let uu____9799 =
                                           FStar_Syntax_DsEnv.try_lookup_effect_name
                                             env1
                                             FStar_Parser_Const.effect_ML_lid
                                            in
                                         FStar_Option.isSome uu____9799))
                                       &&
                                       ((Prims.op_Negation is_rec) ||
                                          ((FStar_List.length args1) <>
                                             (Prims.parse_int "0")))
                                      in
                                   if uu____9797
                                   then FStar_Parser_AST.ml_comp t
                                   else FStar_Parser_AST.tot_comp t)
                                 in
                              let uu____9803 =
                                FStar_Range.union_ranges
                                  t1.FStar_Parser_AST.range
                                  def.FStar_Parser_AST.range
                                 in
                              FStar_Parser_AST.mk_term
                                (FStar_Parser_AST.Ascribed (def, t1, tacopt))
                                uu____9803 FStar_Parser_AST.Expr
                           in
                        let def2 =
                          match args1 with
                          | [] -> def1
                          | uu____9807 ->
                              FStar_Parser_AST.mk_term
                                (FStar_Parser_AST.un_curry_abs args1 def1)
                                top.FStar_Parser_AST.range
                                top.FStar_Parser_AST.level
                           in
                        let body1 = desugar_term env1 def2  in
                        let lbname1 =
                          match lbname with
                          | FStar_Util.Inl x -> FStar_Util.Inl x
                          | FStar_Util.Inr l ->
                              let uu____9822 =
                                let uu____9823 =
                                  FStar_Syntax_Util.incr_delta_qualifier
                                    body1
                                   in
                                FStar_Syntax_Syntax.lid_as_fv l uu____9823
                                  FStar_Pervasives_Native.None
                                 in
                              FStar_Util.Inr uu____9822
                           in
                        let body2 =
                          if is_rec
                          then FStar_Syntax_Subst.close rec_bindings1 body1
                          else body1  in
                        let attrs =
                          match attrs_opt with
                          | FStar_Pervasives_Native.None  -> []
                          | FStar_Pervasives_Native.Some l ->
                              FStar_List.map (desugar_term env1) l
                           in
                        mk_lb
                          (attrs, lbname1, FStar_Syntax_Syntax.tun, body2,
                            pos)
                     in
                  let lbs1 =
                    FStar_List.map2
                      (desugar_one_def (if is_rec then env' else env))
                      fnames1 funs
                     in
                  let uu____9882 = desugar_term_aq env' body  in
                  (match uu____9882 with
                   | (body1,aq) ->
                       let uu____9895 =
                         let uu____9898 =
                           let uu____9899 =
                             let uu____9912 =
                               FStar_Syntax_Subst.close rec_bindings1 body1
                                in
                             ((is_rec, lbs1), uu____9912)  in
                           FStar_Syntax_Syntax.Tm_let uu____9899  in
                         FStar_All.pipe_left mk1 uu____9898  in
                       (uu____9895, aq))
               in
            let ds_non_rec attrs_opt pat t1 t2 =
              let attrs =
                match attrs_opt with
                | FStar_Pervasives_Native.None  -> []
                | FStar_Pervasives_Native.Some l ->
                    FStar_List.map (desugar_term env) l
                 in
              let t11 = desugar_term env t1  in
              let is_mutable = qual = FStar_Parser_AST.Mutable  in
              let t12 = if is_mutable then mk_ref_alloc t11 else t11  in
              let uu____9980 =
                desugar_binding_pat_maybe_top top_level env pat is_mutable
                 in
              match uu____9980 with
              | (env1,binder,pat1) ->
                  let uu____10002 =
                    match binder with
                    | LetBinder (l,(t,_tacopt)) ->
                        let uu____10028 = desugar_term_aq env1 t2  in
                        (match uu____10028 with
                         | (body1,aq) ->
                             let fv =
                               let uu____10042 =
                                 FStar_Syntax_Util.incr_delta_qualifier t12
                                  in
                               FStar_Syntax_Syntax.lid_as_fv l uu____10042
                                 FStar_Pervasives_Native.None
                                in
                             let uu____10043 =
                               FStar_All.pipe_left mk1
                                 (FStar_Syntax_Syntax.Tm_let
                                    ((false,
                                       [mk_lb
                                          (attrs, (FStar_Util.Inr fv), t,
                                            t12,
                                            (t12.FStar_Syntax_Syntax.pos))]),
                                      body1))
                                in
                             (uu____10043, aq))
                    | LocalBinder (x,uu____10067) ->
                        let uu____10068 = desugar_term_aq env1 t2  in
                        (match uu____10068 with
                         | (body1,aq) ->
                             let body2 =
                               match pat1 with
                               | [] -> body1
                               | {
                                   FStar_Syntax_Syntax.v =
                                     FStar_Syntax_Syntax.Pat_wild uu____10082;
                                   FStar_Syntax_Syntax.p = uu____10083;_}::[]
                                   -> body1
                               | uu____10088 ->
                                   let uu____10091 =
                                     let uu____10098 =
                                       let uu____10099 =
                                         let uu____10122 =
                                           FStar_Syntax_Syntax.bv_to_name x
                                            in
                                         let uu____10123 =
                                           desugar_disjunctive_pattern pat1
                                             FStar_Pervasives_Native.None
                                             body1
                                            in
                                         (uu____10122, uu____10123)  in
                                       FStar_Syntax_Syntax.Tm_match
                                         uu____10099
                                        in
                                     FStar_Syntax_Syntax.mk uu____10098  in
                                   uu____10091 FStar_Pervasives_Native.None
                                     top.FStar_Parser_AST.range
                                in
                             let uu____10133 =
                               let uu____10136 =
                                 let uu____10137 =
                                   let uu____10150 =
                                     let uu____10151 =
                                       let uu____10152 =
                                         FStar_Syntax_Syntax.mk_binder x  in
                                       [uu____10152]  in
                                     FStar_Syntax_Subst.close uu____10151
                                       body2
                                      in
                                   ((false,
                                      [mk_lb
                                         (attrs, (FStar_Util.Inl x),
                                           (x.FStar_Syntax_Syntax.sort), t12,
                                           (t12.FStar_Syntax_Syntax.pos))]),
                                     uu____10150)
                                    in
                                 FStar_Syntax_Syntax.Tm_let uu____10137  in
                               FStar_All.pipe_left mk1 uu____10136  in
                             (uu____10133, aq))
                     in
                  (match uu____10002 with
                   | (tm,aq) ->
                       if is_mutable
                       then
                         let uu____10193 =
                           FStar_All.pipe_left mk1
                             (FStar_Syntax_Syntax.Tm_meta
                                (tm,
                                  (FStar_Syntax_Syntax.Meta_desugared
                                     FStar_Syntax_Syntax.Mutable_alloc)))
                            in
                         (uu____10193, aq)
                       else (tm, aq))
               in
            let uu____10205 = FStar_List.hd lbs  in
            (match uu____10205 with
             | (attrs,(head_pat,defn)) ->
                 let uu____10249 = is_rec || (is_app_pattern head_pat)  in
                 if uu____10249
                 then ds_let_rec_or_app ()
                 else ds_non_rec attrs head_pat defn body)
        | FStar_Parser_AST.If (t1,t2,t3) ->
            let x =
              FStar_Syntax_Syntax.new_bv
                (FStar_Pervasives_Native.Some (t3.FStar_Parser_AST.range))
                FStar_Syntax_Syntax.tun
               in
            let t_bool1 =
              let uu____10262 =
                let uu____10263 =
                  FStar_Syntax_Syntax.lid_as_fv FStar_Parser_Const.bool_lid
                    FStar_Syntax_Syntax.delta_constant
                    FStar_Pervasives_Native.None
                   in
                FStar_Syntax_Syntax.Tm_fvar uu____10263  in
              mk1 uu____10262  in
            let uu____10264 = desugar_term_aq env t1  in
            (match uu____10264 with
             | (t1',aq1) ->
                 let uu____10275 = desugar_term_aq env t2  in
                 (match uu____10275 with
                  | (t2',aq2) ->
                      let uu____10286 = desugar_term_aq env t3  in
                      (match uu____10286 with
                       | (t3',aq3) ->
                           let uu____10297 =
                             let uu____10300 =
                               let uu____10301 =
                                 let uu____10324 =
                                   let uu____10339 =
                                     let uu____10352 =
                                       FStar_Syntax_Syntax.withinfo
                                         (FStar_Syntax_Syntax.Pat_constant
                                            (FStar_Const.Const_bool true))
                                         t2.FStar_Parser_AST.range
                                        in
                                     (uu____10352,
                                       FStar_Pervasives_Native.None, t2')
                                      in
                                   let uu____10363 =
                                     let uu____10378 =
                                       let uu____10391 =
                                         FStar_Syntax_Syntax.withinfo
                                           (FStar_Syntax_Syntax.Pat_wild x)
                                           t3.FStar_Parser_AST.range
                                          in
                                       (uu____10391,
                                         FStar_Pervasives_Native.None, t3')
                                        in
                                     [uu____10378]  in
                                   uu____10339 :: uu____10363  in
                                 (t1', uu____10324)  in
                               FStar_Syntax_Syntax.Tm_match uu____10301  in
                             mk1 uu____10300  in
                           (uu____10297, (join_aqs [aq1; aq2; aq3])))))
        | FStar_Parser_AST.TryWith (e,branches) ->
            let r = top.FStar_Parser_AST.range  in
            let handler = FStar_Parser_AST.mk_function branches r r  in
            let body =
              FStar_Parser_AST.mk_function
                [((FStar_Parser_AST.mk_pattern
                     (FStar_Parser_AST.PatConst FStar_Const.Const_unit) r),
                   FStar_Pervasives_Native.None, e)] r r
               in
            let a1 =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.App
                   ((FStar_Parser_AST.mk_term
                       (FStar_Parser_AST.Var FStar_Parser_Const.try_with_lid)
                       r top.FStar_Parser_AST.level), body,
                     FStar_Parser_AST.Nothing)) r top.FStar_Parser_AST.level
               in
            let a2 =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.App (a1, handler, FStar_Parser_AST.Nothing))
                r top.FStar_Parser_AST.level
               in
            desugar_term_aq env a2
        | FStar_Parser_AST.Match (e,branches) ->
            let desugar_branch uu____10550 =
              match uu____10550 with
              | (pat,wopt,b) ->
                  let uu____10572 = desugar_match_pat env pat  in
                  (match uu____10572 with
                   | (env1,pat1) ->
                       let wopt1 =
                         match wopt with
                         | FStar_Pervasives_Native.None  ->
                             FStar_Pervasives_Native.None
                         | FStar_Pervasives_Native.Some e1 ->
                             let uu____10597 = desugar_term env1 e1  in
                             FStar_Pervasives_Native.Some uu____10597
                          in
                       let uu____10598 = desugar_term_aq env1 b  in
                       (match uu____10598 with
                        | (b1,aq) ->
                            let uu____10611 =
                              desugar_disjunctive_pattern pat1 wopt1 b1  in
                            (uu____10611, aq)))
               in
            let uu____10616 = desugar_term_aq env e  in
            (match uu____10616 with
             | (e1,aq) ->
                 let uu____10627 =
                   let uu____10636 =
                     let uu____10647 = FStar_List.map desugar_branch branches
                        in
                     FStar_All.pipe_right uu____10647 FStar_List.unzip  in
                   FStar_All.pipe_right uu____10636
                     (fun uu____10711  ->
                        match uu____10711 with
                        | (x,y) -> ((FStar_List.flatten x), y))
                    in
                 (match uu____10627 with
                  | (brs,aqs) ->
                      let uu____10762 =
                        FStar_All.pipe_left mk1
                          (FStar_Syntax_Syntax.Tm_match (e1, brs))
                         in
                      (uu____10762, (join_aqs (aq :: aqs)))))
        | FStar_Parser_AST.Ascribed (e,t,tac_opt) ->
            let annot =
              let uu____10795 = is_comp_type env t  in
              if uu____10795
              then
                let uu____10802 = desugar_comp t.FStar_Parser_AST.range env t
                   in
                FStar_Util.Inr uu____10802
              else
                (let uu____10808 = desugar_term env t  in
                 FStar_Util.Inl uu____10808)
               in
            let tac_opt1 = FStar_Util.map_opt tac_opt (desugar_term env)  in
            let uu____10814 = desugar_term_aq env e  in
            (match uu____10814 with
             | (e1,aq) ->
                 let uu____10825 =
                   FStar_All.pipe_left mk1
                     (FStar_Syntax_Syntax.Tm_ascribed
                        (e1, (annot, tac_opt1), FStar_Pervasives_Native.None))
                    in
                 (uu____10825, aq))
        | FStar_Parser_AST.Record (uu____10854,[]) ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_UnexpectedEmptyRecord,
                "Unexpected empty record") top.FStar_Parser_AST.range
        | FStar_Parser_AST.Record (eopt,fields) ->
            let record = check_fields env fields top.FStar_Parser_AST.range
               in
            let user_ns =
              let uu____10895 = FStar_List.hd fields  in
              match uu____10895 with | (f,uu____10907) -> f.FStar_Ident.ns
               in
            let get_field xopt f =
              let found =
                FStar_All.pipe_right fields
                  (FStar_Util.find_opt
                     (fun uu____10953  ->
                        match uu____10953 with
                        | (g,uu____10959) ->
                            f.FStar_Ident.idText =
                              (g.FStar_Ident.ident).FStar_Ident.idText))
                 in
              let fn = FStar_Ident.lid_of_ids (FStar_List.append user_ns [f])
                 in
              match found with
              | FStar_Pervasives_Native.Some (uu____10965,e) -> (fn, e)
              | FStar_Pervasives_Native.None  ->
                  (match xopt with
                   | FStar_Pervasives_Native.None  ->
                       let uu____10979 =
                         let uu____10984 =
                           FStar_Util.format2
                             "Field %s of record type %s is missing"
                             f.FStar_Ident.idText
                             (record.FStar_Syntax_DsEnv.typename).FStar_Ident.str
                            in
                         (FStar_Errors.Fatal_MissingFieldInRecord,
                           uu____10984)
                          in
                       FStar_Errors.raise_error uu____10979
                         top.FStar_Parser_AST.range
                   | FStar_Pervasives_Native.Some x ->
                       (fn,
                         (FStar_Parser_AST.mk_term
                            (FStar_Parser_AST.Project (x, fn))
                            x.FStar_Parser_AST.range x.FStar_Parser_AST.level)))
               in
            let user_constrname =
              FStar_Ident.lid_of_ids
                (FStar_List.append user_ns
                   [record.FStar_Syntax_DsEnv.constrname])
               in
            let recterm =
              match eopt with
              | FStar_Pervasives_Native.None  ->
                  let uu____10992 =
                    let uu____11003 =
                      FStar_All.pipe_right record.FStar_Syntax_DsEnv.fields
                        (FStar_List.map
                           (fun uu____11034  ->
                              match uu____11034 with
                              | (f,uu____11044) ->
                                  let uu____11045 =
                                    let uu____11046 =
                                      get_field FStar_Pervasives_Native.None
                                        f
                                       in
                                    FStar_All.pipe_left
                                      FStar_Pervasives_Native.snd uu____11046
                                     in
                                  (uu____11045, FStar_Parser_AST.Nothing)))
                       in
                    (user_constrname, uu____11003)  in
                  FStar_Parser_AST.Construct uu____10992
              | FStar_Pervasives_Native.Some e ->
                  let x = FStar_Ident.gen e.FStar_Parser_AST.range  in
                  let xterm =
                    let uu____11064 =
                      let uu____11065 = FStar_Ident.lid_of_ids [x]  in
                      FStar_Parser_AST.Var uu____11065  in
                    FStar_Parser_AST.mk_term uu____11064
                      x.FStar_Ident.idRange FStar_Parser_AST.Expr
                     in
                  let record1 =
                    let uu____11067 =
                      let uu____11080 =
                        FStar_All.pipe_right record.FStar_Syntax_DsEnv.fields
                          (FStar_List.map
                             (fun uu____11110  ->
                                match uu____11110 with
                                | (f,uu____11120) ->
                                    get_field
                                      (FStar_Pervasives_Native.Some xterm) f))
                         in
                      (FStar_Pervasives_Native.None, uu____11080)  in
                    FStar_Parser_AST.Record uu____11067  in
                  FStar_Parser_AST.Let
                    (FStar_Parser_AST.NoLetQualifier,
                      [(FStar_Pervasives_Native.None,
                         ((FStar_Parser_AST.mk_pattern
                             (FStar_Parser_AST.PatVar
                                (x, FStar_Pervasives_Native.None))
                             x.FStar_Ident.idRange), e))],
                      (FStar_Parser_AST.mk_term record1
                         top.FStar_Parser_AST.range
                         top.FStar_Parser_AST.level))
               in
            let recterm1 =
              FStar_Parser_AST.mk_term recterm top.FStar_Parser_AST.range
                top.FStar_Parser_AST.level
               in
            let uu____11180 = desugar_term_aq env recterm1  in
            (match uu____11180 with
             | (e,s) ->
                 (match e.FStar_Syntax_Syntax.n with
                  | FStar_Syntax_Syntax.Tm_app
                      ({
                         FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar
                           fv;
                         FStar_Syntax_Syntax.pos = uu____11196;
                         FStar_Syntax_Syntax.vars = uu____11197;_},args)
                      ->
                      let uu____11219 =
                        let uu____11222 =
                          let uu____11223 =
                            let uu____11238 =
                              let uu____11239 =
                                FStar_Ident.set_lid_range
                                  (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                  e.FStar_Syntax_Syntax.pos
                                 in
                              let uu____11240 =
                                let uu____11243 =
                                  let uu____11244 =
                                    let uu____11251 =
                                      FStar_All.pipe_right
                                        record.FStar_Syntax_DsEnv.fields
                                        (FStar_List.map
                                           FStar_Pervasives_Native.fst)
                                       in
                                    ((record.FStar_Syntax_DsEnv.typename),
                                      uu____11251)
                                     in
                                  FStar_Syntax_Syntax.Record_ctor uu____11244
                                   in
                                FStar_Pervasives_Native.Some uu____11243  in
                              FStar_Syntax_Syntax.fvar uu____11239
                                FStar_Syntax_Syntax.delta_constant
                                uu____11240
                               in
                            (uu____11238, args)  in
                          FStar_Syntax_Syntax.Tm_app uu____11223  in
                        FStar_All.pipe_left mk1 uu____11222  in
                      (uu____11219, s)
                  | uu____11280 -> (e, s)))
        | FStar_Parser_AST.Project (e,f) ->
            (FStar_Syntax_DsEnv.fail_if_qualified_by_curmodule env f;
             (let uu____11284 =
                FStar_Syntax_DsEnv.fail_or env
                  (FStar_Syntax_DsEnv.try_lookup_dc_by_field_name env) f
                 in
              match uu____11284 with
              | (constrname,is_rec) ->
                  let uu____11299 = desugar_term_aq env e  in
                  (match uu____11299 with
                   | (e1,s) ->
                       let projname =
                         FStar_Syntax_Util.mk_field_projector_name_from_ident
                           constrname f.FStar_Ident.ident
                          in
                       let qual =
                         if is_rec
                         then
                           FStar_Pervasives_Native.Some
                             (FStar_Syntax_Syntax.Record_projector
                                (constrname, (f.FStar_Ident.ident)))
                         else FStar_Pervasives_Native.None  in
                       let uu____11317 =
                         let uu____11320 =
                           let uu____11321 =
                             let uu____11336 =
                               let uu____11337 =
                                 let uu____11338 = FStar_Ident.range_of_lid f
                                    in
                                 FStar_Ident.set_lid_range projname
                                   uu____11338
                                  in
                               FStar_Syntax_Syntax.fvar uu____11337
                                 (FStar_Syntax_Syntax.Delta_equational_at_level
                                    (Prims.parse_int "1")) qual
                                in
                             let uu____11339 =
                               let uu____11342 =
                                 FStar_Syntax_Syntax.as_arg e1  in
                               [uu____11342]  in
                             (uu____11336, uu____11339)  in
                           FStar_Syntax_Syntax.Tm_app uu____11321  in
                         FStar_All.pipe_left mk1 uu____11320  in
                       (uu____11317, s))))
        | FStar_Parser_AST.NamedTyp (uu____11349,e) -> desugar_term_aq env e
        | FStar_Parser_AST.Paren e -> failwith "impossible"
        | FStar_Parser_AST.VQuote e ->
            let tm = desugar_term env e  in
            let uu____11358 =
              let uu____11359 = FStar_Syntax_Subst.compress tm  in
              uu____11359.FStar_Syntax_Syntax.n  in
            (match uu____11358 with
             | FStar_Syntax_Syntax.Tm_fvar fv ->
                 let uu____11367 =
                   let uu___156_11370 =
                     let uu____11371 =
                       let uu____11372 = FStar_Syntax_Syntax.lid_of_fv fv  in
                       FStar_Ident.string_of_lid uu____11372  in
                     FStar_Syntax_Util.exp_string uu____11371  in
                   {
                     FStar_Syntax_Syntax.n =
                       (uu___156_11370.FStar_Syntax_Syntax.n);
                     FStar_Syntax_Syntax.pos = (e.FStar_Parser_AST.range);
                     FStar_Syntax_Syntax.vars =
                       (uu___156_11370.FStar_Syntax_Syntax.vars)
                   }  in
                 (uu____11367, noaqs)
             | uu____11385 ->
                 let uu____11386 =
                   let uu____11391 =
                     let uu____11392 = FStar_Syntax_Print.term_to_string tm
                        in
                     Prims.strcat "VQuote, expected an fvar, got: "
                       uu____11392
                      in
                   (FStar_Errors.Fatal_UnexpectedTermVQuote, uu____11391)  in
                 FStar_Errors.raise_error uu____11386
                   top.FStar_Parser_AST.range)
        | FStar_Parser_AST.Quote (e,FStar_Parser_AST.Static ) ->
            let uu____11398 = desugar_term_aq env e  in
            (match uu____11398 with
             | (tm,vts) ->
                 let qi =
                   {
                     FStar_Syntax_Syntax.qkind =
                       FStar_Syntax_Syntax.Quote_static;
                     FStar_Syntax_Syntax.antiquotes = vts
                   }  in
                 let uu____11410 =
                   FStar_All.pipe_left mk1
                     (FStar_Syntax_Syntax.Tm_quoted (tm, qi))
                    in
                 (uu____11410, noaqs))
        | FStar_Parser_AST.Antiquote (b,e) ->
            let bv =
              FStar_Syntax_Syntax.new_bv
                (FStar_Pervasives_Native.Some (e.FStar_Parser_AST.range))
                FStar_Syntax_Syntax.tun
               in
            let uu____11430 = FStar_Syntax_Syntax.bv_to_name bv  in
            let uu____11431 =
              let uu____11440 =
                let uu____11447 = desugar_term env e  in (bv, b, uu____11447)
                 in
              [uu____11440]  in
            (uu____11430, uu____11431)
        | FStar_Parser_AST.Quote (e,FStar_Parser_AST.Dynamic ) ->
            let qi =
              {
                FStar_Syntax_Syntax.qkind = FStar_Syntax_Syntax.Quote_dynamic;
                FStar_Syntax_Syntax.antiquotes = []
              }  in
            let uu____11478 =
              let uu____11481 =
                let uu____11482 =
                  let uu____11489 = desugar_term env e  in (uu____11489, qi)
                   in
                FStar_Syntax_Syntax.Tm_quoted uu____11482  in
              FStar_All.pipe_left mk1 uu____11481  in
            (uu____11478, noaqs)
        | uu____11504 when
            top.FStar_Parser_AST.level = FStar_Parser_AST.Formula ->
            let uu____11505 = desugar_formula env top  in
            (uu____11505, noaqs)
        | uu____11516 ->
            let uu____11517 =
              let uu____11522 =
                let uu____11523 = FStar_Parser_AST.term_to_string top  in
                Prims.strcat "Unexpected term: " uu____11523  in
              (FStar_Errors.Fatal_UnexpectedTerm, uu____11522)  in
            FStar_Errors.raise_error uu____11517 top.FStar_Parser_AST.range

and (not_ascribed : FStar_Parser_AST.term -> Prims.bool) =
  fun t  ->
    match t.FStar_Parser_AST.tm with
    | FStar_Parser_AST.Ascribed uu____11529 -> false
    | uu____11538 -> true

and (desugar_args :
  FStar_Syntax_DsEnv.env ->
    (FStar_Parser_AST.term,FStar_Parser_AST.imp)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.arg_qualifier
                                  FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2 Prims.list)
  =
  fun env  ->
    fun args  ->
      FStar_All.pipe_right args
        (FStar_List.map
           (fun uu____11575  ->
              match uu____11575 with
              | (a,imp) ->
                  let uu____11588 = desugar_term env a  in
                  arg_withimp_e imp uu____11588))

and (desugar_comp :
  FStar_Range.range ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.term ->
        FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax)
  =
  fun r  ->
    fun env  ->
      fun t  ->
        let fail1 err = FStar_Errors.raise_error err r  in
        let is_requires uu____11620 =
          match uu____11620 with
          | (t1,uu____11626) ->
              let uu____11627 =
                let uu____11628 = unparen t1  in
                uu____11628.FStar_Parser_AST.tm  in
              (match uu____11627 with
               | FStar_Parser_AST.Requires uu____11629 -> true
               | uu____11636 -> false)
           in
        let is_ensures uu____11646 =
          match uu____11646 with
          | (t1,uu____11652) ->
              let uu____11653 =
                let uu____11654 = unparen t1  in
                uu____11654.FStar_Parser_AST.tm  in
              (match uu____11653 with
               | FStar_Parser_AST.Ensures uu____11655 -> true
               | uu____11662 -> false)
           in
        let is_app head1 uu____11677 =
          match uu____11677 with
          | (t1,uu____11683) ->
              let uu____11684 =
                let uu____11685 = unparen t1  in
                uu____11685.FStar_Parser_AST.tm  in
              (match uu____11684 with
               | FStar_Parser_AST.App
                   ({ FStar_Parser_AST.tm = FStar_Parser_AST.Var d;
                      FStar_Parser_AST.range = uu____11687;
                      FStar_Parser_AST.level = uu____11688;_},uu____11689,uu____11690)
                   -> (d.FStar_Ident.ident).FStar_Ident.idText = head1
               | uu____11691 -> false)
           in
        let is_smt_pat uu____11701 =
          match uu____11701 with
          | (t1,uu____11707) ->
              let uu____11708 =
                let uu____11709 = unparen t1  in
                uu____11709.FStar_Parser_AST.tm  in
              (match uu____11708 with
               | FStar_Parser_AST.Construct
                   (cons1,({
                             FStar_Parser_AST.tm = FStar_Parser_AST.Construct
                               (smtpat,uu____11712);
                             FStar_Parser_AST.range = uu____11713;
                             FStar_Parser_AST.level = uu____11714;_},uu____11715)::uu____11716::[])
                   ->
                   (FStar_Ident.lid_equals cons1 FStar_Parser_Const.cons_lid)
                     &&
                     (FStar_Util.for_some
                        (fun s  -> smtpat.FStar_Ident.str = s)
                        ["SMTPat"; "SMTPatT"; "SMTPatOr"])
               | FStar_Parser_AST.Construct
                   (cons1,({
                             FStar_Parser_AST.tm = FStar_Parser_AST.Var
                               smtpat;
                             FStar_Parser_AST.range = uu____11755;
                             FStar_Parser_AST.level = uu____11756;_},uu____11757)::uu____11758::[])
                   ->
                   (FStar_Ident.lid_equals cons1 FStar_Parser_Const.cons_lid)
                     &&
                     (FStar_Util.for_some
                        (fun s  -> smtpat.FStar_Ident.str = s)
                        ["smt_pat"; "smt_pat_or"])
               | uu____11783 -> false)
           in
        let is_decreases = is_app "decreases"  in
        let pre_process_comp_typ t1 =
          let uu____11815 = head_and_args t1  in
          match uu____11815 with
          | (head1,args) ->
              (match head1.FStar_Parser_AST.tm with
               | FStar_Parser_AST.Name lemma when
                   (lemma.FStar_Ident.ident).FStar_Ident.idText = "Lemma" ->
                   let unit_tm =
                     ((FStar_Parser_AST.mk_term
                         (FStar_Parser_AST.Name FStar_Parser_Const.unit_lid)
                         t1.FStar_Parser_AST.range
                         FStar_Parser_AST.Type_level),
                       FStar_Parser_AST.Nothing)
                      in
                   let nil_pat =
                     ((FStar_Parser_AST.mk_term
                         (FStar_Parser_AST.Name FStar_Parser_Const.nil_lid)
                         t1.FStar_Parser_AST.range FStar_Parser_AST.Expr),
                       FStar_Parser_AST.Nothing)
                      in
                   let req_true =
                     let req =
                       FStar_Parser_AST.Requires
                         ((FStar_Parser_AST.mk_term
                             (FStar_Parser_AST.Name
                                FStar_Parser_Const.true_lid)
                             t1.FStar_Parser_AST.range
                             FStar_Parser_AST.Formula),
                           FStar_Pervasives_Native.None)
                        in
                     ((FStar_Parser_AST.mk_term req t1.FStar_Parser_AST.range
                         FStar_Parser_AST.Type_level),
                       FStar_Parser_AST.Nothing)
                      in
                   let thunk_ens_ ens =
                     let wildpat =
                       FStar_Parser_AST.mk_pattern FStar_Parser_AST.PatWild
                         ens.FStar_Parser_AST.range
                        in
                     FStar_Parser_AST.mk_term
                       (FStar_Parser_AST.Abs ([wildpat], ens))
                       ens.FStar_Parser_AST.range FStar_Parser_AST.Expr
                      in
                   let thunk_ens uu____11913 =
                     match uu____11913 with
                     | (e,i) ->
                         let uu____11924 = thunk_ens_ e  in (uu____11924, i)
                      in
                   let fail_lemma uu____11936 =
                     let expected_one_of =
                       ["Lemma post";
                       "Lemma (ensures post)";
                       "Lemma (requires pre) (ensures post)";
                       "Lemma post [SMTPat ...]";
                       "Lemma (ensures post) [SMTPat ...]";
                       "Lemma (ensures post) (decreases d)";
                       "Lemma (ensures post) (decreases d) [SMTPat ...]";
                       "Lemma (requires pre) (ensures post) (decreases d)";
                       "Lemma (requires pre) (ensures post) [SMTPat ...]";
                       "Lemma (requires pre) (ensures post) (decreases d) [SMTPat ...]"]
                        in
                     let msg = FStar_String.concat "\n\t" expected_one_of  in
                     FStar_Errors.raise_error
                       (FStar_Errors.Fatal_InvalidLemmaArgument,
                         (Prims.strcat
                            "Invalid arguments to 'Lemma'; expected one of the following:\n\t"
                            msg)) t1.FStar_Parser_AST.range
                      in
                   let args1 =
                     match args with
                     | [] -> fail_lemma ()
                     | req::[] when is_requires req -> fail_lemma ()
                     | smtpat::[] when is_smt_pat smtpat -> fail_lemma ()
                     | dec::[] when is_decreases dec -> fail_lemma ()
                     | ens::[] ->
                         let uu____12016 =
                           let uu____12023 =
                             let uu____12030 = thunk_ens ens  in
                             [uu____12030; nil_pat]  in
                           req_true :: uu____12023  in
                         unit_tm :: uu____12016
                     | req::ens::[] when
                         (is_requires req) && (is_ensures ens) ->
                         let uu____12077 =
                           let uu____12084 =
                             let uu____12091 = thunk_ens ens  in
                             [uu____12091; nil_pat]  in
                           req :: uu____12084  in
                         unit_tm :: uu____12077
                     | ens::smtpat::[] when
                         (((let uu____12140 = is_requires ens  in
                            Prims.op_Negation uu____12140) &&
                             (let uu____12142 = is_smt_pat ens  in
                              Prims.op_Negation uu____12142))
                            &&
                            (let uu____12144 = is_decreases ens  in
                             Prims.op_Negation uu____12144))
                           && (is_smt_pat smtpat)
                         ->
                         let uu____12145 =
                           let uu____12152 =
                             let uu____12159 = thunk_ens ens  in
                             [uu____12159; smtpat]  in
                           req_true :: uu____12152  in
                         unit_tm :: uu____12145
                     | ens::dec::[] when
                         (is_ensures ens) && (is_decreases dec) ->
                         let uu____12206 =
                           let uu____12213 =
                             let uu____12220 = thunk_ens ens  in
                             [uu____12220; nil_pat; dec]  in
                           req_true :: uu____12213  in
                         unit_tm :: uu____12206
                     | ens::dec::smtpat::[] when
                         ((is_ensures ens) && (is_decreases dec)) &&
                           (is_smt_pat smtpat)
                         ->
                         let uu____12280 =
                           let uu____12287 =
                             let uu____12294 = thunk_ens ens  in
                             [uu____12294; smtpat; dec]  in
                           req_true :: uu____12287  in
                         unit_tm :: uu____12280
                     | req::ens::dec::[] when
                         ((is_requires req) && (is_ensures ens)) &&
                           (is_decreases dec)
                         ->
                         let uu____12354 =
                           let uu____12361 =
                             let uu____12368 = thunk_ens ens  in
                             [uu____12368; nil_pat; dec]  in
                           req :: uu____12361  in
                         unit_tm :: uu____12354
                     | req::ens::smtpat::[] when
                         ((is_requires req) && (is_ensures ens)) &&
                           (is_smt_pat smtpat)
                         ->
                         let uu____12428 =
                           let uu____12435 =
                             let uu____12442 = thunk_ens ens  in
                             [uu____12442; smtpat]  in
                           req :: uu____12435  in
                         unit_tm :: uu____12428
                     | req::ens::dec::smtpat::[] when
                         (((is_requires req) && (is_ensures ens)) &&
                            (is_smt_pat smtpat))
                           && (is_decreases dec)
                         ->
                         let uu____12507 =
                           let uu____12514 =
                             let uu____12521 = thunk_ens ens  in
                             [uu____12521; dec; smtpat]  in
                           req :: uu____12514  in
                         unit_tm :: uu____12507
                     | _other -> fail_lemma ()  in
                   let head_and_attributes =
                     FStar_Syntax_DsEnv.fail_or env
                       (FStar_Syntax_DsEnv.try_lookup_effect_name_and_attributes
                          env) lemma
                      in
                   (head_and_attributes, args1)
               | FStar_Parser_AST.Name l when
                   FStar_Syntax_DsEnv.is_effect_name env l ->
                   let uu____12583 =
                     FStar_Syntax_DsEnv.fail_or env
                       (FStar_Syntax_DsEnv.try_lookup_effect_name_and_attributes
                          env) l
                      in
                   (uu____12583, args)
               | FStar_Parser_AST.Name l when
                   (let uu____12611 = FStar_Syntax_DsEnv.current_module env
                       in
                    FStar_Ident.lid_equals uu____12611
                      FStar_Parser_Const.prims_lid)
                     && ((l.FStar_Ident.ident).FStar_Ident.idText = "Tot")
                   ->
                   let uu____12612 =
                     let uu____12619 =
                       FStar_Ident.set_lid_range
                         FStar_Parser_Const.effect_Tot_lid
                         head1.FStar_Parser_AST.range
                        in
                     (uu____12619, [])  in
                   (uu____12612, args)
               | FStar_Parser_AST.Name l when
                   (let uu____12637 = FStar_Syntax_DsEnv.current_module env
                       in
                    FStar_Ident.lid_equals uu____12637
                      FStar_Parser_Const.prims_lid)
                     && ((l.FStar_Ident.ident).FStar_Ident.idText = "GTot")
                   ->
                   let uu____12638 =
                     let uu____12645 =
                       FStar_Ident.set_lid_range
                         FStar_Parser_Const.effect_GTot_lid
                         head1.FStar_Parser_AST.range
                        in
                     (uu____12645, [])  in
                   (uu____12638, args)
               | FStar_Parser_AST.Name l when
                   (((l.FStar_Ident.ident).FStar_Ident.idText = "Type") ||
                      ((l.FStar_Ident.ident).FStar_Ident.idText = "Type0"))
                     || ((l.FStar_Ident.ident).FStar_Ident.idText = "Effect")
                   ->
                   let uu____12661 =
                     let uu____12668 =
                       FStar_Ident.set_lid_range
                         FStar_Parser_Const.effect_Tot_lid
                         head1.FStar_Parser_AST.range
                        in
                     (uu____12668, [])  in
                   (uu____12661, [(t1, FStar_Parser_AST.Nothing)])
               | uu____12691 ->
                   let default_effect =
                     let uu____12693 = FStar_Options.ml_ish ()  in
                     if uu____12693
                     then FStar_Parser_Const.effect_ML_lid
                     else
                       ((let uu____12696 =
                           FStar_Options.warn_default_effects ()  in
                         if uu____12696
                         then
                           FStar_Errors.log_issue
                             head1.FStar_Parser_AST.range
                             (FStar_Errors.Warning_UseDefaultEffect,
                               "Using default effect Tot")
                         else ());
                        FStar_Parser_Const.effect_Tot_lid)
                      in
                   let uu____12698 =
                     let uu____12705 =
                       FStar_Ident.set_lid_range default_effect
                         head1.FStar_Parser_AST.range
                        in
                     (uu____12705, [])  in
                   (uu____12698, [(t1, FStar_Parser_AST.Nothing)]))
           in
        let uu____12728 = pre_process_comp_typ t  in
        match uu____12728 with
        | ((eff,cattributes),args) ->
            (if (FStar_List.length args) = (Prims.parse_int "0")
             then
               (let uu____12777 =
                  let uu____12782 =
                    let uu____12783 = FStar_Syntax_Print.lid_to_string eff
                       in
                    FStar_Util.format1 "Not enough args to effect %s"
                      uu____12783
                     in
                  (FStar_Errors.Fatal_NotEnoughArgsToEffect, uu____12782)  in
                fail1 uu____12777)
             else ();
             (let is_universe uu____12794 =
                match uu____12794 with
                | (uu____12799,imp) -> imp = FStar_Parser_AST.UnivApp  in
              let uu____12801 = FStar_Util.take is_universe args  in
              match uu____12801 with
              | (universes,args1) ->
                  let universes1 =
                    FStar_List.map
                      (fun uu____12860  ->
                         match uu____12860 with
                         | (u,imp) -> desugar_universe u) universes
                     in
                  let uu____12867 =
                    let uu____12882 = FStar_List.hd args1  in
                    let uu____12891 = FStar_List.tl args1  in
                    (uu____12882, uu____12891)  in
                  (match uu____12867 with
                   | (result_arg,rest) ->
                       let result_typ =
                         desugar_typ env
                           (FStar_Pervasives_Native.fst result_arg)
                          in
                       let rest1 = desugar_args env rest  in
                       let uu____12946 =
                         let is_decrease uu____12984 =
                           match uu____12984 with
                           | (t1,uu____12994) ->
                               (match t1.FStar_Syntax_Syntax.n with
                                | FStar_Syntax_Syntax.Tm_app
                                    ({
                                       FStar_Syntax_Syntax.n =
                                         FStar_Syntax_Syntax.Tm_fvar fv;
                                       FStar_Syntax_Syntax.pos = uu____13004;
                                       FStar_Syntax_Syntax.vars = uu____13005;_},uu____13006::[])
                                    ->
                                    FStar_Syntax_Syntax.fv_eq_lid fv
                                      FStar_Parser_Const.decreases_lid
                                | uu____13037 -> false)
                            in
                         FStar_All.pipe_right rest1
                           (FStar_List.partition is_decrease)
                          in
                       (match uu____12946 with
                        | (dec,rest2) ->
                            let decreases_clause =
                              FStar_All.pipe_right dec
                                (FStar_List.map
                                   (fun uu____13151  ->
                                      match uu____13151 with
                                      | (t1,uu____13161) ->
                                          (match t1.FStar_Syntax_Syntax.n
                                           with
                                           | FStar_Syntax_Syntax.Tm_app
                                               (uu____13170,(arg,uu____13172)::[])
                                               ->
                                               FStar_Syntax_Syntax.DECREASES
                                                 arg
                                           | uu____13201 -> failwith "impos")))
                               in
                            let no_additional_args =
                              let is_empty l =
                                match l with
                                | [] -> true
                                | uu____13218 -> false  in
                              (((is_empty decreases_clause) &&
                                  (is_empty rest2))
                                 && (is_empty cattributes))
                                && (is_empty universes1)
                               in
                            let uu____13229 =
                              no_additional_args &&
                                (FStar_Ident.lid_equals eff
                                   FStar_Parser_Const.effect_Tot_lid)
                               in
                            if uu____13229
                            then FStar_Syntax_Syntax.mk_Total result_typ
                            else
                              (let uu____13233 =
                                 no_additional_args &&
                                   (FStar_Ident.lid_equals eff
                                      FStar_Parser_Const.effect_GTot_lid)
                                  in
                               if uu____13233
                               then FStar_Syntax_Syntax.mk_GTotal result_typ
                               else
                                 (let flags1 =
                                    let uu____13240 =
                                      FStar_Ident.lid_equals eff
                                        FStar_Parser_Const.effect_Lemma_lid
                                       in
                                    if uu____13240
                                    then [FStar_Syntax_Syntax.LEMMA]
                                    else
                                      (let uu____13244 =
                                         FStar_Ident.lid_equals eff
                                           FStar_Parser_Const.effect_Tot_lid
                                          in
                                       if uu____13244
                                       then [FStar_Syntax_Syntax.TOTAL]
                                       else
                                         (let uu____13248 =
                                            FStar_Ident.lid_equals eff
                                              FStar_Parser_Const.effect_ML_lid
                                             in
                                          if uu____13248
                                          then [FStar_Syntax_Syntax.MLEFFECT]
                                          else
                                            (let uu____13252 =
                                               FStar_Ident.lid_equals eff
                                                 FStar_Parser_Const.effect_GTot_lid
                                                in
                                             if uu____13252
                                             then
                                               [FStar_Syntax_Syntax.SOMETRIVIAL]
                                             else [])))
                                     in
                                  let flags2 =
                                    FStar_List.append flags1 cattributes  in
                                  let rest3 =
                                    let uu____13270 =
                                      FStar_Ident.lid_equals eff
                                        FStar_Parser_Const.effect_Lemma_lid
                                       in
                                    if uu____13270
                                    then
                                      match rest2 with
                                      | req::ens::(pat,aq)::[] ->
                                          let pat1 =
                                            match pat.FStar_Syntax_Syntax.n
                                            with
                                            | FStar_Syntax_Syntax.Tm_fvar fv
                                                when
                                                FStar_Syntax_Syntax.fv_eq_lid
                                                  fv
                                                  FStar_Parser_Const.nil_lid
                                                ->
                                                let nil =
                                                  FStar_Syntax_Syntax.mk_Tm_uinst
                                                    pat
                                                    [FStar_Syntax_Syntax.U_zero]
                                                   in
                                                let pattern =
                                                  let uu____13359 =
                                                    FStar_Ident.set_lid_range
                                                      FStar_Parser_Const.pattern_lid
                                                      pat.FStar_Syntax_Syntax.pos
                                                     in
                                                  FStar_Syntax_Syntax.fvar
                                                    uu____13359
                                                    FStar_Syntax_Syntax.delta_constant
                                                    FStar_Pervasives_Native.None
                                                   in
                                                FStar_Syntax_Syntax.mk_Tm_app
                                                  nil
                                                  [(pattern,
                                                     (FStar_Pervasives_Native.Some
                                                        FStar_Syntax_Syntax.imp_tag))]
                                                  FStar_Pervasives_Native.None
                                                  pat.FStar_Syntax_Syntax.pos
                                            | uu____13374 -> pat  in
                                          let uu____13375 =
                                            let uu____13386 =
                                              let uu____13397 =
                                                let uu____13406 =
                                                  FStar_Syntax_Syntax.mk
                                                    (FStar_Syntax_Syntax.Tm_meta
                                                       (pat1,
                                                         (FStar_Syntax_Syntax.Meta_desugared
                                                            FStar_Syntax_Syntax.Meta_smt_pat)))
                                                    FStar_Pervasives_Native.None
                                                    pat1.FStar_Syntax_Syntax.pos
                                                   in
                                                (uu____13406, aq)  in
                                              [uu____13397]  in
                                            ens :: uu____13386  in
                                          req :: uu____13375
                                      | uu____13447 -> rest2
                                    else rest2  in
                                  FStar_Syntax_Syntax.mk_Comp
                                    {
                                      FStar_Syntax_Syntax.comp_univs =
                                        universes1;
                                      FStar_Syntax_Syntax.effect_name = eff;
                                      FStar_Syntax_Syntax.result_typ =
                                        result_typ;
                                      FStar_Syntax_Syntax.effect_args = rest3;
                                      FStar_Syntax_Syntax.flags =
                                        (FStar_List.append flags2
                                           decreases_clause)
                                    }))))))

and (desugar_formula :
  env_t -> FStar_Parser_AST.term -> FStar_Syntax_Syntax.term) =
  fun env  ->
    fun f  ->
      let connective s =
        match s with
        | "/\\" -> FStar_Pervasives_Native.Some FStar_Parser_Const.and_lid
        | "\\/" -> FStar_Pervasives_Native.Some FStar_Parser_Const.or_lid
        | "==>" -> FStar_Pervasives_Native.Some FStar_Parser_Const.imp_lid
        | "<==>" -> FStar_Pervasives_Native.Some FStar_Parser_Const.iff_lid
        | "~" -> FStar_Pervasives_Native.Some FStar_Parser_Const.not_lid
        | uu____13471 -> FStar_Pervasives_Native.None  in
      let mk1 t =
        FStar_Syntax_Syntax.mk t FStar_Pervasives_Native.None
          f.FStar_Parser_AST.range
         in
      let setpos t =
        let uu___157_13492 = t  in
        {
          FStar_Syntax_Syntax.n = (uu___157_13492.FStar_Syntax_Syntax.n);
          FStar_Syntax_Syntax.pos = (f.FStar_Parser_AST.range);
          FStar_Syntax_Syntax.vars =
            (uu___157_13492.FStar_Syntax_Syntax.vars)
        }  in
      let desugar_quant q b pats body =
        let tk =
          desugar_binder env
            (let uu___158_13534 = b  in
             {
               FStar_Parser_AST.b = (uu___158_13534.FStar_Parser_AST.b);
               FStar_Parser_AST.brange =
                 (uu___158_13534.FStar_Parser_AST.brange);
               FStar_Parser_AST.blevel = FStar_Parser_AST.Formula;
               FStar_Parser_AST.aqual =
                 (uu___158_13534.FStar_Parser_AST.aqual)
             })
           in
        let desugar_pats env1 pats1 =
          FStar_List.map
            (fun es  ->
               FStar_All.pipe_right es
                 (FStar_List.map
                    (fun e  ->
                       let uu____13597 = desugar_term env1 e  in
                       FStar_All.pipe_left
                         (arg_withimp_t FStar_Parser_AST.Nothing) uu____13597)))
            pats1
           in
        match tk with
        | (FStar_Pervasives_Native.Some a,k) ->
            let uu____13610 = FStar_Syntax_DsEnv.push_bv env a  in
            (match uu____13610 with
             | (env1,a1) ->
                 let a2 =
                   let uu___159_13620 = a1  in
                   {
                     FStar_Syntax_Syntax.ppname =
                       (uu___159_13620.FStar_Syntax_Syntax.ppname);
                     FStar_Syntax_Syntax.index =
                       (uu___159_13620.FStar_Syntax_Syntax.index);
                     FStar_Syntax_Syntax.sort = k
                   }  in
                 let pats1 = desugar_pats env1 pats  in
                 let body1 = desugar_formula env1 body  in
                 let body2 =
                   match pats1 with
                   | [] -> body1
                   | uu____13642 ->
                       mk1
                         (FStar_Syntax_Syntax.Tm_meta
                            (body1, (FStar_Syntax_Syntax.Meta_pattern pats1)))
                    in
                 let body3 =
                   let uu____13656 =
                     let uu____13659 =
                       let uu____13660 = FStar_Syntax_Syntax.mk_binder a2  in
                       [uu____13660]  in
                     no_annot_abs uu____13659 body2  in
                   FStar_All.pipe_left setpos uu____13656  in
                 let uu____13665 =
                   let uu____13666 =
                     let uu____13681 =
                       let uu____13682 =
                         FStar_Ident.set_lid_range q
                           b.FStar_Parser_AST.brange
                          in
                       FStar_Syntax_Syntax.fvar uu____13682
                         (FStar_Syntax_Syntax.Delta_constant_at_level
                            (Prims.parse_int "1"))
                         FStar_Pervasives_Native.None
                        in
                     let uu____13683 =
                       let uu____13686 = FStar_Syntax_Syntax.as_arg body3  in
                       [uu____13686]  in
                     (uu____13681, uu____13683)  in
                   FStar_Syntax_Syntax.Tm_app uu____13666  in
                 FStar_All.pipe_left mk1 uu____13665)
        | uu____13691 -> failwith "impossible"  in
      let push_quant q binders pats body =
        match binders with
        | b::b'::_rest ->
            let rest = b' :: _rest  in
            let body1 =
              let uu____13771 = q (rest, pats, body)  in
              let uu____13778 =
                FStar_Range.union_ranges b'.FStar_Parser_AST.brange
                  body.FStar_Parser_AST.range
                 in
              FStar_Parser_AST.mk_term uu____13771 uu____13778
                FStar_Parser_AST.Formula
               in
            let uu____13779 = q ([b], [], body1)  in
            FStar_Parser_AST.mk_term uu____13779 f.FStar_Parser_AST.range
              FStar_Parser_AST.Formula
        | uu____13788 -> failwith "impossible"  in
      let uu____13791 =
        let uu____13792 = unparen f  in uu____13792.FStar_Parser_AST.tm  in
      match uu____13791 with
      | FStar_Parser_AST.Labeled (f1,l,p) ->
          let f2 = desugar_formula env f1  in
          FStar_All.pipe_left mk1
            (FStar_Syntax_Syntax.Tm_meta
               (f2,
                 (FStar_Syntax_Syntax.Meta_labeled
                    (l, (f2.FStar_Syntax_Syntax.pos), p))))
      | FStar_Parser_AST.QForall ([],uu____13799,uu____13800) ->
          failwith "Impossible: Quantifier without binders"
      | FStar_Parser_AST.QExists ([],uu____13811,uu____13812) ->
          failwith "Impossible: Quantifier without binders"
      | FStar_Parser_AST.QForall (_1::_2::_3,pats,body) ->
          let binders = _1 :: _2 :: _3  in
          let uu____13843 =
            push_quant (fun x  -> FStar_Parser_AST.QForall x) binders pats
              body
             in
          desugar_formula env uu____13843
      | FStar_Parser_AST.QExists (_1::_2::_3,pats,body) ->
          let binders = _1 :: _2 :: _3  in
          let uu____13879 =
            push_quant (fun x  -> FStar_Parser_AST.QExists x) binders pats
              body
             in
          desugar_formula env uu____13879
      | FStar_Parser_AST.QForall (b::[],pats,body) ->
          desugar_quant FStar_Parser_Const.forall_lid b pats body
      | FStar_Parser_AST.QExists (b::[],pats,body) ->
          desugar_quant FStar_Parser_Const.exists_lid b pats body
      | FStar_Parser_AST.Paren f1 -> failwith "impossible"
      | uu____13922 -> desugar_term env f

and (typars_of_binders :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder Prims.list ->
      (FStar_Syntax_DsEnv.env,(FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.arg_qualifier
                                                        FStar_Pervasives_Native.option)
                                FStar_Pervasives_Native.tuple2 Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun bs  ->
      let uu____13927 =
        FStar_List.fold_left
          (fun uu____13963  ->
             fun b  ->
               match uu____13963 with
               | (env1,out) ->
                   let tk =
                     desugar_binder env1
                       (let uu___160_14015 = b  in
                        {
                          FStar_Parser_AST.b =
                            (uu___160_14015.FStar_Parser_AST.b);
                          FStar_Parser_AST.brange =
                            (uu___160_14015.FStar_Parser_AST.brange);
                          FStar_Parser_AST.blevel = FStar_Parser_AST.Formula;
                          FStar_Parser_AST.aqual =
                            (uu___160_14015.FStar_Parser_AST.aqual)
                        })
                      in
                   (match tk with
                    | (FStar_Pervasives_Native.Some a,k) ->
                        let uu____14032 = FStar_Syntax_DsEnv.push_bv env1 a
                           in
                        (match uu____14032 with
                         | (env2,a1) ->
                             let a2 =
                               let uu___161_14052 = a1  in
                               {
                                 FStar_Syntax_Syntax.ppname =
                                   (uu___161_14052.FStar_Syntax_Syntax.ppname);
                                 FStar_Syntax_Syntax.index =
                                   (uu___161_14052.FStar_Syntax_Syntax.index);
                                 FStar_Syntax_Syntax.sort = k
                               }  in
                             (env2,
                               ((a2, (trans_aqual b.FStar_Parser_AST.aqual))
                               :: out)))
                    | uu____14069 ->
                        FStar_Errors.raise_error
                          (FStar_Errors.Fatal_UnexpectedBinder,
                            "Unexpected binder") b.FStar_Parser_AST.brange))
          (env, []) bs
         in
      match uu____13927 with | (env1,tpars) -> (env1, (FStar_List.rev tpars))

and (desugar_binder :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder ->
      (FStar_Ident.ident FStar_Pervasives_Native.option,FStar_Syntax_Syntax.term)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun b  ->
      match b.FStar_Parser_AST.b with
      | FStar_Parser_AST.TAnnotated (x,t) ->
          let uu____14156 = desugar_typ env t  in
          ((FStar_Pervasives_Native.Some x), uu____14156)
      | FStar_Parser_AST.Annotated (x,t) ->
          let uu____14161 = desugar_typ env t  in
          ((FStar_Pervasives_Native.Some x), uu____14161)
      | FStar_Parser_AST.TVariable x ->
          let uu____14165 =
            FStar_Syntax_Syntax.mk
              (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_unknown)
              FStar_Pervasives_Native.None x.FStar_Ident.idRange
             in
          ((FStar_Pervasives_Native.Some x), uu____14165)
      | FStar_Parser_AST.NoName t ->
          let uu____14173 = desugar_typ env t  in
          (FStar_Pervasives_Native.None, uu____14173)
      | FStar_Parser_AST.Variable x ->
          ((FStar_Pervasives_Native.Some x), FStar_Syntax_Syntax.tun)

let (mk_data_discriminators :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_DsEnv.env ->
      FStar_Ident.lident Prims.list -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun quals  ->
    fun env  ->
      fun datas  ->
        let quals1 =
          FStar_All.pipe_right quals
            (FStar_List.filter
               (fun uu___123_14212  ->
                  match uu___123_14212 with
                  | FStar_Syntax_Syntax.Abstract  -> true
                  | FStar_Syntax_Syntax.Private  -> true
                  | uu____14213 -> false))
           in
        let quals2 q =
          let uu____14226 =
            (let uu____14229 = FStar_Syntax_DsEnv.iface env  in
             Prims.op_Negation uu____14229) ||
              (FStar_Syntax_DsEnv.admitted_iface env)
             in
          if uu____14226
          then FStar_List.append (FStar_Syntax_Syntax.Assumption :: q) quals1
          else FStar_List.append q quals1  in
        FStar_All.pipe_right datas
          (FStar_List.map
             (fun d  ->
                let disc_name = FStar_Syntax_Util.mk_discriminator d  in
                let uu____14243 = FStar_Ident.range_of_lid disc_name  in
                let uu____14244 =
                  quals2
                    [FStar_Syntax_Syntax.OnlyName;
                    FStar_Syntax_Syntax.Discriminator d]
                   in
                {
                  FStar_Syntax_Syntax.sigel =
                    (FStar_Syntax_Syntax.Sig_declare_typ
                       (disc_name, [], FStar_Syntax_Syntax.tun));
                  FStar_Syntax_Syntax.sigrng = uu____14243;
                  FStar_Syntax_Syntax.sigquals = uu____14244;
                  FStar_Syntax_Syntax.sigmeta =
                    FStar_Syntax_Syntax.default_sigmeta;
                  FStar_Syntax_Syntax.sigattrs = []
                }))
  
let (mk_indexed_projector_names :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_Syntax.fv_qual ->
      FStar_Syntax_DsEnv.env ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.binder Prims.list ->
            FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals  ->
    fun fvq  ->
      fun env  ->
        fun lid  ->
          fun fields  ->
            let p = FStar_Ident.range_of_lid lid  in
            let uu____14285 =
              FStar_All.pipe_right fields
                (FStar_List.mapi
                   (fun i  ->
                      fun uu____14315  ->
                        match uu____14315 with
                        | (x,uu____14323) ->
                            let uu____14324 =
                              FStar_Syntax_Util.mk_field_projector_name lid x
                                i
                               in
                            (match uu____14324 with
                             | (field_name,uu____14332) ->
                                 let only_decl =
                                   ((let uu____14336 =
                                       FStar_Syntax_DsEnv.current_module env
                                        in
                                     FStar_Ident.lid_equals
                                       FStar_Parser_Const.prims_lid
                                       uu____14336)
                                      ||
                                      (fvq <> FStar_Syntax_Syntax.Data_ctor))
                                     ||
                                     (let uu____14338 =
                                        let uu____14339 =
                                          FStar_Syntax_DsEnv.current_module
                                            env
                                           in
                                        uu____14339.FStar_Ident.str  in
                                      FStar_Options.dont_gen_projectors
                                        uu____14338)
                                    in
                                 let no_decl =
                                   FStar_Syntax_Syntax.is_type
                                     x.FStar_Syntax_Syntax.sort
                                    in
                                 let quals q =
                                   if only_decl
                                   then
                                     let uu____14355 =
                                       FStar_List.filter
                                         (fun uu___124_14359  ->
                                            match uu___124_14359 with
                                            | FStar_Syntax_Syntax.Abstract 
                                                -> false
                                            | uu____14360 -> true) q
                                        in
                                     FStar_Syntax_Syntax.Assumption ::
                                       uu____14355
                                   else q  in
                                 let quals1 =
                                   let iquals1 =
                                     FStar_All.pipe_right iquals
                                       (FStar_List.filter
                                          (fun uu___125_14373  ->
                                             match uu___125_14373 with
                                             | FStar_Syntax_Syntax.Abstract 
                                                 -> true
                                             | FStar_Syntax_Syntax.Private 
                                                 -> true
                                             | uu____14374 -> false))
                                      in
                                   quals (FStar_Syntax_Syntax.OnlyName ::
                                     (FStar_Syntax_Syntax.Projector
                                        (lid, (x.FStar_Syntax_Syntax.ppname)))
                                     :: iquals1)
                                    in
                                 let decl =
                                   let uu____14376 =
                                     FStar_Ident.range_of_lid field_name  in
                                   {
                                     FStar_Syntax_Syntax.sigel =
                                       (FStar_Syntax_Syntax.Sig_declare_typ
                                          (field_name, [],
                                            FStar_Syntax_Syntax.tun));
                                     FStar_Syntax_Syntax.sigrng = uu____14376;
                                     FStar_Syntax_Syntax.sigquals = quals1;
                                     FStar_Syntax_Syntax.sigmeta =
                                       FStar_Syntax_Syntax.default_sigmeta;
                                     FStar_Syntax_Syntax.sigattrs = []
                                   }  in
                                 if only_decl
                                 then [decl]
                                 else
                                   (let dd =
                                      let uu____14383 =
                                        FStar_All.pipe_right quals1
                                          (FStar_List.contains
                                             FStar_Syntax_Syntax.Abstract)
                                         in
                                      if uu____14383
                                      then
                                        FStar_Syntax_Syntax.Delta_abstract
                                          (FStar_Syntax_Syntax.Delta_equational_at_level
                                             (Prims.parse_int "1"))
                                      else
                                        FStar_Syntax_Syntax.Delta_equational_at_level
                                          (Prims.parse_int "1")
                                       in
                                    let lb =
                                      let uu____14388 =
                                        let uu____14393 =
                                          FStar_Syntax_Syntax.lid_as_fv
                                            field_name dd
                                            FStar_Pervasives_Native.None
                                           in
                                        FStar_Util.Inr uu____14393  in
                                      {
                                        FStar_Syntax_Syntax.lbname =
                                          uu____14388;
                                        FStar_Syntax_Syntax.lbunivs = [];
                                        FStar_Syntax_Syntax.lbtyp =
                                          FStar_Syntax_Syntax.tun;
                                        FStar_Syntax_Syntax.lbeff =
                                          FStar_Parser_Const.effect_Tot_lid;
                                        FStar_Syntax_Syntax.lbdef =
                                          FStar_Syntax_Syntax.tun;
                                        FStar_Syntax_Syntax.lbattrs = [];
                                        FStar_Syntax_Syntax.lbpos =
                                          FStar_Range.dummyRange
                                      }  in
                                    let impl =
                                      let uu____14397 =
                                        let uu____14398 =
                                          let uu____14405 =
                                            let uu____14408 =
                                              let uu____14409 =
                                                FStar_All.pipe_right
                                                  lb.FStar_Syntax_Syntax.lbname
                                                  FStar_Util.right
                                                 in
                                              FStar_All.pipe_right
                                                uu____14409
                                                (fun fv  ->
                                                   (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                                               in
                                            [uu____14408]  in
                                          ((false, [lb]), uu____14405)  in
                                        FStar_Syntax_Syntax.Sig_let
                                          uu____14398
                                         in
                                      {
                                        FStar_Syntax_Syntax.sigel =
                                          uu____14397;
                                        FStar_Syntax_Syntax.sigrng = p;
                                        FStar_Syntax_Syntax.sigquals = quals1;
                                        FStar_Syntax_Syntax.sigmeta =
                                          FStar_Syntax_Syntax.default_sigmeta;
                                        FStar_Syntax_Syntax.sigattrs = []
                                      }  in
                                    if no_decl then [impl] else [decl; impl]))))
               in
            FStar_All.pipe_right uu____14285 FStar_List.flatten
  
let (mk_data_projector_names :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_DsEnv.env ->
      FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals  ->
    fun env  ->
      fun se  ->
        match se.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_datacon
            (lid,uu____14459,t,uu____14461,n1,uu____14463) when
            let uu____14468 =
              FStar_Ident.lid_equals lid FStar_Parser_Const.lexcons_lid  in
            Prims.op_Negation uu____14468 ->
            let uu____14469 = FStar_Syntax_Util.arrow_formals t  in
            (match uu____14469 with
             | (formals,uu____14485) ->
                 (match formals with
                  | [] -> []
                  | uu____14508 ->
                      let filter_records uu___126_14522 =
                        match uu___126_14522 with
                        | FStar_Syntax_Syntax.RecordConstructor
                            (uu____14525,fns) ->
                            FStar_Pervasives_Native.Some
                              (FStar_Syntax_Syntax.Record_ctor (lid, fns))
                        | uu____14537 -> FStar_Pervasives_Native.None  in
                      let fv_qual =
                        let uu____14539 =
                          FStar_Util.find_map se.FStar_Syntax_Syntax.sigquals
                            filter_records
                           in
                        match uu____14539 with
                        | FStar_Pervasives_Native.None  ->
                            FStar_Syntax_Syntax.Data_ctor
                        | FStar_Pervasives_Native.Some q -> q  in
                      let iquals1 =
                        if
                          FStar_List.contains FStar_Syntax_Syntax.Abstract
                            iquals
                        then FStar_Syntax_Syntax.Private :: iquals
                        else iquals  in
                      let uu____14549 = FStar_Util.first_N n1 formals  in
                      (match uu____14549 with
                       | (uu____14572,rest) ->
                           mk_indexed_projector_names iquals1 fv_qual env lid
                             rest)))
        | uu____14598 -> []
  
let (mk_typ_abbrev :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.univ_name Prims.list ->
      (FStar_Syntax_Syntax.bv,FStar_Syntax_Syntax.aqual)
        FStar_Pervasives_Native.tuple2 Prims.list ->
        FStar_Syntax_Syntax.typ ->
          FStar_Syntax_Syntax.term ->
            FStar_Ident.lident Prims.list ->
              FStar_Syntax_Syntax.qualifier Prims.list ->
                FStar_Range.range -> FStar_Syntax_Syntax.sigelt)
  =
  fun lid  ->
    fun uvs  ->
      fun typars  ->
        fun k  ->
          fun t  ->
            fun lids  ->
              fun quals  ->
                fun rng  ->
                  let dd =
                    let uu____14664 =
                      FStar_All.pipe_right quals
                        (FStar_List.contains FStar_Syntax_Syntax.Abstract)
                       in
                    if uu____14664
                    then
                      let uu____14667 =
                        FStar_Syntax_Util.incr_delta_qualifier t  in
                      FStar_Syntax_Syntax.Delta_abstract uu____14667
                    else FStar_Syntax_Util.incr_delta_qualifier t  in
                  let lb =
                    let uu____14670 =
                      let uu____14675 =
                        FStar_Syntax_Syntax.lid_as_fv lid dd
                          FStar_Pervasives_Native.None
                         in
                      FStar_Util.Inr uu____14675  in
                    let uu____14676 =
                      let uu____14679 = FStar_Syntax_Syntax.mk_Total k  in
                      FStar_Syntax_Util.arrow typars uu____14679  in
                    let uu____14682 = no_annot_abs typars t  in
                    {
                      FStar_Syntax_Syntax.lbname = uu____14670;
                      FStar_Syntax_Syntax.lbunivs = uvs;
                      FStar_Syntax_Syntax.lbtyp = uu____14676;
                      FStar_Syntax_Syntax.lbeff =
                        FStar_Parser_Const.effect_Tot_lid;
                      FStar_Syntax_Syntax.lbdef = uu____14682;
                      FStar_Syntax_Syntax.lbattrs = [];
                      FStar_Syntax_Syntax.lbpos = rng
                    }  in
                  {
                    FStar_Syntax_Syntax.sigel =
                      (FStar_Syntax_Syntax.Sig_let ((false, [lb]), lids));
                    FStar_Syntax_Syntax.sigrng = rng;
                    FStar_Syntax_Syntax.sigquals = quals;
                    FStar_Syntax_Syntax.sigmeta =
                      FStar_Syntax_Syntax.default_sigmeta;
                    FStar_Syntax_Syntax.sigattrs = []
                  }
  
let rec (desugar_tycon :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.decl ->
      FStar_Syntax_Syntax.qualifier Prims.list ->
        FStar_Parser_AST.tycon Prims.list ->
          (env_t,FStar_Syntax_Syntax.sigelts) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      fun quals  ->
        fun tcs  ->
          let rng = d.FStar_Parser_AST.drange  in
          let tycon_id uu___127_14739 =
            match uu___127_14739 with
            | FStar_Parser_AST.TyconAbstract (id1,uu____14741,uu____14742) ->
                id1
            | FStar_Parser_AST.TyconAbbrev
                (id1,uu____14752,uu____14753,uu____14754) -> id1
            | FStar_Parser_AST.TyconRecord
                (id1,uu____14764,uu____14765,uu____14766) -> id1
            | FStar_Parser_AST.TyconVariant
                (id1,uu____14796,uu____14797,uu____14798) -> id1
             in
          let binder_to_term b =
            match b.FStar_Parser_AST.b with
            | FStar_Parser_AST.Annotated (x,uu____14842) ->
                let uu____14843 =
                  let uu____14844 = FStar_Ident.lid_of_ids [x]  in
                  FStar_Parser_AST.Var uu____14844  in
                FStar_Parser_AST.mk_term uu____14843 x.FStar_Ident.idRange
                  FStar_Parser_AST.Expr
            | FStar_Parser_AST.Variable x ->
                let uu____14846 =
                  let uu____14847 = FStar_Ident.lid_of_ids [x]  in
                  FStar_Parser_AST.Var uu____14847  in
                FStar_Parser_AST.mk_term uu____14846 x.FStar_Ident.idRange
                  FStar_Parser_AST.Expr
            | FStar_Parser_AST.TAnnotated (a,uu____14849) ->
                FStar_Parser_AST.mk_term (FStar_Parser_AST.Tvar a)
                  a.FStar_Ident.idRange FStar_Parser_AST.Type_level
            | FStar_Parser_AST.TVariable a ->
                FStar_Parser_AST.mk_term (FStar_Parser_AST.Tvar a)
                  a.FStar_Ident.idRange FStar_Parser_AST.Type_level
            | FStar_Parser_AST.NoName t -> t  in
          let tot =
            FStar_Parser_AST.mk_term
              (FStar_Parser_AST.Name FStar_Parser_Const.effect_Tot_lid) rng
              FStar_Parser_AST.Expr
             in
          let with_constructor_effect t =
            FStar_Parser_AST.mk_term
              (FStar_Parser_AST.App (tot, t, FStar_Parser_AST.Nothing))
              t.FStar_Parser_AST.range t.FStar_Parser_AST.level
             in
          let apply_binders t binders =
            let imp_of_aqual b =
              match b.FStar_Parser_AST.aqual with
              | FStar_Pervasives_Native.Some (FStar_Parser_AST.Implicit ) ->
                  FStar_Parser_AST.Hash
              | uu____14880 -> FStar_Parser_AST.Nothing  in
            FStar_List.fold_left
              (fun out  ->
                 fun b  ->
                   let uu____14886 =
                     let uu____14887 =
                       let uu____14894 = binder_to_term b  in
                       (out, uu____14894, (imp_of_aqual b))  in
                     FStar_Parser_AST.App uu____14887  in
                   FStar_Parser_AST.mk_term uu____14886
                     out.FStar_Parser_AST.range out.FStar_Parser_AST.level) t
              binders
             in
          let tycon_record_as_variant uu___128_14906 =
            match uu___128_14906 with
            | FStar_Parser_AST.TyconRecord (id1,parms,kopt,fields) ->
                let constrName =
                  FStar_Ident.mk_ident
                    ((Prims.strcat "Mk" id1.FStar_Ident.idText),
                      (id1.FStar_Ident.idRange))
                   in
                let mfields =
                  FStar_List.map
                    (fun uu____14962  ->
                       match uu____14962 with
                       | (x,t,uu____14973) ->
                           let uu____14978 =
                             let uu____14979 =
                               let uu____14984 =
                                 FStar_Syntax_Util.mangle_field_name x  in
                               (uu____14984, t)  in
                             FStar_Parser_AST.Annotated uu____14979  in
                           FStar_Parser_AST.mk_binder uu____14978
                             x.FStar_Ident.idRange FStar_Parser_AST.Expr
                             FStar_Pervasives_Native.None) fields
                   in
                let result =
                  let uu____14986 =
                    let uu____14987 =
                      let uu____14988 = FStar_Ident.lid_of_ids [id1]  in
                      FStar_Parser_AST.Var uu____14988  in
                    FStar_Parser_AST.mk_term uu____14987
                      id1.FStar_Ident.idRange FStar_Parser_AST.Type_level
                     in
                  apply_binders uu____14986 parms  in
                let constrTyp =
                  FStar_Parser_AST.mk_term
                    (FStar_Parser_AST.Product
                       (mfields, (with_constructor_effect result)))
                    id1.FStar_Ident.idRange FStar_Parser_AST.Type_level
                   in
                let uu____14992 =
                  FStar_All.pipe_right fields
                    (FStar_List.map
                       (fun uu____15019  ->
                          match uu____15019 with
                          | (x,uu____15029,uu____15030) ->
                              FStar_Syntax_Util.unmangle_field_name x))
                   in
                ((FStar_Parser_AST.TyconVariant
                    (id1, parms, kopt,
                      [(constrName, (FStar_Pervasives_Native.Some constrTyp),
                         FStar_Pervasives_Native.None, false)])),
                  uu____14992)
            | uu____15083 -> failwith "impossible"  in
          let desugar_abstract_tc quals1 _env mutuals uu___129_15122 =
            match uu___129_15122 with
            | FStar_Parser_AST.TyconAbstract (id1,binders,kopt) ->
                let uu____15146 = typars_of_binders _env binders  in
                (match uu____15146 with
                 | (_env',typars) ->
                     let k =
                       match kopt with
                       | FStar_Pervasives_Native.None  ->
                           FStar_Syntax_Util.ktype
                       | FStar_Pervasives_Native.Some k ->
                           desugar_term _env' k
                        in
                     let tconstr =
                       let uu____15188 =
                         let uu____15189 =
                           let uu____15190 = FStar_Ident.lid_of_ids [id1]  in
                           FStar_Parser_AST.Var uu____15190  in
                         FStar_Parser_AST.mk_term uu____15189
                           id1.FStar_Ident.idRange
                           FStar_Parser_AST.Type_level
                          in
                       apply_binders uu____15188 binders  in
                     let qlid = FStar_Syntax_DsEnv.qualify _env id1  in
                     let typars1 = FStar_Syntax_Subst.close_binders typars
                        in
                     let k1 = FStar_Syntax_Subst.close typars1 k  in
                     let se =
                       {
                         FStar_Syntax_Syntax.sigel =
                           (FStar_Syntax_Syntax.Sig_inductive_typ
                              (qlid, [], typars1, k1, mutuals, []));
                         FStar_Syntax_Syntax.sigrng = rng;
                         FStar_Syntax_Syntax.sigquals = quals1;
                         FStar_Syntax_Syntax.sigmeta =
                           FStar_Syntax_Syntax.default_sigmeta;
                         FStar_Syntax_Syntax.sigattrs = []
                       }  in
                     let _env1 =
                       FStar_Syntax_DsEnv.push_top_level_rec_binding _env id1
                         FStar_Syntax_Syntax.delta_constant
                        in
                     let _env2 =
                       FStar_Syntax_DsEnv.push_top_level_rec_binding _env'
                         id1 FStar_Syntax_Syntax.delta_constant
                        in
                     (_env1, _env2, se, tconstr))
            | uu____15203 -> failwith "Unexpected tycon"  in
          let push_tparams env1 bs =
            let uu____15251 =
              FStar_List.fold_left
                (fun uu____15291  ->
                   fun uu____15292  ->
                     match (uu____15291, uu____15292) with
                     | ((env2,tps),(x,imp)) ->
                         let uu____15383 =
                           FStar_Syntax_DsEnv.push_bv env2
                             x.FStar_Syntax_Syntax.ppname
                            in
                         (match uu____15383 with
                          | (env3,y) -> (env3, ((y, imp) :: tps))))
                (env1, []) bs
               in
            match uu____15251 with
            | (env2,bs1) -> (env2, (FStar_List.rev bs1))  in
          match tcs with
          | (FStar_Parser_AST.TyconAbstract (id1,bs,kopt))::[] ->
              let kopt1 =
                match kopt with
                | FStar_Pervasives_Native.None  ->
                    let uu____15496 = tm_type_z id1.FStar_Ident.idRange  in
                    FStar_Pervasives_Native.Some uu____15496
                | uu____15497 -> kopt  in
              let tc = FStar_Parser_AST.TyconAbstract (id1, bs, kopt1)  in
              let uu____15505 = desugar_abstract_tc quals env [] tc  in
              (match uu____15505 with
               | (uu____15518,uu____15519,se,uu____15521) ->
                   let se1 =
                     match se.FStar_Syntax_Syntax.sigel with
                     | FStar_Syntax_Syntax.Sig_inductive_typ
                         (l,uu____15524,typars,k,[],[]) ->
                         let quals1 = se.FStar_Syntax_Syntax.sigquals  in
                         let quals2 =
                           if
                             FStar_List.contains
                               FStar_Syntax_Syntax.Assumption quals1
                           then quals1
                           else
                             ((let uu____15541 =
                                 let uu____15542 = FStar_Options.ml_ish ()
                                    in
                                 Prims.op_Negation uu____15542  in
                               if uu____15541
                               then
                                 let uu____15543 =
                                   let uu____15548 =
                                     let uu____15549 =
                                       FStar_Syntax_Print.lid_to_string l  in
                                     FStar_Util.format1
                                       "Adding an implicit 'assume new' qualifier on %s"
                                       uu____15549
                                      in
                                   (FStar_Errors.Warning_AddImplicitAssumeNewQualifier,
                                     uu____15548)
                                    in
                                 FStar_Errors.log_issue
                                   se.FStar_Syntax_Syntax.sigrng uu____15543
                               else ());
                              FStar_Syntax_Syntax.Assumption
                              ::
                              FStar_Syntax_Syntax.New
                              ::
                              quals1)
                            in
                         let t =
                           match typars with
                           | [] -> k
                           | uu____15556 ->
                               let uu____15557 =
                                 let uu____15564 =
                                   let uu____15565 =
                                     let uu____15578 =
                                       FStar_Syntax_Syntax.mk_Total k  in
                                     (typars, uu____15578)  in
                                   FStar_Syntax_Syntax.Tm_arrow uu____15565
                                    in
                                 FStar_Syntax_Syntax.mk uu____15564  in
                               uu____15557 FStar_Pervasives_Native.None
                                 se.FStar_Syntax_Syntax.sigrng
                            in
                         let uu___162_15582 = se  in
                         {
                           FStar_Syntax_Syntax.sigel =
                             (FStar_Syntax_Syntax.Sig_declare_typ (l, [], t));
                           FStar_Syntax_Syntax.sigrng =
                             (uu___162_15582.FStar_Syntax_Syntax.sigrng);
                           FStar_Syntax_Syntax.sigquals = quals2;
                           FStar_Syntax_Syntax.sigmeta =
                             (uu___162_15582.FStar_Syntax_Syntax.sigmeta);
                           FStar_Syntax_Syntax.sigattrs =
                             (uu___162_15582.FStar_Syntax_Syntax.sigattrs)
                         }
                     | uu____15585 -> failwith "Impossible"  in
                   let env1 = FStar_Syntax_DsEnv.push_sigelt env se1  in
                   let env2 =
                     let uu____15588 = FStar_Syntax_DsEnv.qualify env1 id1
                        in
                     FStar_Syntax_DsEnv.push_doc env1 uu____15588
                       d.FStar_Parser_AST.doc
                      in
                   (env2, [se1]))
          | (FStar_Parser_AST.TyconAbbrev (id1,binders,kopt,t))::[] ->
              let uu____15603 = typars_of_binders env binders  in
              (match uu____15603 with
               | (env',typars) ->
                   let k =
                     match kopt with
                     | FStar_Pervasives_Native.None  ->
                         let uu____15639 =
                           FStar_Util.for_some
                             (fun uu___130_15641  ->
                                match uu___130_15641 with
                                | FStar_Syntax_Syntax.Effect  -> true
                                | uu____15642 -> false) quals
                            in
                         if uu____15639
                         then FStar_Syntax_Syntax.teff
                         else FStar_Syntax_Util.ktype
                     | FStar_Pervasives_Native.Some k -> desugar_term env' k
                      in
                   let t0 = t  in
                   let quals1 =
                     let uu____15649 =
                       FStar_All.pipe_right quals
                         (FStar_Util.for_some
                            (fun uu___131_15653  ->
                               match uu___131_15653 with
                               | FStar_Syntax_Syntax.Logic  -> true
                               | uu____15654 -> false))
                        in
                     if uu____15649
                     then quals
                     else
                       if
                         t0.FStar_Parser_AST.level = FStar_Parser_AST.Formula
                       then FStar_Syntax_Syntax.Logic :: quals
                       else quals
                      in
                   let qlid = FStar_Syntax_DsEnv.qualify env id1  in
                   let se =
                     let uu____15663 =
                       FStar_All.pipe_right quals1
                         (FStar_List.contains FStar_Syntax_Syntax.Effect)
                        in
                     if uu____15663
                     then
                       let uu____15666 =
                         let uu____15673 =
                           let uu____15674 = unparen t  in
                           uu____15674.FStar_Parser_AST.tm  in
                         match uu____15673 with
                         | FStar_Parser_AST.Construct (head1,args) ->
                             let uu____15695 =
                               match FStar_List.rev args with
                               | (last_arg,uu____15725)::args_rev ->
                                   let uu____15737 =
                                     let uu____15738 = unparen last_arg  in
                                     uu____15738.FStar_Parser_AST.tm  in
                                   (match uu____15737 with
                                    | FStar_Parser_AST.Attributes ts ->
                                        (ts, (FStar_List.rev args_rev))
                                    | uu____15766 -> ([], args))
                               | uu____15775 -> ([], args)  in
                             (match uu____15695 with
                              | (cattributes,args1) ->
                                  let uu____15814 =
                                    desugar_attributes env cattributes  in
                                  ((FStar_Parser_AST.mk_term
                                      (FStar_Parser_AST.Construct
                                         (head1, args1))
                                      t.FStar_Parser_AST.range
                                      t.FStar_Parser_AST.level), uu____15814))
                         | uu____15825 -> (t, [])  in
                       match uu____15666 with
                       | (t1,cattributes) ->
                           let c =
                             desugar_comp t1.FStar_Parser_AST.range env' t1
                              in
                           let typars1 =
                             FStar_Syntax_Subst.close_binders typars  in
                           let c1 = FStar_Syntax_Subst.close_comp typars1 c
                              in
                           let quals2 =
                             FStar_All.pipe_right quals1
                               (FStar_List.filter
                                  (fun uu___132_15847  ->
                                     match uu___132_15847 with
                                     | FStar_Syntax_Syntax.Effect  -> false
                                     | uu____15848 -> true))
                              in
                           {
                             FStar_Syntax_Syntax.sigel =
                               (FStar_Syntax_Syntax.Sig_effect_abbrev
                                  (qlid, [], typars1, c1,
                                    (FStar_List.append cattributes
                                       (FStar_Syntax_Util.comp_flags c1))));
                             FStar_Syntax_Syntax.sigrng = rng;
                             FStar_Syntax_Syntax.sigquals = quals2;
                             FStar_Syntax_Syntax.sigmeta =
                               FStar_Syntax_Syntax.default_sigmeta;
                             FStar_Syntax_Syntax.sigattrs = []
                           }
                     else
                       (let t1 = desugar_typ env' t  in
                        mk_typ_abbrev qlid [] typars k t1 [qlid] quals1 rng)
                      in
                   let env1 = FStar_Syntax_DsEnv.push_sigelt env se  in
                   let env2 =
                     FStar_Syntax_DsEnv.push_doc env1 qlid
                       d.FStar_Parser_AST.doc
                      in
                   (env2, [se]))
          | (FStar_Parser_AST.TyconRecord uu____15859)::[] ->
              let trec = FStar_List.hd tcs  in
              let uu____15883 = tycon_record_as_variant trec  in
              (match uu____15883 with
               | (t,fs) ->
                   let uu____15900 =
                     let uu____15903 =
                       let uu____15904 =
                         let uu____15913 =
                           let uu____15916 =
                             FStar_Syntax_DsEnv.current_module env  in
                           FStar_Ident.ids_of_lid uu____15916  in
                         (uu____15913, fs)  in
                       FStar_Syntax_Syntax.RecordType uu____15904  in
                     uu____15903 :: quals  in
                   desugar_tycon env d uu____15900 [t])
          | uu____15921::uu____15922 ->
              let env0 = env  in
              let mutuals =
                FStar_List.map
                  (fun x  ->
                     FStar_All.pipe_left (FStar_Syntax_DsEnv.qualify env)
                       (tycon_id x)) tcs
                 in
              let rec collect_tcs quals1 et tc =
                let uu____16089 = et  in
                match uu____16089 with
                | (env1,tcs1) ->
                    (match tc with
                     | FStar_Parser_AST.TyconRecord uu____16314 ->
                         let trec = tc  in
                         let uu____16338 = tycon_record_as_variant trec  in
                         (match uu____16338 with
                          | (t,fs) ->
                              let uu____16397 =
                                let uu____16400 =
                                  let uu____16401 =
                                    let uu____16410 =
                                      let uu____16413 =
                                        FStar_Syntax_DsEnv.current_module
                                          env1
                                         in
                                      FStar_Ident.ids_of_lid uu____16413  in
                                    (uu____16410, fs)  in
                                  FStar_Syntax_Syntax.RecordType uu____16401
                                   in
                                uu____16400 :: quals1  in
                              collect_tcs uu____16397 (env1, tcs1) t)
                     | FStar_Parser_AST.TyconVariant
                         (id1,binders,kopt,constructors) ->
                         let uu____16500 =
                           desugar_abstract_tc quals1 env1 mutuals
                             (FStar_Parser_AST.TyconAbstract
                                (id1, binders, kopt))
                            in
                         (match uu____16500 with
                          | (env2,uu____16560,se,tconstr) ->
                              (env2,
                                ((FStar_Util.Inl
                                    (se, constructors, tconstr, quals1)) ::
                                tcs1)))
                     | FStar_Parser_AST.TyconAbbrev (id1,binders,kopt,t) ->
                         let uu____16709 =
                           desugar_abstract_tc quals1 env1 mutuals
                             (FStar_Parser_AST.TyconAbstract
                                (id1, binders, kopt))
                            in
                         (match uu____16709 with
                          | (env2,uu____16769,se,tconstr) ->
                              (env2,
                                ((FStar_Util.Inr (se, binders, t, quals1)) ::
                                tcs1)))
                     | uu____16894 ->
                         failwith "Unrecognized mutual type definition")
                 in
              let uu____16941 =
                FStar_List.fold_left (collect_tcs quals) (env, []) tcs  in
              (match uu____16941 with
               | (env1,tcs1) ->
                   let tcs2 = FStar_List.rev tcs1  in
                   let docs_tps_sigelts =
                     FStar_All.pipe_right tcs2
                       (FStar_List.collect
                          (fun uu___134_17452  ->
                             match uu___134_17452 with
                             | FStar_Util.Inr
                                 ({
                                    FStar_Syntax_Syntax.sigel =
                                      FStar_Syntax_Syntax.Sig_inductive_typ
                                      (id1,uvs,tpars,k,uu____17519,uu____17520);
                                    FStar_Syntax_Syntax.sigrng = uu____17521;
                                    FStar_Syntax_Syntax.sigquals =
                                      uu____17522;
                                    FStar_Syntax_Syntax.sigmeta = uu____17523;
                                    FStar_Syntax_Syntax.sigattrs =
                                      uu____17524;_},binders,t,quals1)
                                 ->
                                 let t1 =
                                   let uu____17585 =
                                     typars_of_binders env1 binders  in
                                   match uu____17585 with
                                   | (env2,tpars1) ->
                                       let uu____17616 =
                                         push_tparams env2 tpars1  in
                                       (match uu____17616 with
                                        | (env_tps,tpars2) ->
                                            let t1 = desugar_typ env_tps t
                                               in
                                            let tpars3 =
                                              FStar_Syntax_Subst.close_binders
                                                tpars2
                                               in
                                            FStar_Syntax_Subst.close tpars3
                                              t1)
                                    in
                                 let uu____17649 =
                                   let uu____17670 =
                                     mk_typ_abbrev id1 uvs tpars k t1 
                                       [id1] quals1 rng
                                      in
                                   ((id1, (d.FStar_Parser_AST.doc)), [],
                                     uu____17670)
                                    in
                                 [uu____17649]
                             | FStar_Util.Inl
                                 ({
                                    FStar_Syntax_Syntax.sigel =
                                      FStar_Syntax_Syntax.Sig_inductive_typ
                                      (tname,univs1,tpars,k,mutuals1,uu____17738);
                                    FStar_Syntax_Syntax.sigrng = uu____17739;
                                    FStar_Syntax_Syntax.sigquals =
                                      tname_quals;
                                    FStar_Syntax_Syntax.sigmeta = uu____17741;
                                    FStar_Syntax_Syntax.sigattrs =
                                      uu____17742;_},constrs,tconstr,quals1)
                                 ->
                                 let mk_tot t =
                                   let tot1 =
                                     FStar_Parser_AST.mk_term
                                       (FStar_Parser_AST.Name
                                          FStar_Parser_Const.effect_Tot_lid)
                                       t.FStar_Parser_AST.range
                                       t.FStar_Parser_AST.level
                                      in
                                   FStar_Parser_AST.mk_term
                                     (FStar_Parser_AST.App
                                        (tot1, t, FStar_Parser_AST.Nothing))
                                     t.FStar_Parser_AST.range
                                     t.FStar_Parser_AST.level
                                    in
                                 let tycon = (tname, tpars, k)  in
                                 let uu____17840 = push_tparams env1 tpars
                                    in
                                 (match uu____17840 with
                                  | (env_tps,tps) ->
                                      let data_tpars =
                                        FStar_List.map
                                          (fun uu____17917  ->
                                             match uu____17917 with
                                             | (x,uu____17931) ->
                                                 (x,
                                                   (FStar_Pervasives_Native.Some
                                                      (FStar_Syntax_Syntax.Implicit
                                                         true)))) tps
                                         in
                                      let tot_tconstr = mk_tot tconstr  in
                                      let uu____17939 =
                                        let uu____17968 =
                                          FStar_All.pipe_right constrs
                                            (FStar_List.map
                                               (fun uu____18082  ->
                                                  match uu____18082 with
                                                  | (id1,topt,doc1,of_notation)
                                                      ->
                                                      let t =
                                                        if of_notation
                                                        then
                                                          match topt with
                                                          | FStar_Pervasives_Native.Some
                                                              t ->
                                                              FStar_Parser_AST.mk_term
                                                                (FStar_Parser_AST.Product
                                                                   ([
                                                                    FStar_Parser_AST.mk_binder
                                                                    (FStar_Parser_AST.NoName
                                                                    t)
                                                                    t.FStar_Parser_AST.range
                                                                    t.FStar_Parser_AST.level
                                                                    FStar_Pervasives_Native.None],
                                                                    tot_tconstr))
                                                                t.FStar_Parser_AST.range
                                                                t.FStar_Parser_AST.level
                                                          | FStar_Pervasives_Native.None
                                                               -> tconstr
                                                        else
                                                          (match topt with
                                                           | FStar_Pervasives_Native.None
                                                                ->
                                                               failwith
                                                                 "Impossible"
                                                           | FStar_Pervasives_Native.Some
                                                               t -> t)
                                                         in
                                                      let t1 =
                                                        let uu____18138 =
                                                          close env_tps t  in
                                                        desugar_term env_tps
                                                          uu____18138
                                                         in
                                                      let name =
                                                        FStar_Syntax_DsEnv.qualify
                                                          env1 id1
                                                         in
                                                      let quals2 =
                                                        FStar_All.pipe_right
                                                          tname_quals
                                                          (FStar_List.collect
                                                             (fun
                                                                uu___133_18149
                                                                 ->
                                                                match uu___133_18149
                                                                with
                                                                | FStar_Syntax_Syntax.RecordType
                                                                    fns ->
                                                                    [
                                                                    FStar_Syntax_Syntax.RecordConstructor
                                                                    fns]
                                                                | uu____18161
                                                                    -> []))
                                                         in
                                                      let ntps =
                                                        FStar_List.length
                                                          data_tpars
                                                         in
                                                      let uu____18169 =
                                                        let uu____18190 =
                                                          let uu____18191 =
                                                            let uu____18192 =
                                                              let uu____18207
                                                                =
                                                                let uu____18210
                                                                  =
                                                                  let uu____18213
                                                                    =
                                                                    FStar_All.pipe_right
                                                                    t1
                                                                    FStar_Syntax_Util.name_function_binders
                                                                     in
                                                                  FStar_Syntax_Syntax.mk_Total
                                                                    uu____18213
                                                                   in
                                                                FStar_Syntax_Util.arrow
                                                                  data_tpars
                                                                  uu____18210
                                                                 in
                                                              (name, univs1,
                                                                uu____18207,
                                                                tname, ntps,
                                                                mutuals1)
                                                               in
                                                            FStar_Syntax_Syntax.Sig_datacon
                                                              uu____18192
                                                             in
                                                          {
                                                            FStar_Syntax_Syntax.sigel
                                                              = uu____18191;
                                                            FStar_Syntax_Syntax.sigrng
                                                              = rng;
                                                            FStar_Syntax_Syntax.sigquals
                                                              = quals2;
                                                            FStar_Syntax_Syntax.sigmeta
                                                              =
                                                              FStar_Syntax_Syntax.default_sigmeta;
                                                            FStar_Syntax_Syntax.sigattrs
                                                              = []
                                                          }  in
                                                        ((name, doc1), tps,
                                                          uu____18190)
                                                         in
                                                      (name, uu____18169)))
                                           in
                                        FStar_All.pipe_left FStar_List.split
                                          uu____17968
                                         in
                                      (match uu____17939 with
                                       | (constrNames,constrs1) ->
                                           ((tname, (d.FStar_Parser_AST.doc)),
                                             [],
                                             {
                                               FStar_Syntax_Syntax.sigel =
                                                 (FStar_Syntax_Syntax.Sig_inductive_typ
                                                    (tname, univs1, tpars, k,
                                                      mutuals1, constrNames));
                                               FStar_Syntax_Syntax.sigrng =
                                                 rng;
                                               FStar_Syntax_Syntax.sigquals =
                                                 tname_quals;
                                               FStar_Syntax_Syntax.sigmeta =
                                                 FStar_Syntax_Syntax.default_sigmeta;
                                               FStar_Syntax_Syntax.sigattrs =
                                                 []
                                             })
                                           :: constrs1))
                             | uu____18452 -> failwith "impossible"))
                      in
                   let name_docs =
                     FStar_All.pipe_right docs_tps_sigelts
                       (FStar_List.map
                          (fun uu____18584  ->
                             match uu____18584 with
                             | (name_doc,uu____18612,uu____18613) -> name_doc))
                      in
                   let sigelts =
                     FStar_All.pipe_right docs_tps_sigelts
                       (FStar_List.map
                          (fun uu____18693  ->
                             match uu____18693 with
                             | (uu____18714,uu____18715,se) -> se))
                      in
                   let uu____18745 =
                     let uu____18752 =
                       FStar_List.collect FStar_Syntax_Util.lids_of_sigelt
                         sigelts
                        in
                     FStar_Syntax_MutRecTy.disentangle_abbrevs_from_bundle
                       sigelts quals uu____18752 rng
                      in
                   (match uu____18745 with
                    | (bundle,abbrevs) ->
                        let env2 = FStar_Syntax_DsEnv.push_sigelt env0 bundle
                           in
                        let env3 =
                          FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt
                            env2 abbrevs
                           in
                        let data_ops =
                          FStar_All.pipe_right docs_tps_sigelts
                            (FStar_List.collect
                               (fun uu____18818  ->
                                  match uu____18818 with
                                  | (uu____18841,tps,se) ->
                                      mk_data_projector_names quals env3 se))
                           in
                        let discs =
                          FStar_All.pipe_right sigelts
                            (FStar_List.collect
                               (fun se  ->
                                  match se.FStar_Syntax_Syntax.sigel with
                                  | FStar_Syntax_Syntax.Sig_inductive_typ
                                      (tname,uu____18892,tps,k,uu____18895,constrs)
                                      when
                                      (FStar_List.length constrs) >
                                        (Prims.parse_int "1")
                                      ->
                                      let quals1 =
                                        se.FStar_Syntax_Syntax.sigquals  in
                                      let quals2 =
                                        if
                                          FStar_List.contains
                                            FStar_Syntax_Syntax.Abstract
                                            quals1
                                        then FStar_Syntax_Syntax.Private ::
                                          quals1
                                        else quals1  in
                                      mk_data_discriminators quals2 env3
                                        constrs
                                  | uu____18914 -> []))
                           in
                        let ops = FStar_List.append discs data_ops  in
                        let env4 =
                          FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt
                            env3 ops
                           in
                        let env5 =
                          FStar_List.fold_left
                            (fun acc  ->
                               fun uu____18931  ->
                                 match uu____18931 with
                                 | (lid,doc1) ->
                                     FStar_Syntax_DsEnv.push_doc env4 lid
                                       doc1) env4 name_docs
                           in
                        (env5,
                          (FStar_List.append [bundle]
                             (FStar_List.append abbrevs ops)))))
          | [] -> failwith "impossible"
  
let (desugar_binders :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.binder Prims.list ->
      (FStar_Syntax_DsEnv.env,FStar_Syntax_Syntax.binder Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun binders  ->
      let uu____18970 =
        FStar_List.fold_left
          (fun uu____18993  ->
             fun b  ->
               match uu____18993 with
               | (env1,binders1) ->
                   let uu____19013 = desugar_binder env1 b  in
                   (match uu____19013 with
                    | (FStar_Pervasives_Native.Some a,k) ->
                        let uu____19030 =
                          as_binder env1 b.FStar_Parser_AST.aqual
                            ((FStar_Pervasives_Native.Some a), k)
                           in
                        (match uu____19030 with
                         | (binder,env2) -> (env2, (binder :: binders1)))
                    | uu____19047 ->
                        FStar_Errors.raise_error
                          (FStar_Errors.Fatal_MissingNameInBinder,
                            "Missing name in binder")
                          b.FStar_Parser_AST.brange)) (env, []) binders
         in
      match uu____18970 with
      | (env1,binders1) -> (env1, (FStar_List.rev binders1))
  
let (push_reflect_effect :
  FStar_Syntax_DsEnv.env ->
    FStar_Syntax_Syntax.qualifier Prims.list ->
      FStar_Ident.lid -> FStar_Range.range -> FStar_Syntax_DsEnv.env)
  =
  fun env  ->
    fun quals  ->
      fun effect_name  ->
        fun range  ->
          let uu____19100 =
            FStar_All.pipe_right quals
              (FStar_Util.for_some
                 (fun uu___135_19105  ->
                    match uu___135_19105 with
                    | FStar_Syntax_Syntax.Reflectable uu____19106 -> true
                    | uu____19107 -> false))
             in
          if uu____19100
          then
            let monad_env =
              FStar_Syntax_DsEnv.enter_monad_scope env
                effect_name.FStar_Ident.ident
               in
            let reflect_lid =
              let uu____19110 = FStar_Ident.id_of_text "reflect"  in
              FStar_All.pipe_right uu____19110
                (FStar_Syntax_DsEnv.qualify monad_env)
               in
            let quals1 =
              [FStar_Syntax_Syntax.Assumption;
              FStar_Syntax_Syntax.Reflectable effect_name]  in
            let refl_decl =
              {
                FStar_Syntax_Syntax.sigel =
                  (FStar_Syntax_Syntax.Sig_declare_typ
                     (reflect_lid, [], FStar_Syntax_Syntax.tun));
                FStar_Syntax_Syntax.sigrng = range;
                FStar_Syntax_Syntax.sigquals = quals1;
                FStar_Syntax_Syntax.sigmeta =
                  FStar_Syntax_Syntax.default_sigmeta;
                FStar_Syntax_Syntax.sigattrs = []
              }  in
            FStar_Syntax_DsEnv.push_sigelt env refl_decl
          else env
  
let (get_fail_attr :
  Prims.bool ->
    FStar_Syntax_Syntax.term ->
      (Prims.int Prims.list,Prims.bool) FStar_Pervasives_Native.tuple2
        FStar_Pervasives_Native.option)
  =
  fun warn  ->
    fun at1  ->
      let uu____19144 = FStar_Syntax_Util.head_and_args at1  in
      match uu____19144 with
      | (hd1,args) ->
          let uu____19189 =
            let uu____19202 =
              let uu____19203 = FStar_Syntax_Subst.compress hd1  in
              uu____19203.FStar_Syntax_Syntax.n  in
            (uu____19202, args)  in
          (match uu____19189 with
           | (FStar_Syntax_Syntax.Tm_fvar fv,(a1,uu____19224)::[]) when
               FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.fail_attr
               ->
               let uu____19249 =
                 let uu____19254 =
                   FStar_Syntax_Embeddings.e_list
                     FStar_Syntax_Embeddings.e_int
                    in
                 FStar_Syntax_Embeddings.unembed uu____19254 a1  in
               (match uu____19249 with
                | FStar_Pervasives_Native.Some [] ->
                    FStar_Errors.raise_error
                      (FStar_Errors.Error_EmptyFailErrs,
                        "Found ill-applied fail, argument should be a non-empty list of integers")
                      at1.FStar_Syntax_Syntax.pos
                | FStar_Pervasives_Native.Some es ->
                    let uu____19284 =
                      let uu____19291 =
                        FStar_List.map FStar_BigInt.to_int_fs es  in
                      (uu____19291, false)  in
                    FStar_Pervasives_Native.Some uu____19284
                | FStar_Pervasives_Native.None  ->
                    (if warn
                     then
                       FStar_Errors.log_issue at1.FStar_Syntax_Syntax.pos
                         (FStar_Errors.Warning_UnappliedFail,
                           "Found ill-applied fail, argument should be a non-empty list of integer literals")
                     else ();
                     FStar_Pervasives_Native.None))
           | (FStar_Syntax_Syntax.Tm_fvar fv,[]) when
               FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.fail_attr
               -> FStar_Pervasives_Native.Some ([], false)
           | (FStar_Syntax_Syntax.Tm_fvar fv,uu____19336) when
               FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.fail_attr
               ->
               (if warn
                then
                  FStar_Errors.log_issue at1.FStar_Syntax_Syntax.pos
                    (FStar_Errors.Warning_UnappliedFail,
                      "Found ill-applied fail, argument should be a non-empty list of integer literals")
                else ();
                FStar_Pervasives_Native.None)
           | (FStar_Syntax_Syntax.Tm_fvar fv,[]) when
               FStar_Syntax_Syntax.fv_eq_lid fv
                 FStar_Parser_Const.fail_lax_attr
               -> FStar_Pervasives_Native.Some ([], true)
           | uu____19384 -> FStar_Pervasives_Native.None)
  
let rec (desugar_effect :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.decl ->
      FStar_Parser_AST.qualifiers ->
        FStar_Ident.ident ->
          FStar_Parser_AST.binder Prims.list ->
            FStar_Parser_AST.term ->
              FStar_Parser_AST.decl Prims.list ->
                FStar_Parser_AST.term Prims.list ->
                  (FStar_Syntax_DsEnv.env,FStar_Syntax_Syntax.sigelt
                                            Prims.list)
                    FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      fun quals  ->
        fun eff_name  ->
          fun eff_binders  ->
            fun eff_typ  ->
              fun eff_decls  ->
                fun attrs  ->
                  let env0 = env  in
                  let monad_env =
                    FStar_Syntax_DsEnv.enter_monad_scope env eff_name  in
                  let uu____19539 = desugar_binders monad_env eff_binders  in
                  match uu____19539 with
                  | (env1,binders) ->
                      let eff_t = desugar_term env1 eff_typ  in
                      let for_free =
                        let uu____19560 =
                          let uu____19561 =
                            let uu____19568 =
                              FStar_Syntax_Util.arrow_formals eff_t  in
                            FStar_Pervasives_Native.fst uu____19568  in
                          FStar_List.length uu____19561  in
                        uu____19560 = (Prims.parse_int "1")  in
                      let mandatory_members =
                        let rr_members = ["repr"; "return"; "bind"]  in
                        if for_free
                        then rr_members
                        else
                          FStar_List.append rr_members
                            ["return_wp";
                            "bind_wp";
                            "if_then_else";
                            "ite_wp";
                            "stronger";
                            "close_wp";
                            "assert_p";
                            "assume_p";
                            "null_wp";
                            "trivial"]
                         in
                      let name_of_eff_decl decl =
                        match decl.FStar_Parser_AST.d with
                        | FStar_Parser_AST.Tycon
                            (uu____19612,(FStar_Parser_AST.TyconAbbrev
                                          (name,uu____19614,uu____19615,uu____19616),uu____19617)::[])
                            -> FStar_Ident.text_of_id name
                        | uu____19650 ->
                            failwith "Malformed effect member declaration."
                         in
                      let uu____19651 =
                        FStar_List.partition
                          (fun decl  ->
                             let uu____19663 = name_of_eff_decl decl  in
                             FStar_List.mem uu____19663 mandatory_members)
                          eff_decls
                         in
                      (match uu____19651 with
                       | (mandatory_members_decls,actions) ->
                           let uu____19680 =
                             FStar_All.pipe_right mandatory_members_decls
                               (FStar_List.fold_left
                                  (fun uu____19709  ->
                                     fun decl  ->
                                       match uu____19709 with
                                       | (env2,out) ->
                                           let uu____19729 =
                                             desugar_decl env2 decl  in
                                           (match uu____19729 with
                                            | (env3,ses) ->
                                                let uu____19742 =
                                                  let uu____19745 =
                                                    FStar_List.hd ses  in
                                                  uu____19745 :: out  in
                                                (env3, uu____19742)))
                                  (env1, []))
                              in
                           (match uu____19680 with
                            | (env2,decls) ->
                                let binders1 =
                                  FStar_Syntax_Subst.close_binders binders
                                   in
                                let actions_docs =
                                  FStar_All.pipe_right actions
                                    (FStar_List.map
                                       (fun d1  ->
                                          match d1.FStar_Parser_AST.d with
                                          | FStar_Parser_AST.Tycon
                                              (uu____19813,(FStar_Parser_AST.TyconAbbrev
                                                            (name,action_params,uu____19816,
                                                             {
                                                               FStar_Parser_AST.tm
                                                                 =
                                                                 FStar_Parser_AST.Construct
                                                                 (uu____19817,
                                                                  (def,uu____19819)::
                                                                  (cps_type,uu____19821)::[]);
                                                               FStar_Parser_AST.range
                                                                 =
                                                                 uu____19822;
                                                               FStar_Parser_AST.level
                                                                 =
                                                                 uu____19823;_}),doc1)::[])
                                              when Prims.op_Negation for_free
                                              ->
                                              let uu____19875 =
                                                desugar_binders env2
                                                  action_params
                                                 in
                                              (match uu____19875 with
                                               | (env3,action_params1) ->
                                                   let action_params2 =
                                                     FStar_Syntax_Subst.close_binders
                                                       action_params1
                                                      in
                                                   let uu____19895 =
                                                     let uu____19896 =
                                                       FStar_Syntax_DsEnv.qualify
                                                         env3 name
                                                        in
                                                     let uu____19897 =
                                                       let uu____19898 =
                                                         desugar_term env3
                                                           def
                                                          in
                                                       FStar_Syntax_Subst.close
                                                         (FStar_List.append
                                                            binders1
                                                            action_params2)
                                                         uu____19898
                                                        in
                                                     let uu____19903 =
                                                       let uu____19904 =
                                                         desugar_typ env3
                                                           cps_type
                                                          in
                                                       FStar_Syntax_Subst.close
                                                         (FStar_List.append
                                                            binders1
                                                            action_params2)
                                                         uu____19904
                                                        in
                                                     {
                                                       FStar_Syntax_Syntax.action_name
                                                         = uu____19896;
                                                       FStar_Syntax_Syntax.action_unqualified_name
                                                         = name;
                                                       FStar_Syntax_Syntax.action_univs
                                                         = [];
                                                       FStar_Syntax_Syntax.action_params
                                                         = action_params2;
                                                       FStar_Syntax_Syntax.action_defn
                                                         = uu____19897;
                                                       FStar_Syntax_Syntax.action_typ
                                                         = uu____19903
                                                     }  in
                                                   (uu____19895, doc1))
                                          | FStar_Parser_AST.Tycon
                                              (uu____19911,(FStar_Parser_AST.TyconAbbrev
                                                            (name,action_params,uu____19914,defn),doc1)::[])
                                              when for_free ->
                                              let uu____19949 =
                                                desugar_binders env2
                                                  action_params
                                                 in
                                              (match uu____19949 with
                                               | (env3,action_params1) ->
                                                   let action_params2 =
                                                     FStar_Syntax_Subst.close_binders
                                                       action_params1
                                                      in
                                                   let uu____19969 =
                                                     let uu____19970 =
                                                       FStar_Syntax_DsEnv.qualify
                                                         env3 name
                                                        in
                                                     let uu____19971 =
                                                       let uu____19972 =
                                                         desugar_term env3
                                                           defn
                                                          in
                                                       FStar_Syntax_Subst.close
                                                         (FStar_List.append
                                                            binders1
                                                            action_params2)
                                                         uu____19972
                                                        in
                                                     {
                                                       FStar_Syntax_Syntax.action_name
                                                         = uu____19970;
                                                       FStar_Syntax_Syntax.action_unqualified_name
                                                         = name;
                                                       FStar_Syntax_Syntax.action_univs
                                                         = [];
                                                       FStar_Syntax_Syntax.action_params
                                                         = action_params2;
                                                       FStar_Syntax_Syntax.action_defn
                                                         = uu____19971;
                                                       FStar_Syntax_Syntax.action_typ
                                                         =
                                                         FStar_Syntax_Syntax.tun
                                                     }  in
                                                   (uu____19969, doc1))
                                          | uu____19979 ->
                                              FStar_Errors.raise_error
                                                (FStar_Errors.Fatal_MalformedActionDeclaration,
                                                  "Malformed action declaration; if this is an \"effect for free\", just provide the direct-style declaration. If this is not an \"effect for free\", please provide a pair of the definition and its cps-type with arrows inserted in the right place (see examples).")
                                                d1.FStar_Parser_AST.drange))
                                   in
                                let actions1 =
                                  FStar_List.map FStar_Pervasives_Native.fst
                                    actions_docs
                                   in
                                let eff_t1 =
                                  FStar_Syntax_Subst.close binders1 eff_t  in
                                let lookup1 s =
                                  let l =
                                    let uu____20011 =
                                      FStar_Ident.mk_ident
                                        (s, (d.FStar_Parser_AST.drange))
                                       in
                                    FStar_Syntax_DsEnv.qualify env2
                                      uu____20011
                                     in
                                  let uu____20012 =
                                    let uu____20013 =
                                      FStar_Syntax_DsEnv.fail_or env2
                                        (FStar_Syntax_DsEnv.try_lookup_definition
                                           env2) l
                                       in
                                    FStar_All.pipe_left
                                      (FStar_Syntax_Subst.close binders1)
                                      uu____20013
                                     in
                                  ([], uu____20012)  in
                                let mname =
                                  FStar_Syntax_DsEnv.qualify env0 eff_name
                                   in
                                let qualifiers =
                                  FStar_List.map
                                    (trans_qual d.FStar_Parser_AST.drange
                                       (FStar_Pervasives_Native.Some mname))
                                    quals
                                   in
                                let se =
                                  if for_free
                                  then
                                    let dummy_tscheme =
                                      let uu____20030 =
                                        FStar_Syntax_Syntax.mk
                                          FStar_Syntax_Syntax.Tm_unknown
                                          FStar_Pervasives_Native.None
                                          FStar_Range.dummyRange
                                         in
                                      ([], uu____20030)  in
                                    let uu____20037 =
                                      let uu____20038 =
                                        let uu____20039 =
                                          let uu____20040 = lookup1 "repr"
                                             in
                                          FStar_Pervasives_Native.snd
                                            uu____20040
                                           in
                                        let uu____20049 = lookup1 "return"
                                           in
                                        let uu____20050 = lookup1 "bind"  in
                                        let uu____20051 =
                                          FStar_List.map (desugar_term env2)
                                            attrs
                                           in
                                        {
                                          FStar_Syntax_Syntax.cattributes =
                                            [];
                                          FStar_Syntax_Syntax.mname = mname;
                                          FStar_Syntax_Syntax.univs = [];
                                          FStar_Syntax_Syntax.binders =
                                            binders1;
                                          FStar_Syntax_Syntax.signature =
                                            eff_t1;
                                          FStar_Syntax_Syntax.ret_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.bind_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.if_then_else =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.ite_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.stronger =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.close_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.assert_p =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.assume_p =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.null_wp =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.trivial =
                                            dummy_tscheme;
                                          FStar_Syntax_Syntax.repr =
                                            uu____20039;
                                          FStar_Syntax_Syntax.return_repr =
                                            uu____20049;
                                          FStar_Syntax_Syntax.bind_repr =
                                            uu____20050;
                                          FStar_Syntax_Syntax.actions =
                                            actions1;
                                          FStar_Syntax_Syntax.eff_attrs =
                                            uu____20051
                                        }  in
                                      FStar_Syntax_Syntax.Sig_new_effect_for_free
                                        uu____20038
                                       in
                                    {
                                      FStar_Syntax_Syntax.sigel = uu____20037;
                                      FStar_Syntax_Syntax.sigrng =
                                        (d.FStar_Parser_AST.drange);
                                      FStar_Syntax_Syntax.sigquals =
                                        qualifiers;
                                      FStar_Syntax_Syntax.sigmeta =
                                        FStar_Syntax_Syntax.default_sigmeta;
                                      FStar_Syntax_Syntax.sigattrs = []
                                    }
                                  else
                                    (let rr =
                                       FStar_Util.for_some
                                         (fun uu___136_20057  ->
                                            match uu___136_20057 with
                                            | FStar_Syntax_Syntax.Reifiable 
                                                -> true
                                            | FStar_Syntax_Syntax.Reflectable
                                                uu____20058 -> true
                                            | uu____20059 -> false)
                                         qualifiers
                                        in
                                     let un_ts =
                                       ([], FStar_Syntax_Syntax.tun)  in
                                     let uu____20069 =
                                       let uu____20070 =
                                         let uu____20071 =
                                           lookup1 "return_wp"  in
                                         let uu____20072 = lookup1 "bind_wp"
                                            in
                                         let uu____20073 =
                                           lookup1 "if_then_else"  in
                                         let uu____20074 = lookup1 "ite_wp"
                                            in
                                         let uu____20075 = lookup1 "stronger"
                                            in
                                         let uu____20076 = lookup1 "close_wp"
                                            in
                                         let uu____20077 = lookup1 "assert_p"
                                            in
                                         let uu____20078 = lookup1 "assume_p"
                                            in
                                         let uu____20079 = lookup1 "null_wp"
                                            in
                                         let uu____20080 = lookup1 "trivial"
                                            in
                                         let uu____20081 =
                                           if rr
                                           then
                                             let uu____20082 = lookup1 "repr"
                                                in
                                             FStar_All.pipe_left
                                               FStar_Pervasives_Native.snd
                                               uu____20082
                                           else FStar_Syntax_Syntax.tun  in
                                         let uu____20098 =
                                           if rr
                                           then lookup1 "return"
                                           else un_ts  in
                                         let uu____20100 =
                                           if rr
                                           then lookup1 "bind"
                                           else un_ts  in
                                         let uu____20102 =
                                           FStar_List.map (desugar_term env2)
                                             attrs
                                            in
                                         {
                                           FStar_Syntax_Syntax.cattributes =
                                             [];
                                           FStar_Syntax_Syntax.mname = mname;
                                           FStar_Syntax_Syntax.univs = [];
                                           FStar_Syntax_Syntax.binders =
                                             binders1;
                                           FStar_Syntax_Syntax.signature =
                                             eff_t1;
                                           FStar_Syntax_Syntax.ret_wp =
                                             uu____20071;
                                           FStar_Syntax_Syntax.bind_wp =
                                             uu____20072;
                                           FStar_Syntax_Syntax.if_then_else =
                                             uu____20073;
                                           FStar_Syntax_Syntax.ite_wp =
                                             uu____20074;
                                           FStar_Syntax_Syntax.stronger =
                                             uu____20075;
                                           FStar_Syntax_Syntax.close_wp =
                                             uu____20076;
                                           FStar_Syntax_Syntax.assert_p =
                                             uu____20077;
                                           FStar_Syntax_Syntax.assume_p =
                                             uu____20078;
                                           FStar_Syntax_Syntax.null_wp =
                                             uu____20079;
                                           FStar_Syntax_Syntax.trivial =
                                             uu____20080;
                                           FStar_Syntax_Syntax.repr =
                                             uu____20081;
                                           FStar_Syntax_Syntax.return_repr =
                                             uu____20098;
                                           FStar_Syntax_Syntax.bind_repr =
                                             uu____20100;
                                           FStar_Syntax_Syntax.actions =
                                             actions1;
                                           FStar_Syntax_Syntax.eff_attrs =
                                             uu____20102
                                         }  in
                                       FStar_Syntax_Syntax.Sig_new_effect
                                         uu____20070
                                        in
                                     {
                                       FStar_Syntax_Syntax.sigel =
                                         uu____20069;
                                       FStar_Syntax_Syntax.sigrng =
                                         (d.FStar_Parser_AST.drange);
                                       FStar_Syntax_Syntax.sigquals =
                                         qualifiers;
                                       FStar_Syntax_Syntax.sigmeta =
                                         FStar_Syntax_Syntax.default_sigmeta;
                                       FStar_Syntax_Syntax.sigattrs = []
                                     })
                                   in
                                let env3 =
                                  FStar_Syntax_DsEnv.push_sigelt env0 se  in
                                let env4 =
                                  FStar_Syntax_DsEnv.push_doc env3 mname
                                    d.FStar_Parser_AST.doc
                                   in
                                let env5 =
                                  FStar_All.pipe_right actions_docs
                                    (FStar_List.fold_left
                                       (fun env5  ->
                                          fun uu____20128  ->
                                            match uu____20128 with
                                            | (a,doc1) ->
                                                let env6 =
                                                  let uu____20142 =
                                                    FStar_Syntax_Util.action_as_lb
                                                      mname a
                                                      (a.FStar_Syntax_Syntax.action_defn).FStar_Syntax_Syntax.pos
                                                     in
                                                  FStar_Syntax_DsEnv.push_sigelt
                                                    env5 uu____20142
                                                   in
                                                FStar_Syntax_DsEnv.push_doc
                                                  env6
                                                  a.FStar_Syntax_Syntax.action_name
                                                  doc1) env4)
                                   in
                                let env6 =
                                  push_reflect_effect env5 qualifiers mname
                                    d.FStar_Parser_AST.drange
                                   in
                                let env7 =
                                  FStar_Syntax_DsEnv.push_doc env6 mname
                                    d.FStar_Parser_AST.doc
                                   in
                                (env7, [se])))

and (desugar_redefine_effect :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.decl ->
      (FStar_Ident.lident FStar_Pervasives_Native.option ->
         FStar_Parser_AST.qualifier -> FStar_Syntax_Syntax.qualifier)
        ->
        FStar_Parser_AST.qualifier Prims.list ->
          FStar_Ident.ident ->
            FStar_Parser_AST.binder Prims.list ->
              FStar_Parser_AST.term ->
                (FStar_Syntax_DsEnv.env,FStar_Syntax_Syntax.sigelt Prims.list)
                  FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      fun trans_qual1  ->
        fun quals  ->
          fun eff_name  ->
            fun eff_binders  ->
              fun defn  ->
                let env0 = env  in
                let env1 = FStar_Syntax_DsEnv.enter_monad_scope env eff_name
                   in
                let uu____20166 = desugar_binders env1 eff_binders  in
                match uu____20166 with
                | (env2,binders) ->
                    let uu____20185 =
                      let uu____20204 = head_and_args defn  in
                      match uu____20204 with
                      | (head1,args) ->
                          let lid =
                            match head1.FStar_Parser_AST.tm with
                            | FStar_Parser_AST.Name l -> l
                            | uu____20249 ->
                                let uu____20250 =
                                  let uu____20255 =
                                    let uu____20256 =
                                      let uu____20257 =
                                        FStar_Parser_AST.term_to_string head1
                                         in
                                      Prims.strcat uu____20257 " not found"
                                       in
                                    Prims.strcat "Effect " uu____20256  in
                                  (FStar_Errors.Fatal_EffectNotFound,
                                    uu____20255)
                                   in
                                FStar_Errors.raise_error uu____20250
                                  d.FStar_Parser_AST.drange
                             in
                          let ed =
                            FStar_Syntax_DsEnv.fail_or env2
                              (FStar_Syntax_DsEnv.try_lookup_effect_defn env2)
                              lid
                             in
                          let uu____20259 =
                            match FStar_List.rev args with
                            | (last_arg,uu____20289)::args_rev ->
                                let uu____20301 =
                                  let uu____20302 = unparen last_arg  in
                                  uu____20302.FStar_Parser_AST.tm  in
                                (match uu____20301 with
                                 | FStar_Parser_AST.Attributes ts ->
                                     (ts, (FStar_List.rev args_rev))
                                 | uu____20330 -> ([], args))
                            | uu____20339 -> ([], args)  in
                          (match uu____20259 with
                           | (cattributes,args1) ->
                               let uu____20390 = desugar_args env2 args1  in
                               let uu____20399 =
                                 desugar_attributes env2 cattributes  in
                               (lid, ed, uu____20390, uu____20399))
                       in
                    (match uu____20185 with
                     | (ed_lid,ed,args,cattributes) ->
                         let binders1 =
                           FStar_Syntax_Subst.close_binders binders  in
                         (if
                            (FStar_List.length args) <>
                              (FStar_List.length
                                 ed.FStar_Syntax_Syntax.binders)
                          then
                            FStar_Errors.raise_error
                              (FStar_Errors.Fatal_ArgumentLengthMismatch,
                                "Unexpected number of arguments to effect constructor")
                              defn.FStar_Parser_AST.range
                          else ();
                          (let uu____20455 =
                             FStar_Syntax_Subst.open_term'
                               ed.FStar_Syntax_Syntax.binders
                               FStar_Syntax_Syntax.t_unit
                              in
                           match uu____20455 with
                           | (ed_binders,uu____20469,ed_binders_opening) ->
                               let sub1 uu____20482 =
                                 match uu____20482 with
                                 | (us,x) ->
                                     let x1 =
                                       let uu____20496 =
                                         FStar_Syntax_Subst.shift_subst
                                           (FStar_List.length us)
                                           ed_binders_opening
                                          in
                                       FStar_Syntax_Subst.subst uu____20496 x
                                        in
                                     let s =
                                       FStar_Syntax_Util.subst_of_list
                                         ed_binders args
                                        in
                                     let uu____20500 =
                                       let uu____20501 =
                                         FStar_Syntax_Subst.subst s x1  in
                                       (us, uu____20501)  in
                                     FStar_Syntax_Subst.close_tscheme
                                       binders1 uu____20500
                                  in
                               let mname =
                                 FStar_Syntax_DsEnv.qualify env0 eff_name  in
                               let ed1 =
                                 let uu____20506 =
                                   let uu____20507 =
                                     sub1
                                       ([],
                                         (ed.FStar_Syntax_Syntax.signature))
                                      in
                                   FStar_Pervasives_Native.snd uu____20507
                                    in
                                 let uu____20518 =
                                   sub1 ed.FStar_Syntax_Syntax.ret_wp  in
                                 let uu____20519 =
                                   sub1 ed.FStar_Syntax_Syntax.bind_wp  in
                                 let uu____20520 =
                                   sub1 ed.FStar_Syntax_Syntax.if_then_else
                                    in
                                 let uu____20521 =
                                   sub1 ed.FStar_Syntax_Syntax.ite_wp  in
                                 let uu____20522 =
                                   sub1 ed.FStar_Syntax_Syntax.stronger  in
                                 let uu____20523 =
                                   sub1 ed.FStar_Syntax_Syntax.close_wp  in
                                 let uu____20524 =
                                   sub1 ed.FStar_Syntax_Syntax.assert_p  in
                                 let uu____20525 =
                                   sub1 ed.FStar_Syntax_Syntax.assume_p  in
                                 let uu____20526 =
                                   sub1 ed.FStar_Syntax_Syntax.null_wp  in
                                 let uu____20527 =
                                   sub1 ed.FStar_Syntax_Syntax.trivial  in
                                 let uu____20528 =
                                   let uu____20529 =
                                     sub1 ([], (ed.FStar_Syntax_Syntax.repr))
                                      in
                                   FStar_Pervasives_Native.snd uu____20529
                                    in
                                 let uu____20540 =
                                   sub1 ed.FStar_Syntax_Syntax.return_repr
                                    in
                                 let uu____20541 =
                                   sub1 ed.FStar_Syntax_Syntax.bind_repr  in
                                 let uu____20542 =
                                   FStar_List.map
                                     (fun action  ->
                                        let uu____20550 =
                                          FStar_Syntax_DsEnv.qualify env2
                                            action.FStar_Syntax_Syntax.action_unqualified_name
                                           in
                                        let uu____20551 =
                                          let uu____20552 =
                                            sub1
                                              ([],
                                                (action.FStar_Syntax_Syntax.action_defn))
                                             in
                                          FStar_Pervasives_Native.snd
                                            uu____20552
                                           in
                                        let uu____20563 =
                                          let uu____20564 =
                                            sub1
                                              ([],
                                                (action.FStar_Syntax_Syntax.action_typ))
                                             in
                                          FStar_Pervasives_Native.snd
                                            uu____20564
                                           in
                                        {
                                          FStar_Syntax_Syntax.action_name =
                                            uu____20550;
                                          FStar_Syntax_Syntax.action_unqualified_name
                                            =
                                            (action.FStar_Syntax_Syntax.action_unqualified_name);
                                          FStar_Syntax_Syntax.action_univs =
                                            (action.FStar_Syntax_Syntax.action_univs);
                                          FStar_Syntax_Syntax.action_params =
                                            (action.FStar_Syntax_Syntax.action_params);
                                          FStar_Syntax_Syntax.action_defn =
                                            uu____20551;
                                          FStar_Syntax_Syntax.action_typ =
                                            uu____20563
                                        }) ed.FStar_Syntax_Syntax.actions
                                    in
                                 {
                                   FStar_Syntax_Syntax.cattributes =
                                     cattributes;
                                   FStar_Syntax_Syntax.mname = mname;
                                   FStar_Syntax_Syntax.univs =
                                     (ed.FStar_Syntax_Syntax.univs);
                                   FStar_Syntax_Syntax.binders = binders1;
                                   FStar_Syntax_Syntax.signature =
                                     uu____20506;
                                   FStar_Syntax_Syntax.ret_wp = uu____20518;
                                   FStar_Syntax_Syntax.bind_wp = uu____20519;
                                   FStar_Syntax_Syntax.if_then_else =
                                     uu____20520;
                                   FStar_Syntax_Syntax.ite_wp = uu____20521;
                                   FStar_Syntax_Syntax.stronger = uu____20522;
                                   FStar_Syntax_Syntax.close_wp = uu____20523;
                                   FStar_Syntax_Syntax.assert_p = uu____20524;
                                   FStar_Syntax_Syntax.assume_p = uu____20525;
                                   FStar_Syntax_Syntax.null_wp = uu____20526;
                                   FStar_Syntax_Syntax.trivial = uu____20527;
                                   FStar_Syntax_Syntax.repr = uu____20528;
                                   FStar_Syntax_Syntax.return_repr =
                                     uu____20540;
                                   FStar_Syntax_Syntax.bind_repr =
                                     uu____20541;
                                   FStar_Syntax_Syntax.actions = uu____20542;
                                   FStar_Syntax_Syntax.eff_attrs =
                                     (ed.FStar_Syntax_Syntax.eff_attrs)
                                 }  in
                               let se =
                                 let for_free =
                                   let uu____20577 =
                                     let uu____20578 =
                                       let uu____20585 =
                                         FStar_Syntax_Util.arrow_formals
                                           ed1.FStar_Syntax_Syntax.signature
                                          in
                                       FStar_Pervasives_Native.fst
                                         uu____20585
                                        in
                                     FStar_List.length uu____20578  in
                                   uu____20577 = (Prims.parse_int "1")  in
                                 let uu____20614 =
                                   let uu____20617 =
                                     trans_qual1
                                       (FStar_Pervasives_Native.Some mname)
                                      in
                                   FStar_List.map uu____20617 quals  in
                                 {
                                   FStar_Syntax_Syntax.sigel =
                                     (if for_free
                                      then
                                        FStar_Syntax_Syntax.Sig_new_effect_for_free
                                          ed1
                                      else
                                        FStar_Syntax_Syntax.Sig_new_effect
                                          ed1);
                                   FStar_Syntax_Syntax.sigrng =
                                     (d.FStar_Parser_AST.drange);
                                   FStar_Syntax_Syntax.sigquals = uu____20614;
                                   FStar_Syntax_Syntax.sigmeta =
                                     FStar_Syntax_Syntax.default_sigmeta;
                                   FStar_Syntax_Syntax.sigattrs = []
                                 }  in
                               let monad_env = env2  in
                               let env3 =
                                 FStar_Syntax_DsEnv.push_sigelt env0 se  in
                               let env4 =
                                 FStar_Syntax_DsEnv.push_doc env3 ed_lid
                                   d.FStar_Parser_AST.doc
                                  in
                               let env5 =
                                 FStar_All.pipe_right
                                   ed1.FStar_Syntax_Syntax.actions
                                   (FStar_List.fold_left
                                      (fun env5  ->
                                         fun a  ->
                                           let doc1 =
                                             FStar_Syntax_DsEnv.try_lookup_doc
                                               env5
                                               a.FStar_Syntax_Syntax.action_name
                                              in
                                           let env6 =
                                             let uu____20639 =
                                               FStar_Syntax_Util.action_as_lb
                                                 mname a
                                                 (a.FStar_Syntax_Syntax.action_defn).FStar_Syntax_Syntax.pos
                                                in
                                             FStar_Syntax_DsEnv.push_sigelt
                                               env5 uu____20639
                                              in
                                           FStar_Syntax_DsEnv.push_doc env6
                                             a.FStar_Syntax_Syntax.action_name
                                             doc1) env4)
                                  in
                               let env6 =
                                 let uu____20641 =
                                   FStar_All.pipe_right quals
                                     (FStar_List.contains
                                        FStar_Parser_AST.Reflectable)
                                    in
                                 if uu____20641
                                 then
                                   let reflect_lid =
                                     let uu____20645 =
                                       FStar_Ident.id_of_text "reflect"  in
                                     FStar_All.pipe_right uu____20645
                                       (FStar_Syntax_DsEnv.qualify monad_env)
                                      in
                                   let quals1 =
                                     [FStar_Syntax_Syntax.Assumption;
                                     FStar_Syntax_Syntax.Reflectable mname]
                                      in
                                   let refl_decl =
                                     {
                                       FStar_Syntax_Syntax.sigel =
                                         (FStar_Syntax_Syntax.Sig_declare_typ
                                            (reflect_lid, [],
                                              FStar_Syntax_Syntax.tun));
                                       FStar_Syntax_Syntax.sigrng =
                                         (d.FStar_Parser_AST.drange);
                                       FStar_Syntax_Syntax.sigquals = quals1;
                                       FStar_Syntax_Syntax.sigmeta =
                                         FStar_Syntax_Syntax.default_sigmeta;
                                       FStar_Syntax_Syntax.sigattrs = []
                                     }  in
                                   FStar_Syntax_DsEnv.push_sigelt env5
                                     refl_decl
                                 else env5  in
                               let env7 =
                                 FStar_Syntax_DsEnv.push_doc env6 mname
                                   d.FStar_Parser_AST.doc
                                  in
                               (env7, [se]))))

and (mk_comment_attr :
  FStar_Parser_AST.decl ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun d  ->
    let uu____20657 =
      match d.FStar_Parser_AST.doc with
      | FStar_Pervasives_Native.None  -> ("", [])
      | FStar_Pervasives_Native.Some fsdoc -> fsdoc  in
    match uu____20657 with
    | (text,kv) ->
        let summary =
          match FStar_List.assoc "summary" kv with
          | FStar_Pervasives_Native.None  -> ""
          | FStar_Pervasives_Native.Some s ->
              Prims.strcat "  " (Prims.strcat s "\n")
           in
        let pp =
          match FStar_List.assoc "type" kv with
          | FStar_Pervasives_Native.Some uu____20708 ->
              let uu____20709 =
                let uu____20710 =
                  FStar_Parser_ToDocument.signature_to_document d  in
                FStar_Pprint.pretty_string 0.95 (Prims.parse_int "80")
                  uu____20710
                 in
              Prims.strcat "\n  " uu____20709
          | uu____20711 -> ""  in
        let other =
          FStar_List.filter_map
            (fun uu____20724  ->
               match uu____20724 with
               | (k,v1) ->
                   if (k <> "summary") && (k <> "type")
                   then
                     FStar_Pervasives_Native.Some
                       (Prims.strcat k (Prims.strcat ": " v1))
                   else FStar_Pervasives_Native.None) kv
           in
        let other1 =
          if other <> []
          then Prims.strcat (FStar_String.concat "\n" other) "\n"
          else ""  in
        let str =
          Prims.strcat summary (Prims.strcat pp (Prims.strcat other1 text))
           in
        let fv =
          let uu____20742 = FStar_Ident.lid_of_str "FStar.Pervasives.Comment"
             in
          FStar_Syntax_Syntax.fvar uu____20742
            FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
           in
        let arg = FStar_Syntax_Util.exp_string str  in
        let uu____20744 =
          let uu____20753 = FStar_Syntax_Syntax.as_arg arg  in [uu____20753]
           in
        FStar_Syntax_Util.mk_app fv uu____20744

and (desugar_decl :
  env_t ->
    FStar_Parser_AST.decl ->
      (env_t,FStar_Syntax_Syntax.sigelts) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      let uu____20760 = desugar_decl_noattrs env d  in
      match uu____20760 with
      | (env1,sigelts) ->
          let attrs = d.FStar_Parser_AST.attrs  in
          let attrs1 = FStar_List.map (desugar_term env1) attrs  in
          let attrs2 =
            let uu____20780 = mk_comment_attr d  in uu____20780 :: attrs1  in
          let uu____20785 =
            FStar_List.mapi
              (fun i  ->
                 fun sigelt  ->
                   if i = (Prims.parse_int "0")
                   then
                     let uu___163_20793 = sigelt  in
                     {
                       FStar_Syntax_Syntax.sigel =
                         (uu___163_20793.FStar_Syntax_Syntax.sigel);
                       FStar_Syntax_Syntax.sigrng =
                         (uu___163_20793.FStar_Syntax_Syntax.sigrng);
                       FStar_Syntax_Syntax.sigquals =
                         (uu___163_20793.FStar_Syntax_Syntax.sigquals);
                       FStar_Syntax_Syntax.sigmeta =
                         (uu___163_20793.FStar_Syntax_Syntax.sigmeta);
                       FStar_Syntax_Syntax.sigattrs = attrs2
                     }
                   else
                     (let uu___164_20795 = sigelt  in
                      let uu____20796 =
                        FStar_List.filter
                          (fun at1  ->
                             let uu____20802 = get_fail_attr false at1  in
                             FStar_Option.isNone uu____20802) attrs2
                         in
                      {
                        FStar_Syntax_Syntax.sigel =
                          (uu___164_20795.FStar_Syntax_Syntax.sigel);
                        FStar_Syntax_Syntax.sigrng =
                          (uu___164_20795.FStar_Syntax_Syntax.sigrng);
                        FStar_Syntax_Syntax.sigquals =
                          (uu___164_20795.FStar_Syntax_Syntax.sigquals);
                        FStar_Syntax_Syntax.sigmeta =
                          (uu___164_20795.FStar_Syntax_Syntax.sigmeta);
                        FStar_Syntax_Syntax.sigattrs = uu____20796
                      })) sigelts
             in
          (env1, uu____20785)

and (desugar_decl_noattrs :
  env_t ->
    FStar_Parser_AST.decl ->
      (env_t,FStar_Syntax_Syntax.sigelts) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun d  ->
      let trans_qual1 = trans_qual d.FStar_Parser_AST.drange  in
      match d.FStar_Parser_AST.d with
      | FStar_Parser_AST.Pragma p ->
          let se =
            {
              FStar_Syntax_Syntax.sigel =
                (FStar_Syntax_Syntax.Sig_pragma (trans_pragma p));
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = [];
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          (if p = FStar_Parser_AST.LightOff
           then FStar_Options.set_ml_ish ()
           else ();
           (env, [se]))
      | FStar_Parser_AST.Fsdoc uu____20846 -> (env, [])
      | FStar_Parser_AST.TopLevelModule id1 -> (env, [])
      | FStar_Parser_AST.Open lid ->
          let env1 = FStar_Syntax_DsEnv.push_namespace env lid  in (env1, [])
      | FStar_Parser_AST.Include lid ->
          let env1 = FStar_Syntax_DsEnv.push_include env lid  in (env1, [])
      | FStar_Parser_AST.ModuleAbbrev (x,l) ->
          let uu____20862 = FStar_Syntax_DsEnv.push_module_abbrev env x l  in
          (uu____20862, [])
      | FStar_Parser_AST.Tycon (is_effect,tcs) ->
          let quals =
            if is_effect
            then FStar_Parser_AST.Effect_qual :: (d.FStar_Parser_AST.quals)
            else d.FStar_Parser_AST.quals  in
          let tcs1 =
            FStar_List.map
              (fun uu____20901  ->
                 match uu____20901 with | (x,uu____20909) -> x) tcs
             in
          let uu____20914 =
            FStar_List.map (trans_qual1 FStar_Pervasives_Native.None) quals
             in
          desugar_tycon env d uu____20914 tcs1
      | FStar_Parser_AST.TopLevelLet (isrec,lets) ->
          let quals = d.FStar_Parser_AST.quals  in
          let expand_toplevel_pattern =
            (isrec = FStar_Parser_AST.NoLetQualifier) &&
              (match lets with
               | ({
                    FStar_Parser_AST.pat = FStar_Parser_AST.PatOp uu____20936;
                    FStar_Parser_AST.prange = uu____20937;_},uu____20938)::[]
                   -> false
               | ({
                    FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                      uu____20947;
                    FStar_Parser_AST.prange = uu____20948;_},uu____20949)::[]
                   -> false
               | ({
                    FStar_Parser_AST.pat = FStar_Parser_AST.PatAscribed
                      ({
                         FStar_Parser_AST.pat = FStar_Parser_AST.PatVar
                           uu____20964;
                         FStar_Parser_AST.prange = uu____20965;_},uu____20966);
                    FStar_Parser_AST.prange = uu____20967;_},uu____20968)::[]
                   -> false
               | (p,uu____20996)::[] ->
                   let uu____21005 = is_app_pattern p  in
                   Prims.op_Negation uu____21005
               | uu____21006 -> false)
             in
          if Prims.op_Negation expand_toplevel_pattern
          then
            let lets1 =
              FStar_List.map (fun x  -> (FStar_Pervasives_Native.None, x))
                lets
               in
            let as_inner_let =
              FStar_Parser_AST.mk_term
                (FStar_Parser_AST.Let
                   (isrec, lets1,
                     (FStar_Parser_AST.mk_term
                        (FStar_Parser_AST.Const FStar_Const.Const_unit)
                        d.FStar_Parser_AST.drange FStar_Parser_AST.Expr)))
                d.FStar_Parser_AST.drange FStar_Parser_AST.Expr
               in
            let uu____21079 = desugar_term_maybe_top true env as_inner_let
               in
            (match uu____21079 with
             | (ds_lets,aq) ->
                 (check_no_aq aq;
                  (let uu____21091 =
                     let uu____21092 =
                       FStar_All.pipe_left FStar_Syntax_Subst.compress
                         ds_lets
                        in
                     uu____21092.FStar_Syntax_Syntax.n  in
                   match uu____21091 with
                   | FStar_Syntax_Syntax.Tm_let (lbs,uu____21100) ->
                       let fvs =
                         FStar_All.pipe_right
                           (FStar_Pervasives_Native.snd lbs)
                           (FStar_List.map
                              (fun lb  ->
                                 FStar_Util.right
                                   lb.FStar_Syntax_Syntax.lbname))
                          in
                       let quals1 =
                         match quals with
                         | uu____21133::uu____21134 ->
                             FStar_List.map
                               (trans_qual1 FStar_Pervasives_Native.None)
                               quals
                         | uu____21137 ->
                             FStar_All.pipe_right
                               (FStar_Pervasives_Native.snd lbs)
                               (FStar_List.collect
                                  (fun uu___137_21152  ->
                                     match uu___137_21152 with
                                     | {
                                         FStar_Syntax_Syntax.lbname =
                                           FStar_Util.Inl uu____21155;
                                         FStar_Syntax_Syntax.lbunivs =
                                           uu____21156;
                                         FStar_Syntax_Syntax.lbtyp =
                                           uu____21157;
                                         FStar_Syntax_Syntax.lbeff =
                                           uu____21158;
                                         FStar_Syntax_Syntax.lbdef =
                                           uu____21159;
                                         FStar_Syntax_Syntax.lbattrs =
                                           uu____21160;
                                         FStar_Syntax_Syntax.lbpos =
                                           uu____21161;_}
                                         -> []
                                     | {
                                         FStar_Syntax_Syntax.lbname =
                                           FStar_Util.Inr fv;
                                         FStar_Syntax_Syntax.lbunivs =
                                           uu____21173;
                                         FStar_Syntax_Syntax.lbtyp =
                                           uu____21174;
                                         FStar_Syntax_Syntax.lbeff =
                                           uu____21175;
                                         FStar_Syntax_Syntax.lbdef =
                                           uu____21176;
                                         FStar_Syntax_Syntax.lbattrs =
                                           uu____21177;
                                         FStar_Syntax_Syntax.lbpos =
                                           uu____21178;_}
                                         ->
                                         FStar_Syntax_DsEnv.lookup_letbinding_quals
                                           env
                                           (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
                          in
                       let quals2 =
                         let uu____21192 =
                           FStar_All.pipe_right lets1
                             (FStar_Util.for_some
                                (fun uu____21223  ->
                                   match uu____21223 with
                                   | (uu____21236,(uu____21237,t)) ->
                                       t.FStar_Parser_AST.level =
                                         FStar_Parser_AST.Formula))
                            in
                         if uu____21192
                         then FStar_Syntax_Syntax.Logic :: quals1
                         else quals1  in
                       let lbs1 =
                         let uu____21261 =
                           FStar_All.pipe_right quals2
                             (FStar_List.contains
                                FStar_Syntax_Syntax.Abstract)
                            in
                         if uu____21261
                         then
                           let uu____21270 =
                             FStar_All.pipe_right
                               (FStar_Pervasives_Native.snd lbs)
                               (FStar_List.map
                                  (fun lb  ->
                                     let fv =
                                       FStar_Util.right
                                         lb.FStar_Syntax_Syntax.lbname
                                        in
                                     let uu___165_21284 = lb  in
                                     {
                                       FStar_Syntax_Syntax.lbname =
                                         (FStar_Util.Inr
                                            (let uu___166_21286 = fv  in
                                             {
                                               FStar_Syntax_Syntax.fv_name =
                                                 (uu___166_21286.FStar_Syntax_Syntax.fv_name);
                                               FStar_Syntax_Syntax.fv_delta =
                                                 (FStar_Syntax_Syntax.Delta_abstract
                                                    (fv.FStar_Syntax_Syntax.fv_delta));
                                               FStar_Syntax_Syntax.fv_qual =
                                                 (uu___166_21286.FStar_Syntax_Syntax.fv_qual)
                                             }));
                                       FStar_Syntax_Syntax.lbunivs =
                                         (uu___165_21284.FStar_Syntax_Syntax.lbunivs);
                                       FStar_Syntax_Syntax.lbtyp =
                                         (uu___165_21284.FStar_Syntax_Syntax.lbtyp);
                                       FStar_Syntax_Syntax.lbeff =
                                         (uu___165_21284.FStar_Syntax_Syntax.lbeff);
                                       FStar_Syntax_Syntax.lbdef =
                                         (uu___165_21284.FStar_Syntax_Syntax.lbdef);
                                       FStar_Syntax_Syntax.lbattrs =
                                         (uu___165_21284.FStar_Syntax_Syntax.lbattrs);
                                       FStar_Syntax_Syntax.lbpos =
                                         (uu___165_21284.FStar_Syntax_Syntax.lbpos)
                                     }))
                              in
                           ((FStar_Pervasives_Native.fst lbs), uu____21270)
                         else lbs  in
                       let names1 =
                         FStar_All.pipe_right fvs
                           (FStar_List.map
                              (fun fv  ->
                                 (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v))
                          in
                       let attrs =
                         FStar_List.map (desugar_term env)
                           d.FStar_Parser_AST.attrs
                          in
                       let s =
                         {
                           FStar_Syntax_Syntax.sigel =
                             (FStar_Syntax_Syntax.Sig_let (lbs1, names1));
                           FStar_Syntax_Syntax.sigrng =
                             (d.FStar_Parser_AST.drange);
                           FStar_Syntax_Syntax.sigquals = quals2;
                           FStar_Syntax_Syntax.sigmeta =
                             FStar_Syntax_Syntax.default_sigmeta;
                           FStar_Syntax_Syntax.sigattrs = attrs
                         }  in
                       let env1 = FStar_Syntax_DsEnv.push_sigelt env s  in
                       let env2 =
                         FStar_List.fold_left
                           (fun env2  ->
                              fun id1  ->
                                FStar_Syntax_DsEnv.push_doc env2 id1
                                  d.FStar_Parser_AST.doc) env1 names1
                          in
                       (env2, [s])
                   | uu____21321 ->
                       failwith "Desugaring a let did not produce a let")))
          else
            (let uu____21327 =
               match lets with
               | (pat,body)::[] -> (pat, body)
               | uu____21346 ->
                   failwith
                     "expand_toplevel_pattern should only allow single definition lets"
                in
             match uu____21327 with
             | (pat,body) ->
                 let fresh_toplevel_name =
                   FStar_Ident.gen FStar_Range.dummyRange  in
                 let fresh_pat =
                   let var_pat =
                     FStar_Parser_AST.mk_pattern
                       (FStar_Parser_AST.PatVar
                          (fresh_toplevel_name, FStar_Pervasives_Native.None))
                       FStar_Range.dummyRange
                      in
                   match pat.FStar_Parser_AST.pat with
                   | FStar_Parser_AST.PatAscribed (pat1,ty) ->
                       let uu___167_21382 = pat1  in
                       {
                         FStar_Parser_AST.pat =
                           (FStar_Parser_AST.PatAscribed (var_pat, ty));
                         FStar_Parser_AST.prange =
                           (uu___167_21382.FStar_Parser_AST.prange)
                       }
                   | uu____21389 -> var_pat  in
                 let main_let =
                   desugar_decl env
                     (let uu___168_21396 = d  in
                      {
                        FStar_Parser_AST.d =
                          (FStar_Parser_AST.TopLevelLet
                             (isrec, [(fresh_pat, body)]));
                        FStar_Parser_AST.drange =
                          (uu___168_21396.FStar_Parser_AST.drange);
                        FStar_Parser_AST.doc =
                          (uu___168_21396.FStar_Parser_AST.doc);
                        FStar_Parser_AST.quals = (FStar_Parser_AST.Private ::
                          (d.FStar_Parser_AST.quals));
                        FStar_Parser_AST.attrs =
                          (uu___168_21396.FStar_Parser_AST.attrs)
                      })
                    in
                 let build_projection uu____21432 id1 =
                   match uu____21432 with
                   | (env1,ses) ->
                       let main =
                         let uu____21453 =
                           let uu____21454 =
                             FStar_Ident.lid_of_ids [fresh_toplevel_name]  in
                           FStar_Parser_AST.Var uu____21454  in
                         FStar_Parser_AST.mk_term uu____21453
                           FStar_Range.dummyRange FStar_Parser_AST.Expr
                          in
                       let lid = FStar_Ident.lid_of_ids [id1]  in
                       let projectee =
                         FStar_Parser_AST.mk_term (FStar_Parser_AST.Var lid)
                           FStar_Range.dummyRange FStar_Parser_AST.Expr
                          in
                       let body1 =
                         FStar_Parser_AST.mk_term
                           (FStar_Parser_AST.Match
                              (main,
                                [(pat, FStar_Pervasives_Native.None,
                                   projectee)])) FStar_Range.dummyRange
                           FStar_Parser_AST.Expr
                          in
                       let bv_pat =
                         FStar_Parser_AST.mk_pattern
                           (FStar_Parser_AST.PatVar
                              (id1, FStar_Pervasives_Native.None))
                           FStar_Range.dummyRange
                          in
                       let id_decl =
                         FStar_Parser_AST.mk_decl
                           (FStar_Parser_AST.TopLevelLet
                              (FStar_Parser_AST.NoLetQualifier,
                                [(bv_pat, body1)])) FStar_Range.dummyRange []
                          in
                       let uu____21504 = desugar_decl env1 id_decl  in
                       (match uu____21504 with
                        | (env2,ses') -> (env2, (FStar_List.append ses ses')))
                    in
                 let bvs =
                   let uu____21522 = gather_pattern_bound_vars pat  in
                   FStar_All.pipe_right uu____21522 FStar_Util.set_elements
                    in
                 FStar_List.fold_left build_projection main_let bvs)
      | FStar_Parser_AST.Main t ->
          let e = desugar_term env t  in
          let se =
            {
              FStar_Syntax_Syntax.sigel = (FStar_Syntax_Syntax.Sig_main e);
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = [];
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          (env, [se])
      | FStar_Parser_AST.Assume (id1,t) ->
          let f = desugar_formula env t  in
          let lid = FStar_Syntax_DsEnv.qualify env id1  in
          let env1 =
            FStar_Syntax_DsEnv.push_doc env lid d.FStar_Parser_AST.doc  in
          (env1,
            [{
               FStar_Syntax_Syntax.sigel =
                 (FStar_Syntax_Syntax.Sig_assume (lid, [], f));
               FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
               FStar_Syntax_Syntax.sigquals =
                 [FStar_Syntax_Syntax.Assumption];
               FStar_Syntax_Syntax.sigmeta =
                 FStar_Syntax_Syntax.default_sigmeta;
               FStar_Syntax_Syntax.sigattrs = []
             }])
      | FStar_Parser_AST.Val (id1,t) ->
          let quals = d.FStar_Parser_AST.quals  in
          let t1 =
            let uu____21553 = close_fun env t  in
            desugar_term env uu____21553  in
          let quals1 =
            let uu____21557 =
              (FStar_Syntax_DsEnv.iface env) &&
                (FStar_Syntax_DsEnv.admitted_iface env)
               in
            if uu____21557
            then FStar_Parser_AST.Assumption :: quals
            else quals  in
          let lid = FStar_Syntax_DsEnv.qualify env id1  in
          let se =
            let uu____21563 =
              FStar_List.map (trans_qual1 FStar_Pervasives_Native.None)
                quals1
               in
            {
              FStar_Syntax_Syntax.sigel =
                (FStar_Syntax_Syntax.Sig_declare_typ (lid, [], t1));
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = uu____21563;
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let env1 = FStar_Syntax_DsEnv.push_sigelt env se  in
          let env2 =
            FStar_Syntax_DsEnv.push_doc env1 lid d.FStar_Parser_AST.doc  in
          (env2, [se])
      | FStar_Parser_AST.Exception (id1,FStar_Pervasives_Native.None ) ->
          let uu____21575 =
            FStar_Syntax_DsEnv.fail_or env
              (FStar_Syntax_DsEnv.try_lookup_lid env)
              FStar_Parser_Const.exn_lid
             in
          (match uu____21575 with
           | (t,uu____21589) ->
               let l = FStar_Syntax_DsEnv.qualify env id1  in
               let qual = [FStar_Syntax_Syntax.ExceptionConstructor]  in
               let se =
                 {
                   FStar_Syntax_Syntax.sigel =
                     (FStar_Syntax_Syntax.Sig_datacon
                        (l, [], t, FStar_Parser_Const.exn_lid,
                          (Prims.parse_int "0"),
                          [FStar_Parser_Const.exn_lid]));
                   FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
                   FStar_Syntax_Syntax.sigquals = qual;
                   FStar_Syntax_Syntax.sigmeta =
                     FStar_Syntax_Syntax.default_sigmeta;
                   FStar_Syntax_Syntax.sigattrs = []
                 }  in
               let se' =
                 {
                   FStar_Syntax_Syntax.sigel =
                     (FStar_Syntax_Syntax.Sig_bundle ([se], [l]));
                   FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
                   FStar_Syntax_Syntax.sigquals = qual;
                   FStar_Syntax_Syntax.sigmeta =
                     FStar_Syntax_Syntax.default_sigmeta;
                   FStar_Syntax_Syntax.sigattrs = []
                 }  in
               let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
               let env2 =
                 FStar_Syntax_DsEnv.push_doc env1 l d.FStar_Parser_AST.doc
                  in
               let data_ops = mk_data_projector_names [] env2 se  in
               let discs = mk_data_discriminators [] env2 [l]  in
               let env3 =
                 FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt env2
                   (FStar_List.append discs data_ops)
                  in
               (env3, (FStar_List.append (se' :: discs) data_ops)))
      | FStar_Parser_AST.Exception (id1,FStar_Pervasives_Native.Some term) ->
          let t = desugar_term env term  in
          let t1 =
            let uu____21623 =
              let uu____21630 = FStar_Syntax_Syntax.null_binder t  in
              [uu____21630]  in
            let uu____21631 =
              let uu____21634 =
                let uu____21635 =
                  FStar_Syntax_DsEnv.fail_or env
                    (FStar_Syntax_DsEnv.try_lookup_lid env)
                    FStar_Parser_Const.exn_lid
                   in
                FStar_Pervasives_Native.fst uu____21635  in
              FStar_All.pipe_left FStar_Syntax_Syntax.mk_Total uu____21634
               in
            FStar_Syntax_Util.arrow uu____21623 uu____21631  in
          let l = FStar_Syntax_DsEnv.qualify env id1  in
          let qual = [FStar_Syntax_Syntax.ExceptionConstructor]  in
          let se =
            {
              FStar_Syntax_Syntax.sigel =
                (FStar_Syntax_Syntax.Sig_datacon
                   (l, [], t1, FStar_Parser_Const.exn_lid,
                     (Prims.parse_int "0"), [FStar_Parser_Const.exn_lid]));
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = qual;
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let se' =
            {
              FStar_Syntax_Syntax.sigel =
                (FStar_Syntax_Syntax.Sig_bundle ([se], [l]));
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = qual;
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
          let env2 =
            FStar_Syntax_DsEnv.push_doc env1 l d.FStar_Parser_AST.doc  in
          let data_ops = mk_data_projector_names [] env2 se  in
          let discs = mk_data_discriminators [] env2 [l]  in
          let env3 =
            FStar_List.fold_left FStar_Syntax_DsEnv.push_sigelt env2
              (FStar_List.append discs data_ops)
             in
          (env3, (FStar_List.append (se' :: discs) data_ops))
      | FStar_Parser_AST.NewEffect (FStar_Parser_AST.RedefineEffect
          (eff_name,eff_binders,defn)) ->
          let quals = d.FStar_Parser_AST.quals  in
          desugar_redefine_effect env d trans_qual1 quals eff_name
            eff_binders defn
      | FStar_Parser_AST.NewEffect (FStar_Parser_AST.DefineEffect
          (eff_name,eff_binders,eff_typ,eff_decls)) ->
          let quals = d.FStar_Parser_AST.quals  in
          let attrs = d.FStar_Parser_AST.attrs  in
          desugar_effect env d quals eff_name eff_binders eff_typ eff_decls
            attrs
      | FStar_Parser_AST.SubEffect l ->
          let lookup1 l1 =
            let uu____21700 =
              FStar_Syntax_DsEnv.try_lookup_effect_name env l1  in
            match uu____21700 with
            | FStar_Pervasives_Native.None  ->
                let uu____21703 =
                  let uu____21708 =
                    let uu____21709 =
                      let uu____21710 = FStar_Syntax_Print.lid_to_string l1
                         in
                      Prims.strcat uu____21710 " not found"  in
                    Prims.strcat "Effect name " uu____21709  in
                  (FStar_Errors.Fatal_EffectNotFound, uu____21708)  in
                FStar_Errors.raise_error uu____21703
                  d.FStar_Parser_AST.drange
            | FStar_Pervasives_Native.Some l2 -> l2  in
          let src = lookup1 l.FStar_Parser_AST.msource  in
          let dst = lookup1 l.FStar_Parser_AST.mdest  in
          let uu____21714 =
            match l.FStar_Parser_AST.lift_op with
            | FStar_Parser_AST.NonReifiableLift t ->
                let uu____21756 =
                  let uu____21765 =
                    let uu____21772 = desugar_term env t  in
                    ([], uu____21772)  in
                  FStar_Pervasives_Native.Some uu____21765  in
                (uu____21756, FStar_Pervasives_Native.None)
            | FStar_Parser_AST.ReifiableLift (wp,t) ->
                let uu____21805 =
                  let uu____21814 =
                    let uu____21821 = desugar_term env wp  in
                    ([], uu____21821)  in
                  FStar_Pervasives_Native.Some uu____21814  in
                let uu____21830 =
                  let uu____21839 =
                    let uu____21846 = desugar_term env t  in
                    ([], uu____21846)  in
                  FStar_Pervasives_Native.Some uu____21839  in
                (uu____21805, uu____21830)
            | FStar_Parser_AST.LiftForFree t ->
                let uu____21872 =
                  let uu____21881 =
                    let uu____21888 = desugar_term env t  in
                    ([], uu____21888)  in
                  FStar_Pervasives_Native.Some uu____21881  in
                (FStar_Pervasives_Native.None, uu____21872)
             in
          (match uu____21714 with
           | (lift_wp,lift) ->
               let se =
                 {
                   FStar_Syntax_Syntax.sigel =
                     (FStar_Syntax_Syntax.Sig_sub_effect
                        {
                          FStar_Syntax_Syntax.source = src;
                          FStar_Syntax_Syntax.target = dst;
                          FStar_Syntax_Syntax.lift_wp = lift_wp;
                          FStar_Syntax_Syntax.lift = lift
                        });
                   FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
                   FStar_Syntax_Syntax.sigquals = [];
                   FStar_Syntax_Syntax.sigmeta =
                     FStar_Syntax_Syntax.default_sigmeta;
                   FStar_Syntax_Syntax.sigattrs = []
                 }  in
               (env, [se]))
      | FStar_Parser_AST.Splice (ids,t) ->
          let t1 = desugar_term env t  in
          let se =
            let uu____21968 =
              let uu____21969 =
                let uu____21976 =
                  FStar_List.map (FStar_Syntax_DsEnv.qualify env) ids  in
                (uu____21976, t1)  in
              FStar_Syntax_Syntax.Sig_splice uu____21969  in
            {
              FStar_Syntax_Syntax.sigel = uu____21968;
              FStar_Syntax_Syntax.sigrng = (d.FStar_Parser_AST.drange);
              FStar_Syntax_Syntax.sigquals = [];
              FStar_Syntax_Syntax.sigmeta =
                FStar_Syntax_Syntax.default_sigmeta;
              FStar_Syntax_Syntax.sigattrs = []
            }  in
          let env1 = FStar_Syntax_DsEnv.push_sigelt env se  in (env1, [se])

let (desugar_decls :
  env_t ->
    FStar_Parser_AST.decl Prims.list ->
      (env_t,FStar_Syntax_Syntax.sigelt Prims.list)
        FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun decls  ->
      let uu____22004 =
        FStar_List.fold_left
          (fun uu____22024  ->
             fun d  ->
               match uu____22024 with
               | (env1,sigelts) ->
                   let uu____22044 = desugar_decl env1 d  in
                   (match uu____22044 with
                    | (env2,se) -> (env2, (FStar_List.append sigelts se))))
          (env, []) decls
         in
      match uu____22004 with
      | (env1,sigelts) ->
          let rec forward acc uu___139_22089 =
            match uu___139_22089 with
            | se1::se2::sigelts1 ->
                (match ((se1.FStar_Syntax_Syntax.sigel),
                         (se2.FStar_Syntax_Syntax.sigel))
                 with
                 | (FStar_Syntax_Syntax.Sig_declare_typ
                    uu____22103,FStar_Syntax_Syntax.Sig_let uu____22104) ->
                     let uu____22117 =
                       let uu____22120 =
                         let uu___169_22121 = se2  in
                         let uu____22122 =
                           let uu____22125 =
                             FStar_List.filter
                               (fun uu___138_22139  ->
                                  match uu___138_22139 with
                                  | {
                                      FStar_Syntax_Syntax.n =
                                        FStar_Syntax_Syntax.Tm_app
                                        ({
                                           FStar_Syntax_Syntax.n =
                                             FStar_Syntax_Syntax.Tm_fvar fv;
                                           FStar_Syntax_Syntax.pos =
                                             uu____22143;
                                           FStar_Syntax_Syntax.vars =
                                             uu____22144;_},uu____22145);
                                      FStar_Syntax_Syntax.pos = uu____22146;
                                      FStar_Syntax_Syntax.vars = uu____22147;_}
                                      when
                                      let uu____22170 =
                                        let uu____22171 =
                                          FStar_Syntax_Syntax.lid_of_fv fv
                                           in
                                        FStar_Ident.string_of_lid uu____22171
                                         in
                                      uu____22170 =
                                        "FStar.Pervasives.Comment"
                                      -> true
                                  | uu____22172 -> false)
                               se1.FStar_Syntax_Syntax.sigattrs
                              in
                           FStar_List.append uu____22125
                             se2.FStar_Syntax_Syntax.sigattrs
                            in
                         {
                           FStar_Syntax_Syntax.sigel =
                             (uu___169_22121.FStar_Syntax_Syntax.sigel);
                           FStar_Syntax_Syntax.sigrng =
                             (uu___169_22121.FStar_Syntax_Syntax.sigrng);
                           FStar_Syntax_Syntax.sigquals =
                             (uu___169_22121.FStar_Syntax_Syntax.sigquals);
                           FStar_Syntax_Syntax.sigmeta =
                             (uu___169_22121.FStar_Syntax_Syntax.sigmeta);
                           FStar_Syntax_Syntax.sigattrs = uu____22122
                         }  in
                       uu____22120 :: se1 :: acc  in
                     forward uu____22117 sigelts1
                 | uu____22177 -> forward (se1 :: acc) (se2 :: sigelts1))
            | sigelts1 -> FStar_List.rev_append acc sigelts1  in
          let uu____22185 = forward [] sigelts  in (env1, uu____22185)
  
let (open_prims_all :
  (FStar_Parser_AST.decoration Prims.list -> FStar_Parser_AST.decl)
    Prims.list)
  =
  [FStar_Parser_AST.mk_decl
     (FStar_Parser_AST.Open FStar_Parser_Const.prims_lid)
     FStar_Range.dummyRange;
  FStar_Parser_AST.mk_decl (FStar_Parser_AST.Open FStar_Parser_Const.all_lid)
    FStar_Range.dummyRange]
  
let (generalize_annotated_univs :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt) =
  fun s  ->
    let bs_univnames bs =
      let uu____22227 =
        let uu____22234 =
          FStar_Util.new_set FStar_Syntax_Syntax.order_univ_name  in
        FStar_List.fold_left
          (fun uvs  ->
             fun uu____22251  ->
               match uu____22251 with
               | ({ FStar_Syntax_Syntax.ppname = uu____22260;
                    FStar_Syntax_Syntax.index = uu____22261;
                    FStar_Syntax_Syntax.sort = t;_},uu____22263)
                   ->
                   let uu____22266 = FStar_Syntax_Free.univnames t  in
                   FStar_Util.set_union uvs uu____22266) uu____22234
         in
      FStar_All.pipe_right bs uu____22227  in
    let empty_set = FStar_Util.new_set FStar_Syntax_Syntax.order_univ_name
       in
    match s.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_inductive_typ uu____22274 ->
        failwith
          "Impossible: collect_annotated_universes: bare data/type constructor"
    | FStar_Syntax_Syntax.Sig_datacon uu____22291 ->
        failwith
          "Impossible: collect_annotated_universes: bare data/type constructor"
    | FStar_Syntax_Syntax.Sig_bundle (sigs,lids) ->
        let uvs =
          let uu____22319 =
            FStar_All.pipe_right sigs
              (FStar_List.fold_left
                 (fun uvs  ->
                    fun se  ->
                      let se_univs =
                        match se.FStar_Syntax_Syntax.sigel with
                        | FStar_Syntax_Syntax.Sig_inductive_typ
                            (uu____22340,uu____22341,bs,t,uu____22344,uu____22345)
                            ->
                            let uu____22354 = bs_univnames bs  in
                            let uu____22357 = FStar_Syntax_Free.univnames t
                               in
                            FStar_Util.set_union uu____22354 uu____22357
                        | FStar_Syntax_Syntax.Sig_datacon
                            (uu____22360,uu____22361,t,uu____22363,uu____22364,uu____22365)
                            -> FStar_Syntax_Free.univnames t
                        | uu____22370 ->
                            failwith
                              "Impossible: collect_annotated_universes: Sig_bundle should not have a non data/type sigelt"
                         in
                      FStar_Util.set_union uvs se_univs) empty_set)
             in
          FStar_All.pipe_right uu____22319 FStar_Util.set_elements  in
        let usubst = FStar_Syntax_Subst.univ_var_closing uvs  in
        let uu___170_22380 = s  in
        let uu____22381 =
          let uu____22382 =
            let uu____22391 =
              FStar_All.pipe_right sigs
                (FStar_List.map
                   (fun se  ->
                      match se.FStar_Syntax_Syntax.sigel with
                      | FStar_Syntax_Syntax.Sig_inductive_typ
                          (lid,uu____22409,bs,t,lids1,lids2) ->
                          let uu___171_22422 = se  in
                          let uu____22423 =
                            let uu____22424 =
                              let uu____22441 =
                                FStar_Syntax_Subst.subst_binders usubst bs
                                 in
                              let uu____22442 =
                                let uu____22443 =
                                  FStar_Syntax_Subst.shift_subst
                                    (FStar_List.length bs) usubst
                                   in
                                FStar_Syntax_Subst.subst uu____22443 t  in
                              (lid, uvs, uu____22441, uu____22442, lids1,
                                lids2)
                               in
                            FStar_Syntax_Syntax.Sig_inductive_typ uu____22424
                             in
                          {
                            FStar_Syntax_Syntax.sigel = uu____22423;
                            FStar_Syntax_Syntax.sigrng =
                              (uu___171_22422.FStar_Syntax_Syntax.sigrng);
                            FStar_Syntax_Syntax.sigquals =
                              (uu___171_22422.FStar_Syntax_Syntax.sigquals);
                            FStar_Syntax_Syntax.sigmeta =
                              (uu___171_22422.FStar_Syntax_Syntax.sigmeta);
                            FStar_Syntax_Syntax.sigattrs =
                              (uu___171_22422.FStar_Syntax_Syntax.sigattrs)
                          }
                      | FStar_Syntax_Syntax.Sig_datacon
                          (lid,uu____22457,t,tlid,n1,lids1) ->
                          let uu___172_22466 = se  in
                          let uu____22467 =
                            let uu____22468 =
                              let uu____22483 =
                                FStar_Syntax_Subst.subst usubst t  in
                              (lid, uvs, uu____22483, tlid, n1, lids1)  in
                            FStar_Syntax_Syntax.Sig_datacon uu____22468  in
                          {
                            FStar_Syntax_Syntax.sigel = uu____22467;
                            FStar_Syntax_Syntax.sigrng =
                              (uu___172_22466.FStar_Syntax_Syntax.sigrng);
                            FStar_Syntax_Syntax.sigquals =
                              (uu___172_22466.FStar_Syntax_Syntax.sigquals);
                            FStar_Syntax_Syntax.sigmeta =
                              (uu___172_22466.FStar_Syntax_Syntax.sigmeta);
                            FStar_Syntax_Syntax.sigattrs =
                              (uu___172_22466.FStar_Syntax_Syntax.sigattrs)
                          }
                      | uu____22488 ->
                          failwith
                            "Impossible: collect_annotated_universes: Sig_bundle should not have a non data/type sigelt"))
               in
            (uu____22391, lids)  in
          FStar_Syntax_Syntax.Sig_bundle uu____22382  in
        {
          FStar_Syntax_Syntax.sigel = uu____22381;
          FStar_Syntax_Syntax.sigrng =
            (uu___170_22380.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___170_22380.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___170_22380.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___170_22380.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_declare_typ (lid,uu____22494,t) ->
        let uvs =
          let uu____22499 = FStar_Syntax_Free.univnames t  in
          FStar_All.pipe_right uu____22499 FStar_Util.set_elements  in
        let uu___173_22506 = s  in
        let uu____22507 =
          let uu____22508 =
            let uu____22515 = FStar_Syntax_Subst.close_univ_vars uvs t  in
            (lid, uvs, uu____22515)  in
          FStar_Syntax_Syntax.Sig_declare_typ uu____22508  in
        {
          FStar_Syntax_Syntax.sigel = uu____22507;
          FStar_Syntax_Syntax.sigrng =
            (uu___173_22506.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___173_22506.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___173_22506.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___173_22506.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_let ((b,lbs),lids) ->
        let lb_univnames lb =
          let uu____22545 =
            FStar_Syntax_Free.univnames lb.FStar_Syntax_Syntax.lbtyp  in
          let uu____22548 =
            match (lb.FStar_Syntax_Syntax.lbdef).FStar_Syntax_Syntax.n with
            | FStar_Syntax_Syntax.Tm_abs (bs,e,uu____22555) ->
                let uvs1 = bs_univnames bs  in
                let uvs2 =
                  match e.FStar_Syntax_Syntax.n with
                  | FStar_Syntax_Syntax.Tm_ascribed
                      (uu____22584,(FStar_Util.Inl t,uu____22586),uu____22587)
                      -> FStar_Syntax_Free.univnames t
                  | FStar_Syntax_Syntax.Tm_ascribed
                      (uu____22634,(FStar_Util.Inr c,uu____22636),uu____22637)
                      -> FStar_Syntax_Free.univnames_comp c
                  | uu____22684 -> empty_set  in
                FStar_Util.set_union uvs1 uvs2
            | FStar_Syntax_Syntax.Tm_ascribed
                (uu____22685,(FStar_Util.Inl t,uu____22687),uu____22688) ->
                FStar_Syntax_Free.univnames t
            | FStar_Syntax_Syntax.Tm_ascribed
                (uu____22735,(FStar_Util.Inr c,uu____22737),uu____22738) ->
                FStar_Syntax_Free.univnames_comp c
            | uu____22785 -> empty_set  in
          FStar_Util.set_union uu____22545 uu____22548  in
        let all_lb_univs =
          let uu____22789 =
            FStar_All.pipe_right lbs
              (FStar_List.fold_left
                 (fun uvs  ->
                    fun lb  ->
                      let uu____22805 = lb_univnames lb  in
                      FStar_Util.set_union uvs uu____22805) empty_set)
             in
          FStar_All.pipe_right uu____22789 FStar_Util.set_elements  in
        let usubst = FStar_Syntax_Subst.univ_var_closing all_lb_univs  in
        let uu___174_22815 = s  in
        let uu____22816 =
          let uu____22817 =
            let uu____22824 =
              let uu____22831 =
                FStar_All.pipe_right lbs
                  (FStar_List.map
                     (fun lb  ->
                        let uu___175_22843 = lb  in
                        let uu____22844 =
                          FStar_Syntax_Subst.subst usubst
                            lb.FStar_Syntax_Syntax.lbtyp
                           in
                        let uu____22847 =
                          FStar_Syntax_Subst.subst usubst
                            lb.FStar_Syntax_Syntax.lbdef
                           in
                        {
                          FStar_Syntax_Syntax.lbname =
                            (uu___175_22843.FStar_Syntax_Syntax.lbname);
                          FStar_Syntax_Syntax.lbunivs = all_lb_univs;
                          FStar_Syntax_Syntax.lbtyp = uu____22844;
                          FStar_Syntax_Syntax.lbeff =
                            (uu___175_22843.FStar_Syntax_Syntax.lbeff);
                          FStar_Syntax_Syntax.lbdef = uu____22847;
                          FStar_Syntax_Syntax.lbattrs =
                            (uu___175_22843.FStar_Syntax_Syntax.lbattrs);
                          FStar_Syntax_Syntax.lbpos =
                            (uu___175_22843.FStar_Syntax_Syntax.lbpos)
                        }))
                 in
              (b, uu____22831)  in
            (uu____22824, lids)  in
          FStar_Syntax_Syntax.Sig_let uu____22817  in
        {
          FStar_Syntax_Syntax.sigel = uu____22816;
          FStar_Syntax_Syntax.sigrng =
            (uu___174_22815.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___174_22815.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___174_22815.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___174_22815.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_assume (lid,uu____22861,fml) ->
        let uvs =
          let uu____22866 = FStar_Syntax_Free.univnames fml  in
          FStar_All.pipe_right uu____22866 FStar_Util.set_elements  in
        let uu___176_22873 = s  in
        let uu____22874 =
          let uu____22875 =
            let uu____22882 = FStar_Syntax_Subst.close_univ_vars uvs fml  in
            (lid, uvs, uu____22882)  in
          FStar_Syntax_Syntax.Sig_assume uu____22875  in
        {
          FStar_Syntax_Syntax.sigel = uu____22874;
          FStar_Syntax_Syntax.sigrng =
            (uu___176_22873.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___176_22873.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___176_22873.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___176_22873.FStar_Syntax_Syntax.sigattrs)
        }
    | FStar_Syntax_Syntax.Sig_effect_abbrev (lid,uu____22886,bs,c,flags1) ->
        let uvs =
          let uu____22897 =
            let uu____22900 = bs_univnames bs  in
            let uu____22903 = FStar_Syntax_Free.univnames_comp c  in
            FStar_Util.set_union uu____22900 uu____22903  in
          FStar_All.pipe_right uu____22897 FStar_Util.set_elements  in
        let usubst = FStar_Syntax_Subst.univ_var_closing uvs  in
        let uu___177_22913 = s  in
        let uu____22914 =
          let uu____22915 =
            let uu____22928 = FStar_Syntax_Subst.subst_binders usubst bs  in
            let uu____22929 = FStar_Syntax_Subst.subst_comp usubst c  in
            (lid, uvs, uu____22928, uu____22929, flags1)  in
          FStar_Syntax_Syntax.Sig_effect_abbrev uu____22915  in
        {
          FStar_Syntax_Syntax.sigel = uu____22914;
          FStar_Syntax_Syntax.sigrng =
            (uu___177_22913.FStar_Syntax_Syntax.sigrng);
          FStar_Syntax_Syntax.sigquals =
            (uu___177_22913.FStar_Syntax_Syntax.sigquals);
          FStar_Syntax_Syntax.sigmeta =
            (uu___177_22913.FStar_Syntax_Syntax.sigmeta);
          FStar_Syntax_Syntax.sigattrs =
            (uu___177_22913.FStar_Syntax_Syntax.sigattrs)
        }
    | uu____22934 -> s
  
let (desugar_modul_common :
  FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option ->
    FStar_Syntax_DsEnv.env ->
      FStar_Parser_AST.modul ->
        (env_t,FStar_Syntax_Syntax.modul,Prims.bool)
          FStar_Pervasives_Native.tuple3)
  =
  fun curmod  ->
    fun env  ->
      fun m  ->
        let env1 =
          match (curmod, m) with
          | (FStar_Pervasives_Native.None ,uu____22969) -> env
          | (FStar_Pervasives_Native.Some
             { FStar_Syntax_Syntax.name = prev_lid;
               FStar_Syntax_Syntax.declarations = uu____22973;
               FStar_Syntax_Syntax.exports = uu____22974;
               FStar_Syntax_Syntax.is_interface = uu____22975;_},FStar_Parser_AST.Module
             (current_lid,uu____22977)) when
              (FStar_Ident.lid_equals prev_lid current_lid) &&
                (FStar_Options.interactive ())
              -> env
          | (FStar_Pervasives_Native.Some prev_mod,uu____22985) ->
              let uu____22988 =
                FStar_Syntax_DsEnv.finish_module_or_interface env prev_mod
                 in
              FStar_Pervasives_Native.fst uu____22988
           in
        let uu____22993 =
          match m with
          | FStar_Parser_AST.Interface (mname,decls,admitted) ->
              let uu____23029 =
                FStar_Syntax_DsEnv.prepare_module_or_interface true admitted
                  env1 mname FStar_Syntax_DsEnv.default_mii
                 in
              (uu____23029, mname, decls, true)
          | FStar_Parser_AST.Module (mname,decls) ->
              let uu____23046 =
                FStar_Syntax_DsEnv.prepare_module_or_interface false false
                  env1 mname FStar_Syntax_DsEnv.default_mii
                 in
              (uu____23046, mname, decls, false)
           in
        match uu____22993 with
        | ((env2,pop_when_done),mname,decls,intf) ->
            let uu____23076 = desugar_decls env2 decls  in
            (match uu____23076 with
             | (env3,sigelts) ->
                 let sigelts1 =
                   FStar_All.pipe_right sigelts
                     (FStar_List.map generalize_annotated_univs)
                    in
                 let modul =
                   {
                     FStar_Syntax_Syntax.name = mname;
                     FStar_Syntax_Syntax.declarations = sigelts1;
                     FStar_Syntax_Syntax.exports = [];
                     FStar_Syntax_Syntax.is_interface = intf
                   }  in
                 (env3, modul, pop_when_done))
  
let (as_interface : FStar_Parser_AST.modul -> FStar_Parser_AST.modul) =
  fun m  ->
    match m with
    | FStar_Parser_AST.Module (mname,decls) ->
        FStar_Parser_AST.Interface (mname, decls, true)
    | i -> i
  
let (desugar_partial_modul :
  FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option ->
    env_t ->
      FStar_Parser_AST.modul ->
        (env_t,FStar_Syntax_Syntax.modul) FStar_Pervasives_Native.tuple2)
  =
  fun curmod  ->
    fun env  ->
      fun m  ->
        let m1 =
          let uu____23145 =
            (FStar_Options.interactive ()) &&
              (let uu____23147 =
                 let uu____23148 =
                   let uu____23149 = FStar_Options.file_list ()  in
                   FStar_List.hd uu____23149  in
                 FStar_Util.get_file_extension uu____23148  in
               FStar_List.mem uu____23147 ["fsti"; "fsi"])
             in
          if uu____23145 then as_interface m else m  in
        let uu____23153 = desugar_modul_common curmod env m1  in
        match uu____23153 with
        | (env1,modul,pop_when_done) ->
            if pop_when_done
            then
              let uu____23171 = FStar_Syntax_DsEnv.pop ()  in
              (uu____23171, modul)
            else (env1, modul)
  
let (desugar_modul :
  FStar_Syntax_DsEnv.env ->
    FStar_Parser_AST.modul ->
      (env_t,FStar_Syntax_Syntax.modul) FStar_Pervasives_Native.tuple2)
  =
  fun env  ->
    fun m  ->
      let uu____23191 =
        desugar_modul_common FStar_Pervasives_Native.None env m  in
      match uu____23191 with
      | (env1,modul,pop_when_done) ->
          let uu____23205 =
            FStar_Syntax_DsEnv.finish_module_or_interface env1 modul  in
          (match uu____23205 with
           | (env2,modul1) ->
               ((let uu____23217 =
                   FStar_Options.dump_module
                     (modul1.FStar_Syntax_Syntax.name).FStar_Ident.str
                    in
                 if uu____23217
                 then
                   let uu____23218 =
                     FStar_Syntax_Print.modul_to_string modul1  in
                   FStar_Util.print1 "Module after desugaring:\n%s\n"
                     uu____23218
                 else ());
                (let uu____23220 =
                   if pop_when_done
                   then
                     FStar_Syntax_DsEnv.export_interface
                       modul1.FStar_Syntax_Syntax.name env2
                   else env2  in
                 (uu____23220, modul1))))
  
let (ast_modul_to_modul :
  FStar_Parser_AST.modul ->
    FStar_Syntax_Syntax.modul FStar_Syntax_DsEnv.withenv)
  =
  fun modul  ->
    fun env  ->
      let uu____23238 = desugar_modul env modul  in
      match uu____23238 with | (env1,modul1) -> (modul1, env1)
  
let (decls_to_sigelts :
  FStar_Parser_AST.decl Prims.list ->
    FStar_Syntax_Syntax.sigelts FStar_Syntax_DsEnv.withenv)
  =
  fun decls  ->
    fun env  ->
      let uu____23269 = desugar_decls env decls  in
      match uu____23269 with | (env1,sigelts) -> (sigelts, env1)
  
let (partial_ast_modul_to_modul :
  FStar_Syntax_Syntax.modul FStar_Pervasives_Native.option ->
    FStar_Parser_AST.modul ->
      FStar_Syntax_Syntax.modul FStar_Syntax_DsEnv.withenv)
  =
  fun modul  ->
    fun a_modul  ->
      fun env  ->
        let uu____23313 = desugar_partial_modul modul env a_modul  in
        match uu____23313 with | (env1,modul1) -> (modul1, env1)
  
let (add_modul_to_env :
  FStar_Syntax_Syntax.modul ->
    FStar_Syntax_DsEnv.module_inclusion_info ->
      (FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) ->
        unit FStar_Syntax_DsEnv.withenv)
  =
  fun m  ->
    fun mii  ->
      fun erase_univs  ->
        fun en  ->
          let erase_univs_ed ed =
            let erase_binders bs =
              match bs with
              | [] -> []
              | uu____23399 ->
                  let t =
                    let uu____23407 =
                      FStar_Syntax_Syntax.mk
                        (FStar_Syntax_Syntax.Tm_abs
                           (bs, FStar_Syntax_Syntax.t_unit,
                             FStar_Pervasives_Native.None))
                        FStar_Pervasives_Native.None FStar_Range.dummyRange
                       in
                    erase_univs uu____23407  in
                  let uu____23416 =
                    let uu____23417 = FStar_Syntax_Subst.compress t  in
                    uu____23417.FStar_Syntax_Syntax.n  in
                  (match uu____23416 with
                   | FStar_Syntax_Syntax.Tm_abs (bs1,uu____23427,uu____23428)
                       -> bs1
                   | uu____23449 -> failwith "Impossible")
               in
            let uu____23456 =
              let uu____23463 = erase_binders ed.FStar_Syntax_Syntax.binders
                 in
              FStar_Syntax_Subst.open_term' uu____23463
                FStar_Syntax_Syntax.t_unit
               in
            match uu____23456 with
            | (binders,uu____23465,binders_opening) ->
                let erase_term t =
                  let uu____23473 =
                    let uu____23474 =
                      FStar_Syntax_Subst.subst binders_opening t  in
                    erase_univs uu____23474  in
                  FStar_Syntax_Subst.close binders uu____23473  in
                let erase_tscheme uu____23492 =
                  match uu____23492 with
                  | (us,t) ->
                      let t1 =
                        let uu____23512 =
                          FStar_Syntax_Subst.shift_subst
                            (FStar_List.length us) binders_opening
                           in
                        FStar_Syntax_Subst.subst uu____23512 t  in
                      let uu____23515 =
                        let uu____23516 = erase_univs t1  in
                        FStar_Syntax_Subst.close binders uu____23516  in
                      ([], uu____23515)
                   in
                let erase_action action =
                  let opening =
                    FStar_Syntax_Subst.shift_subst
                      (FStar_List.length
                         action.FStar_Syntax_Syntax.action_univs)
                      binders_opening
                     in
                  let erased_action_params =
                    match action.FStar_Syntax_Syntax.action_params with
                    | [] -> []
                    | uu____23547 ->
                        let bs =
                          let uu____23555 =
                            FStar_Syntax_Subst.subst_binders opening
                              action.FStar_Syntax_Syntax.action_params
                             in
                          FStar_All.pipe_left erase_binders uu____23555  in
                        let t =
                          FStar_Syntax_Syntax.mk
                            (FStar_Syntax_Syntax.Tm_abs
                               (bs, FStar_Syntax_Syntax.t_unit,
                                 FStar_Pervasives_Native.None))
                            FStar_Pervasives_Native.None
                            FStar_Range.dummyRange
                           in
                        let uu____23585 =
                          let uu____23586 =
                            let uu____23589 =
                              FStar_Syntax_Subst.close binders t  in
                            FStar_Syntax_Subst.compress uu____23589  in
                          uu____23586.FStar_Syntax_Syntax.n  in
                        (match uu____23585 with
                         | FStar_Syntax_Syntax.Tm_abs
                             (bs1,uu____23597,uu____23598) -> bs1
                         | uu____23619 -> failwith "Impossible")
                     in
                  let erase_term1 t =
                    let uu____23632 =
                      let uu____23633 = FStar_Syntax_Subst.subst opening t
                         in
                      erase_univs uu____23633  in
                    FStar_Syntax_Subst.close binders uu____23632  in
                  let uu___178_23634 = action  in
                  let uu____23635 =
                    erase_term1 action.FStar_Syntax_Syntax.action_defn  in
                  let uu____23636 =
                    erase_term1 action.FStar_Syntax_Syntax.action_typ  in
                  {
                    FStar_Syntax_Syntax.action_name =
                      (uu___178_23634.FStar_Syntax_Syntax.action_name);
                    FStar_Syntax_Syntax.action_unqualified_name =
                      (uu___178_23634.FStar_Syntax_Syntax.action_unqualified_name);
                    FStar_Syntax_Syntax.action_univs = [];
                    FStar_Syntax_Syntax.action_params = erased_action_params;
                    FStar_Syntax_Syntax.action_defn = uu____23635;
                    FStar_Syntax_Syntax.action_typ = uu____23636
                  }  in
                let uu___179_23637 = ed  in
                let uu____23638 = FStar_Syntax_Subst.close_binders binders
                   in
                let uu____23639 = erase_term ed.FStar_Syntax_Syntax.signature
                   in
                let uu____23640 = erase_tscheme ed.FStar_Syntax_Syntax.ret_wp
                   in
                let uu____23641 =
                  erase_tscheme ed.FStar_Syntax_Syntax.bind_wp  in
                let uu____23642 =
                  erase_tscheme ed.FStar_Syntax_Syntax.if_then_else  in
                let uu____23643 = erase_tscheme ed.FStar_Syntax_Syntax.ite_wp
                   in
                let uu____23644 =
                  erase_tscheme ed.FStar_Syntax_Syntax.stronger  in
                let uu____23645 =
                  erase_tscheme ed.FStar_Syntax_Syntax.close_wp  in
                let uu____23646 =
                  erase_tscheme ed.FStar_Syntax_Syntax.assert_p  in
                let uu____23647 =
                  erase_tscheme ed.FStar_Syntax_Syntax.assume_p  in
                let uu____23648 =
                  erase_tscheme ed.FStar_Syntax_Syntax.null_wp  in
                let uu____23649 =
                  erase_tscheme ed.FStar_Syntax_Syntax.trivial  in
                let uu____23650 = erase_term ed.FStar_Syntax_Syntax.repr  in
                let uu____23651 =
                  erase_tscheme ed.FStar_Syntax_Syntax.return_repr  in
                let uu____23652 =
                  erase_tscheme ed.FStar_Syntax_Syntax.bind_repr  in
                let uu____23653 =
                  FStar_List.map erase_action ed.FStar_Syntax_Syntax.actions
                   in
                {
                  FStar_Syntax_Syntax.cattributes =
                    (uu___179_23637.FStar_Syntax_Syntax.cattributes);
                  FStar_Syntax_Syntax.mname =
                    (uu___179_23637.FStar_Syntax_Syntax.mname);
                  FStar_Syntax_Syntax.univs = [];
                  FStar_Syntax_Syntax.binders = uu____23638;
                  FStar_Syntax_Syntax.signature = uu____23639;
                  FStar_Syntax_Syntax.ret_wp = uu____23640;
                  FStar_Syntax_Syntax.bind_wp = uu____23641;
                  FStar_Syntax_Syntax.if_then_else = uu____23642;
                  FStar_Syntax_Syntax.ite_wp = uu____23643;
                  FStar_Syntax_Syntax.stronger = uu____23644;
                  FStar_Syntax_Syntax.close_wp = uu____23645;
                  FStar_Syntax_Syntax.assert_p = uu____23646;
                  FStar_Syntax_Syntax.assume_p = uu____23647;
                  FStar_Syntax_Syntax.null_wp = uu____23648;
                  FStar_Syntax_Syntax.trivial = uu____23649;
                  FStar_Syntax_Syntax.repr = uu____23650;
                  FStar_Syntax_Syntax.return_repr = uu____23651;
                  FStar_Syntax_Syntax.bind_repr = uu____23652;
                  FStar_Syntax_Syntax.actions = uu____23653;
                  FStar_Syntax_Syntax.eff_attrs =
                    (uu___179_23637.FStar_Syntax_Syntax.eff_attrs)
                }
             in
          let push_sigelt1 env se =
            match se.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_new_effect ed ->
                let se' =
                  let uu___180_23669 = se  in
                  let uu____23670 =
                    let uu____23671 = erase_univs_ed ed  in
                    FStar_Syntax_Syntax.Sig_new_effect uu____23671  in
                  {
                    FStar_Syntax_Syntax.sigel = uu____23670;
                    FStar_Syntax_Syntax.sigrng =
                      (uu___180_23669.FStar_Syntax_Syntax.sigrng);
                    FStar_Syntax_Syntax.sigquals =
                      (uu___180_23669.FStar_Syntax_Syntax.sigquals);
                    FStar_Syntax_Syntax.sigmeta =
                      (uu___180_23669.FStar_Syntax_Syntax.sigmeta);
                    FStar_Syntax_Syntax.sigattrs =
                      (uu___180_23669.FStar_Syntax_Syntax.sigattrs)
                  }  in
                let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
                push_reflect_effect env1 se.FStar_Syntax_Syntax.sigquals
                  ed.FStar_Syntax_Syntax.mname se.FStar_Syntax_Syntax.sigrng
            | FStar_Syntax_Syntax.Sig_new_effect_for_free ed ->
                let se' =
                  let uu___181_23675 = se  in
                  let uu____23676 =
                    let uu____23677 = erase_univs_ed ed  in
                    FStar_Syntax_Syntax.Sig_new_effect_for_free uu____23677
                     in
                  {
                    FStar_Syntax_Syntax.sigel = uu____23676;
                    FStar_Syntax_Syntax.sigrng =
                      (uu___181_23675.FStar_Syntax_Syntax.sigrng);
                    FStar_Syntax_Syntax.sigquals =
                      (uu___181_23675.FStar_Syntax_Syntax.sigquals);
                    FStar_Syntax_Syntax.sigmeta =
                      (uu___181_23675.FStar_Syntax_Syntax.sigmeta);
                    FStar_Syntax_Syntax.sigattrs =
                      (uu___181_23675.FStar_Syntax_Syntax.sigattrs)
                  }  in
                let env1 = FStar_Syntax_DsEnv.push_sigelt env se'  in
                push_reflect_effect env1 se.FStar_Syntax_Syntax.sigquals
                  ed.FStar_Syntax_Syntax.mname se.FStar_Syntax_Syntax.sigrng
            | uu____23679 -> FStar_Syntax_DsEnv.push_sigelt env se  in
          let uu____23680 =
            FStar_Syntax_DsEnv.prepare_module_or_interface false false en
              m.FStar_Syntax_Syntax.name mii
             in
          match uu____23680 with
          | (en1,pop_when_done) ->
              let en2 =
                let uu____23692 =
                  FStar_Syntax_DsEnv.set_current_module en1
                    m.FStar_Syntax_Syntax.name
                   in
                FStar_List.fold_left push_sigelt1 uu____23692
                  m.FStar_Syntax_Syntax.exports
                 in
              let env = FStar_Syntax_DsEnv.finish en2 m  in
              let uu____23694 =
                if pop_when_done
                then
                  FStar_Syntax_DsEnv.export_interface
                    m.FStar_Syntax_Syntax.name env
                else env  in
              ((), uu____23694)
  