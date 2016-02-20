//
//  list.swift
//  swisp
//
//  Created by Bradley Compton on 2/18/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

func append(args: [SwispToken]) throws -> SwispToken {
    if !checkTypes("List", args: args) { throw SwispError.RuntimeError(message: "Can't append list and non-list") }
    var result = [SwispToken]()
    for tok in args {
        let next = tok.atomicValue() as! [SwispToken]
        result.appendContentsOf(next)
    }
    return SwispToken.List(result)
}

func apply(args: [SwispToken]) throws -> SwispToken {
    if !checkArity(2, args: args) { throw SwispError.RuntimeError(message: "apply called with the wrong number of arguments") }
    let f = args[0]
    let l = args[1]
    if f.type() != "Function" { throw SwispError.RuntimeError(message: "apply called with non-function first argument") }
    if l.type() != "List" { throw SwispError.RuntimeError(message: "apply called with non-list second argument") }
    let fun = f.atomicValue() as! [SwispToken] throws -> SwispToken
    let list = l.atomicValue() as! [SwispToken]
    return try fun(list)
}
