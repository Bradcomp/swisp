//
//  util.swift
//  swisp
//
//  Created by Erin Compton on 2/16/16.
//  Copyright © 2016 Bradley Compton. All rights reserved.
//

import Foundation

public func zip<T, U>(a: [T], b: [U]) -> [(T, U)] {
    let minCount = a.count < b.count ? a.count : b.count;
    var result: [(T, U)] = []
    for i in 0 ..< minCount {
        result.append((a[i], b[i]))
    }
    return result
}

public func all<T>(list: [T], pred: T-> Bool) -> Bool {
    for elem in list {
        if !pred(elem) { return false }
    }
    return true
}

public func any<T>(list: [T], pred: T -> Bool) -> Bool {
    for elem in list {
        if pred(elem) { return true }
    }
    return false
}