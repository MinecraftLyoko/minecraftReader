//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let a = 1...3

var region: (Int, Int) = (-1, -1)
var blocks = (
    (region.0 * 32 * 16)...((region.0 + 1)*32*16),
    (region.1 * 32 * 16)...((region.1 + 1)*32*16)
)



let c: UInt32 = 4960234

let b: Int = c.hashValue