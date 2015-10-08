//
//  NSData+toBool.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/7/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation

extension NSData {
    func toBool() -> Bool {
        var a: Int = -1
        self.getBytes(&a, length: 1)
        if a < 0 {
            a = 0
        }
        return Bool(a)
    }
    
    func toInt() -> Int {
        var a = Int()
        self.getBytes(&a, length: 1)
        return a
    }
}