//
//  Token.swift
//  swisp
//
//  Created by Erin Compton on 2/15/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

public enum SwispToken {
    case Float(Double)
    case Integer(Int)
    case Symbol(String)
    indirect case List([SwispToken])
}

public func ==(a: SwispToken, b: SwispToken) -> Bool {
    switch (a, b) {
    case (.Float(let t1), .Float(let t2)): return t1 == t2
    case (.Integer(let t1), .Integer(let t2)): return t1 == t2
    case (.Symbol(let t1), .Symbol(let t2)): return t1 == t2
    case (.List(let t1), .List(let t2)):
        return t1.count == t2.count && all(zip(t1, b: t2)){ tuple in return tuple.0 == tuple.1 }
    default: return false
    }
}

public func !=(a: SwispToken, b: SwispToken) -> Bool {
    return !(a == b)
}