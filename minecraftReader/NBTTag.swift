//
//  NBTTag.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/6/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation

enum NBTTagID: Int {
    case End = 0
    case Byte = 1
    case Short = 2
    case Int = 3
    case Long = 4
    case Float = 5
    case Double = 6
    case Byte_Array = 7
    case String = 8
    case List = 9
    case Compound = 10
    case Int_Array = 11
    case Unknown = -1
    
}

class NBTTag {
    var ID: NBTTagID
    var tagData: NSData
    
    var byteValue: NSData?
    var shortValue: Int?
    var intValue: Int?
    var longValue: Double?
    var floatValue: Float?
    var doubleValue: Double?
    var byteArrayValue: [NSData]?
    var stringValue: String?
    var listValue: [AnyObject]?
    var compoundValue: [NBTTag]?
    var intArrayValue: [Int]?
    
    init(data: NSData) {
        var id: Int = 0

        data.subdataWithRange(NSRange(location: 0, length: 1)).getBytes(&id, length: 1)
        if id > -1 && id < 11 {
            ID = NBTTagID(rawValue: id)!
        } else {
            ID = NBTTagID(rawValue: -1)!
        }
        tagData = data.subdataWithRange(NSRange(location: 1, length: data.length - 1))
        print(id)
        print(ID)
    }
    
}