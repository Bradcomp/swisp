//
//  Environment.swift
//  swisp
//
//  Created by Bradley Compton on 2/16/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Cocoa

class Environment: NSObject {
    var env: [SwispToken: SwispToken] = [
        .Symbol("+"): .Func("+", add),
        .Symbol("-"): .Func("-", subtract),
        .Symbol("*"): .Func("*", multiply),
        .Symbol("/"): .Func("/", divide),
        .Symbol("abs"): .Func("abs", abs)
    ]
    let keywords = [
        "+", "-", "*", "/", "<", ">", "<=", ">=", "=",
        "abs", "append", "apply", "begin", "car", "cdr",
        "cons", "eq?", "equal?", "length", "list", "list?",
        "map", "max", "min", "not", "null?", "number?",
        "procedure?", "round", "symbol?"
    ]
    
    internal func eval(x: SwispToken) throws -> SwispToken {
        var l: [SwispToken]
        //First, a destructuring switch to cover constants and variables
        //do {
        switch x {
        case .Symbol:
            let tok = env[x]
            if tok == nil { throw SwispError.RuntimeError(message: "Unbound variable: \(x)")}
            return tok!
        case .List(let ls): l = ls
        default: return x
        }
        let proc = l.removeFirst()
        //Now, handle special forms
        switch proc {
        case .Symbol("quote"): return l.removeFirst()
        case .Symbol("if"): return try swispIf(l[0], ifTrue: l[1], ifFalse: l[2])
        case .Symbol("define"):
            let val = try eval(l[1])
            env[l[0]] = val
            return val
        default: break
        }
        return try applyFunction(proc, args: l)
        
    }
    private func swispIf(test: SwispToken, ifTrue: SwispToken, ifFalse: SwispToken) throws -> SwispToken {
        let cond = try eval(test)
        if cond == SwispToken.Boolean(true) { return try eval(ifTrue) }
        return try eval(ifFalse)
    }
    
    private func applyFunction(f: SwispToken, args: [SwispToken]) throws -> SwispToken {
        let fun = try eval(f)
        switch fun {
        case .Func(let (_, function)): return try function(args.map() {tok in return try eval(tok)})
            default: throw SwispError.RuntimeError(message: "Tried to apply a non-function")
        }
        
    }
}
