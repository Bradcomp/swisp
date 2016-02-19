//
//  main.swift
//  swisp
//
//  Created by Bradley Compton on 2/15/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation


func repl() {
    let prompt = "swisp >>"
    let env = Environment()
    while true {
        print(prompt, separator: "", terminator: " ")
        let inp = input()
        if inp == "exit\n" { break }
        do {
            let expr = try parse(inp)
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