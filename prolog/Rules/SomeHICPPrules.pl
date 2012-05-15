'child+'(Stmt, DirectChild) :-
        'Stmt::child'(Stmt, DirectChild).
'child+'(Stmt, IndirectChild) :-
        'Stmt::child'(Stmt, DirectChild),
        'child+'(DirectChild, IndirectChild).

calls(Caller, Callee) :-
        'Decl::body'(Caller, Body),
        'child+'(Body, CallExpr),
        ( 'Stmt::stmtClassName'(CallExpr, 'CallExpr')
        ; 'Stmt::stmtClassName'(CallExpr, 'CXXMemberCallExpr')
        ),
        'CallExpr::directCallee'(CallExpr, Callee).

'calls+'(Caller, Callee) :-
        calls(Caller, Callee).
'calls+'(Caller, IndirectCallee) :-
        calls(Caller, DirectCallee),
        'calls+'(DirectCallee, IndirectCallee).

violation('HICPP 3.3.13',
          'ctor/dtor %0 calls (maybe indirectly) virtual method %1',
          [ namedDecl(Caller, 'caller %0 declared here')
          , namedDecl(Callee, 'callee %0 declared here')]) :-
        isA(Record, 'CXXRecordDecl'),
        ( 'CXXRecordDecl::ctor'(Record, Caller)
        ; 'CXXRecordDecl::destructor'(Record, Caller)
        ),
        'CXXRecordDecl::method'(Record, Callee),
        'CXXMethodDecl::is_virtual'(Callee), % implies Caller \= Callee
        'calls+'(Caller, Callee).

violation_candidate('HICPP 3.4.2', [MethodRepr]) :-
        isA(Method, 'CXXMethodDecl'),
        'ValueDecl::type'(Method, MethodType),
        'QualType::canonicalType'(MethodType, CanonicalMethodType),
        isConstFunctionProtoType(CanonicalMethodType),
        'FunctionType::resultType'(CanonicalMethodType, ResultType),
        'QualType::canonicalType'(ResultType, CanonicalResultType),
        isA(CanonicalResultType, 'PointerType'),
        'QualType::typePtr'(CanonicalResultType, ResultTypePtr),
        'PointerType::pointeeType'(ResultTypePtr, PointeeType),
        'QualType::canonicalType'(PointeeType, CanonicalPointeeType),
        \+ 'QualType::is_constQualified'(CanonicalPointeeType),

                                % This part should be generated by
                                % CRISP compiler
        mangleName(Method, MethodRepr).

violation_llvm('HICPP 3.4.2',
               'const member function %0 returns a non-const handle to class data',
               ['Function'(Func)]) :-
        violation_candidate('HICPP 3.4.2', [FuncName]),
        isA_(Module, 'Module'),
        getFunction(Module, FuncName, Func),
        'Function::arg'(Func, This),
        'Value::name'(This, 'this'),
        'Function::instruction'(Func, StoreThis),
        isA_(StoreThis, 'StoreInst'),
        'StoreInst::valueOperand'(StoreThis, This),
        'StoreInst::pointerOperand'(StoreThis, ThisAddr),
        'Function::instruction'(Func, LoadThis),
        isA_(LoadThis, 'LoadInst'),
        'LoadInst::pointerOperand'(LoadThis, ThisAddr),
        'Function::instruction'(Func, OffsetFromThis),
        ( isA_(OffsetFromThis, 'GetElementPtrInst'),
          'GetElementPtrInst::pointerOperand'(OffsetFromThis, LoadThis)
        ; isA_(OffsetFromThis, 'BitCastInst'),
          'User::op'(OffsetFromThis, LoadThis)
        ),
        getLocation(OffsetFromThis, OffsetFromThisLoc),
        'Function::instruction'(Func, Return),
        isA_(Return, 'ReturnInst'),
        'User::op'(Return, UsedByReturn),
        getLocation(UsedByReturn, ReturnLoc),
        alias(OffsetFromThisLoc, ReturnLoc, AliasResult),
        AliasResult > 0.
