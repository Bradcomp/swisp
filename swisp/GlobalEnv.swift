//
//  File.swift
//  swisp
//
//  Created by Bradley Compton on 2/24/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

public var globalEnv: [SwispToken: SwispToken] = [
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
