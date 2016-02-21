//
//  list.swift
//  swisp
//
//  Created by Bradley Compton on 2/18/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

func append(args: [SwispToken]) throws -> SwispToken {
    if !checkTypes(.List, args: args) { throw SwispError.RuntimeError(message: "Can't append list and non-list") }
    var result = [SwispToken]()
    for tok in args {
        let next = tok.atomicValue() as! [SwispToken]
        result.appendContentsOf(next)
    }
    return SwispToken.List(result)
}

func apply(args: [SwispToken]) throws -> SwispToken {
    if !checkArity(2, args: args) { throw SwispError.RuntimeError(message: "apply called with the wrong number of arguments") }
    switch (args[0], args[1]) {
    case (.Func(let (_, fun)), .List(let ls)): return try fun(ls)
    default:  throw SwispError.RuntimeError(message: "apply called with invalid arguments")
    }
}

func begin(args: [SwispToken]) throws -> SwispToken {
    return args.last
}

/*
 * Currently lisp `pairs` are implemented as arrays of tokens with a type of `List` which makes
 * these functions a little non standard.  This may be fixed in a future release, if I switch the
 * data structure I'm using for lists.
 * */
func car(args: [SwispToken]) throws -> SwispToken {
    if args.count == 0 { throw SwispError.RuntimeError(message: "car of an empty list") }
    return args[0]
}

func cdr(var args: [SwispToken]) throws -> SwispToken {
    if args.count == 0 { throw SwispError.RuntimeError(message: "cdr of an empty list") }
    if args.count == 1 { return SwispToken.List([]) }
    args.removeFirst()
    return SwispToken.List(args)
}

func cons(args: [SwispToken]) throws -> SwispToken {
    if !checkArity(2, args: args) { throw SwispError.RuntimeError(message: "cons called with the wrong number of arguments") }
    let car = SwispToken.List([args[0]])
    return try append([car, args[1]])
}

func length(args: [SwispToken]) throws -> SwispToken {
    if !checkArity(1, args: args) { throw SwispError.RuntimeError(message: "length called with the wrong number of arguments") }
    switch args[0] {
    case .List(let ls): return SwispToken.Number(Double(ls.count))
    default:  throw SwispError.RuntimeError(message: "length called on non-list object") 
    }
}

func list(args: [SwispToken]) throws -> SwispToken {
    return SwispToken.List(args)
}

func map(args: [SwispToken]) throws -> SwispToken {
    if !checkArity(2, args: args) { throw SwispError.RuntimeError(message: "map called with the wrong number of arguments") }
    switch (args[0], args[1]) {
    case (.Func(let (_, fun)), .List(let ls)): return try SwispToken.List(ls.map { tok in return try fun([tok]) })
    default:  throw SwispError.RuntimeError(message: "map called with invalid arguments")
    }
}


