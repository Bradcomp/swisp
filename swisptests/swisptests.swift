//
//  swisptests.swift
//  swisptests
//
//  Created by Erin Compton on 2/15/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import XCTest

class swisptests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testToken() {
        let tok = SwispToken.Number(5)
        let tok2 = SwispToken.Number(5)
        
        let tok3 = SwispToken.List([tok, tok2])
        let tok4 = SwispToken.List([tok2, tok])
        let tok5 = SwispToken.List([.Number(3.14), .Symbol("pi")])
        XCTAssert(tok == tok2, "Integer Check")
        XCTAssert(tok != tok3, "Int v List")
        XCTAssert(tok3 == tok4, "Equal Lists")
        XCTAssert(tok3 != tok5, "Unequal lists")
    }
    
    func testParse() {
        let code = "(begin (define r 10) (* 3.14 (* r r)))"
        let result = SwispToken.List([
            .Symbol("begin"),
            .List([
                .Symbol("define"),
                .Symbol("r"), .Number(10)
                ]),
            .List([
                .Symbol("*"),
                .Number(3.14),
                .List([
                    .Symbol("*"),
                    .Symbol("r"),
                    .Symbol("r")
                    ])
                ])
            ])
        XCTAssert(parse(code)! == result, "Parses an expression")
        XCTAssert(parse("(((a b c ))") == nil, "Returns nil for parse failure")
    }
    
    func testEval() {
        let env = Environment()
        let result = try! env.eval(parse("(+ 2 3 (- 7 3))")!)
        print(result.toString())
        XCTAssert(result == SwispToken.Number(9.0), "Expected 9, got \(result.toString())")
    }
    
}
