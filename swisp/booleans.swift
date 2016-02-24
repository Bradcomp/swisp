//
//  booleans.swift
//  swisp
//
//  Created by Bradley Compton on 2/18/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

func gt(args: [SwispToken]) throws -> SwispToken {
    return try compareNumbers(args) {(a, b) in return a > b }
}

func gte(args: [SwispToken]) throws -> SwispToken {
    return try compareNumbers(args) {(a, b) in return a >= b }
}

func lt(args: [SwispToken]) throws -> SwispToken {
    return try compareNumbers(args) {(a, b) in return a < b }
}

func lte(args: [SwispToken]) throws -> SwispToken {
    return try compareNumbers(args) {(a, b) in return a <= b }
}

func numEq(args: [SwispToken]) throws -> SwispToken {
    return try compareNumbers(args) {(a, b) in return a == b }
}

/*
 * Currently only implementing value equality.  No reference equality for now.
 * */
func equal(args: [SwispToken]) throws -> SwispToken {
    if args.count < 2 { throw SwispError.RuntimeError(message: "Not enough arguments to equal?") }
    return SwispToken.Boolean(all(args) { val in return val == args[0] })
}

func isNull(args: [SwispToken]) throws -> SwispToken {
    if !checkArity(1, args: args) { throw SwispError.RuntimeError(message: "Too many arguments to null?") }
    return SwispToken.Boolean(args[0] == SwispToken.List([]))
}

func isList(args: [SwispToken]) throws -> SwispToken {
    return try isType(.List, args: args)
}

func isBoolean(args: [SwispToken]) throws -> SwispToken {
    return try isType(.Boolean, args: args)
}

func isNumber(args: [SwispToken]) throws -> SwispToken {
    return try isType(.Number, args: args)
}

func isProcedure(args: [SwispToken]) throws -> SwispToken {
    return try isType(.Function, args: args)
}

func isSymbol(args: [SwispToken]) throws -> SwispToken {
    return try isType(.Symbol, args: args)
}

func not(args: [SwispToken]) throws -> SwispToken{
    if !checkArity(1, args: args) { throw SwispError.RuntimeError(message: "Too many arguments to not") }
    return args[0] == SwispToken.Boolean(false) ? SwispToken.Boolean(true) : SwispToken.Boolean(false)
}
 
func compareNumbers(var args: [SwispToken], pred: (Double, Double) -> Bool) throws -> SwispToken {
    var initial = try getFirstNumber(&args, msg: "Can't compare non-numeric values")
    for val in args {
        let next = val.atomicValue() as! Double
        if  !pred(initial, next) {return SwispToken.Boolean(false)}
        initial = next
    }
    return SwispToken.Boolean(true)
}

func isType(tp: TokenType, args: [SwispToken]) throws -> SwispToken {
    if !checkArity(1, args: args) { throw SwispError.RuntimeError(message: "Too many arguments") }
    return SwispToken.Boolean(args[0].type() == tp)
}