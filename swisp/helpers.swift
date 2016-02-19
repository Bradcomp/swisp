//
//  helpers.swift
//  swisp
//
//  Created by Erin Compton on 2/18/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

func checkTypes(tp: String, args: [SwispToken]) -> Bool {
    return all(args, pred: { arg in return arg.type() == tp})
}

func checkArity(arity: Int, args: [SwispToken]) -> Bool {
    return args.count == arity
}