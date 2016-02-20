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

func compareNumbers(var args: [SwispToken], pred: (Double, Double) -> Bool) throws -> SwispToken {
    var initial = try getFirstNumber(&args, msg: "Can't compare non-numeric values")
    for val in args {
        let next = val.atomicValue() as! Double
        if  !pred(initial, next) {return SwispToken.Boolean(false)}
        initial = next
    }
    return SwispToken.Boolean(true)

}