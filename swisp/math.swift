//
//  functions.swift
//  swisp
//
//  Created by Bradley Compton on 2/17/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

func add(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirstNumber(&args, msg: "Adding non-numeric values")
    let result = args.reduce(initial) { (acc: Double,  val: SwispToken) in return acc + (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

func subtract(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirstNumber(&args, msg: "Subtracting non-numeric values")
    let result = args.reduce(initial) { (acc: Double,  val: SwispToken) in return acc - (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

func multiply(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirstNumber(&args, msg: "Multiplying non-numeric values")
    let result = args.reduce(initial) { (acc: Double,  val: SwispToken) in return acc * (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

func divide(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirstNumber(&args, msg: "Dividing non-numeric values")
    let result = try args.reduce(initial) {(acc, val) in
        let dividend = val.atomicValue() as! Double
        if dividend == 0 { throw SwispError.RuntimeError(message: "Divide by zero error") }
        return acc / dividend
    }
    return SwispToken.Number(result)
}

func abs(var args: [SwispToken]) throws -> SwispToken {
    if (!checkArity(1, args: args)) { throw SwispError.RuntimeError(message: "Too many arguments") }
    let initial = try getFirstNumber(&args, msg: "Absolute value of non numeric")
    if initial > 0 { return SwispToken.Number(initial) }
    return SwispToken.Number(-initial)
}

func max(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirstNumber(&args, msg: "Invalid argument to max")
    let result = args.reduce(initial) {(acc, val) in
        let value = val.atomicValue() as! Double
        return acc > value ? acc : value
    } 
    return SwispToken.Number(result)
}

func min(var args: [SwispToken]) throws -> SwispToken {
    let initial = try getFirstNumber(&args, msg: "Invalid argument to min")
    let result = args.reduce(initial) {(acc, val) in
        let value = val.atomicValue() as! Double
        return acc < value ? acc : value
    }
    return SwispToken.Number(result)
}



