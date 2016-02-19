//
//  functions.swift
//  swisp
//
//  Created by Bradley Compton on 2/17/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

func add(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirst(&args, msg: "Adding non-numeric values")
    let result = args.reduce(initial) { (acc: Double,  val: SwispToken) in return acc + (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

func subtract(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirst(&args, msg: "Subtracting non-numeric values")
    let result = args.reduce(initial) { (acc: Double,  val: SwispToken) in return acc - (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

func multiply(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirst(&args, msg: "Multiplying non-numeric values")
    let result = args.reduce(initial) { (acc: Double,  val: SwispToken) in return acc * (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

func divide(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirst(&args, msg: "Dividing non-numeric values")
    let result = try args.reduce(initial) {(acc, val) in
        let dividend = val.atomicValue() as! Double
        if dividend == 0 { throw SwispError.RuntimeError(message: "Divide by zero error") }
        return acc / dividend
    }
    return SwispToken.Number(result)
}

func getFirst(inout args: [SwispToken], msg: String) throws -> Double {
    if !checkTypes("Number", args: args) { throw SwispError.RuntimeError(message: "Subtracting non-numeric values") }
    let initial = args.removeFirst().atomicValue() as! Double
    return initial
}

