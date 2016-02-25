//
//  Environment.swift
//  swisp
//
//  Created by Bradley Compton on 2/16/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Cocoa

class Environment: NSObject {
    var env: [SwispToken: SwispToken]
    var parent: Environment?
    init(env: [SwispToken: SwispToken], parent: Environment?) {
        self.env = env
        self.parent = parent
    }
    internal func eval(x: SwispToken) throws -> SwispToken {
        var l: [SwispToken]
        //First, a destructuring switch to cover constants and variables
        switch x {
        case .Symbol:
            return try lookup(x)
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
    private func lookup(key: SwispToken) throws -> SwispToken {
        if let tok = env[key] { return tok }
        guard let p = parent else { throw SwispError.RuntimeError(message: "Unbound variable \(key)") }
        return try p.lookup(key)
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
