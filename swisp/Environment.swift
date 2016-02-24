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
        .Symbol(">"): .Func(">", gt),
        .Symbol(">="): .Func(">=", gte),
        .Symbol("<"): .Func("<", lt),
        .Symbol("<="): .Func("<=", lte),
        .Symbol("="): .Func("=", numEq),
        .Symbol("abs"): .Func("abs", abs),
        .Symbol("append"): .Func("append", append),
        .Symbol("apply"): .Func("apply", apply),
        .Symbol("begin"): .Func("begin", begin),
        .Symbol("boolean?"): .Func("boolean?", isBoolean),
        .Symbol("car"): .Func("car", car),
        .Symbol("cdr"): .Func("cdr", cdr),
        .Symbol("cons"): .Func("cons", cons),
        .Symbol("equal?"): .Func("equal?", equal),
        .Symbol("length"): .Func("length", length),
        .Symbol("list"): .Func("list", list),
        .Symbol("list?"): .Func("list?", isList),
        .Symbol("map"): .Func("map", map),
        .Symbol("max"): .Func("max", max),
        .Symbol("min"): .Func("min", min),
        .Symbol("not"): .Func("not", not),
        .Symbol("null?"): .Func("null?", isNull),
        .Symbol("number?"): .Func("number?", isNumber),
        .Symbol("procedure?"): .Func("procedure?", isProcedure),
        .Symbol("round"): .Func("round", round),
        .Symbol("symbol?"): .Func("symbol?", isSymbol)
    ]

    internal func eval(x: SwispToken) throws -> SwispToken {
        var l: [SwispToken]
        //First, a destructuring switch to cover constants and variables
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
        case .Symbol("and"): return try and(l)
        case .Symbol("or"): return try or(l)
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
        if cond != SwispToken.Boolean(false) { return try eval(ifTrue) }
        return try eval(ifFalse)
    }
    
    private func and(args: [SwispToken]) throws -> SwispToken {
        var result = SwispToken.Boolean(true)
        for val in args {
            result = try eval(val)
            if result == SwispToken.Boolean(false) { break }
        }
        return result
    }
    
    private func or(args: [SwispToken]) throws -> SwispToken {
        var result = SwispToken.Boolean(false)
        for val in args {
            result = try eval(val)
            if result != SwispToken.Boolean(false) { break }
        }
        return result
    }
    
    private func applyFunction(f: SwispToken, args: [SwispToken]) throws -> SwispToken {
        let fun = try eval(f)
        switch fun {
        case .Func(let (_, function)): return try function(args.map() {tok in return try eval(tok)})
            default: throw SwispError.RuntimeError(message: "Tried to apply a non-function")
        }
        
    }
}
