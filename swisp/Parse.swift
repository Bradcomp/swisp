//
//  Parse.swift
//  swisp
//
//  Created by Bradley Compton on 2/16/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

public func parse(code: String) throws -> SwispToken {
    var tokens = tokenize(code)
    let ast = try readFromTokens(&tokens)
    return ast
}

func tokenize(code: String) -> [String] {
    return code
        .stringByReplacingOccurrencesOfString("(", withString: " ( ")
        .stringByReplacingOccurrencesOfString(")", withString: " ) ")
        .componentsSeparatedByString(" ")
        .filter() { s in return !s.isEmpty }
}

func readFromTokens(inout tokens: [String]) throws -> SwispToken {
    if tokens.count == 0 { throw SwispError.ParserError(message: "Unexpected EOF while Parsing") }
    let head = tokens.removeFirst()
    if head == "(" {
        var subList: [SwispToken] = []
        while true {
            if tokens.count > 0 && tokens[0] == ")" { break }
            guard let next = try? readFromTokens(&tokens) else { throw SwispError.ParserError(message: "Unexpected EOF while Parsing") }
            subList.append(next)
        }
        let _ = tokens.removeFirst()
        return SwispToken.List(subList)
        
    } else if head == ")" {
        throw SwispError.ParserError(message: "Invalid ')' found")
    } else {
        return atom(head)
    }
}

func atom(token: String) -> SwispToken {
    if let tok = Double(token) { return SwispToken.Number(tok) }
    return SwispToken.Symbol(token)
}