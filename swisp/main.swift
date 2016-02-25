//
//  main.swift
//  swisp
//
//  Created by Bradley Compton on 2/15/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

/* TODO: Add a header to the repl
 * Add support for file processing
 * Add some help docs
 * */
func repl() {
    let prompt = "swisp >>"
    let env = Environment(env: globalEnv, parent: nil)
    while true {
        print(prompt, separator: "", terminator: " ")
        guard let inp = input() else { continue }
        let trimmedInput = inp.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if trimmedInput == "exit" { break }
        do {
            let expr = try parse(trimmedInput)
            let result = try env.eval(expr)
            print(result)
        } catch SwispError.ParserError(let message) {
            print(message)
        } catch SwispError.RuntimeError(let message){
            print(message)
        } catch {
            print("Something went wrong")
        }
    }
}

func finish() {
    print ("goodbye!")
}

repl()
exit(EXIT_SUCCESS)