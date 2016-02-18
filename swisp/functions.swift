//
//  functions.swift
//  swisp
//
//  Created by Bradley Compton on 2/17/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

func add(args: [SwispToken]) throws -> SwispToken {
    if !checkTypes("Number", args: args) { throw SwispError.RuntimeError(message: "Adding non-numeric values") }
    let result = args.reduce(0.0) { (acc: Double,  val: SwispToken) in return acc + (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

func subtract(var args: [SwispToken]) throws -> SwispToken {
    if !checkTypes("Number", args: args) { throw SwispError.RuntimeError(message: "Subtracting non-numeric values") }
    let initial = args.removeFirst().atomicValue() as! Double
    let result = args.reduce(initial) { (acc: Double,  val: SwispToken) in return acc - (val.atomicValue() as! Double) }
    return SwispToken.Number(result)
}

private func checkTypes(tp: String, args: [SwispToken]) -> Bool {
    return all(args, pred: { arg in return arg.type() == tp})
}
