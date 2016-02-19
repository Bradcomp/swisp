//
//  Token.swift
//  swisp
//
//  Created by Bradley Compton on 2/15/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

public enum SwispToken: Hashable, CustomStringConvertible {
    case Number(Double)
    case Symbol(String)
    case Boolean(Bool)
    case Func(String, [SwispToken] throws -> SwispToken)
    indirect case List([SwispToken])
    
    public func type() -> String {
        switch self {
        case .Number: return "Number"
        case .Symbol: return "Symbol"
        case .Boolean: return "Boolean"
        case .Func: return "Function"
        case .List: return "List"
        }
    }
    
    public var description: String {
        get {
            switch self {
            case .Number(let v): return String(v)
            case .Symbol(let v): return v
            case .Boolean(let v): return v ? "true" : "false"
            case .Func(let (t, _)): return "Function: \(t)"
            case .List(let ls):
                let inner = ls.map({st in return st.description}).joinWithSeparator(" ")
                return "(\(inner))"
            }

        }
            }
    
    
    public func atomicValue() -> Any? {
        switch self {
        case .Boolean(let v): return v
        case .Number(let v): return v
        case .List(let v): return v
        case .Func(let (_, f)): return f
        default: return nil
        }
    }
    
    public var hashValue: Int {
        get {
            return "\(self.type()):\(self.description)".hashValue
        }
    }
}

public func ==(a: SwispToken, b: SwispToken) -> Bool {
    return a.hashValue == b.hashValue
}

public func !=(a: SwispToken, b: SwispToken) -> Bool {
    return !(a == b)
}

