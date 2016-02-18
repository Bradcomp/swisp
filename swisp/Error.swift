//
//  Error.swift
//  swisp
//
//  Created by Bradley Compton on 2/16/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

enum SwispError: ErrorType {
    case ParserError(message: String)
    case RuntimeError(message: String)
}