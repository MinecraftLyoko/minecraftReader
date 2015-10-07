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
    var tagName: String?
    
    var byteValue: NSData?
    var shortValue: Int?
    var intValue: Int?
    var longValue: Int?
    var floatValue: Float32?
    var doubleValue: Double?
    var byteArrayValue: [NSData]?
    var stringValue: String?
    var listValue: [NBTTag]?
    var compoundValue: [NBTTag]?
    var intArrayValue: [Int]?
    
    var dataLength: Int = 0
    
    init(data: NSData, hasName: Bool = true) {
        var id: Int = 0

        data.subdataWithRange(NSRange(location: 0, length: 1)).getBytes(&id, length: 1)
        if id > -1 && id < 12 {
            ID = NBTTagID(rawValue: id)!
        } else {
            ID = NBTTagID(rawValue: -1)!
        }


        tagData = data.subdataWithRange(NSRange(location: 1, length: data.length - 1))
        dataLength = dataLength + 1
        
        if hasName {
            parseName()
        }
        processTagData()
    }
    
    init(data: NSData, withID tagID: NBTTagID, hasName: Bool = true) {
        ID = tagID
        tagData = data
        
        if hasName {
            parseName()
        }
        
        processTagData()
        
    }
    
    func processTagData() {
        switch ID {
        case .Byte:
            byteValue = tagData.subdataWithRange(NSRange(location: 0, length: 1))
            parseData(1)
        case .Short:
            shortValue = parseShort()
        case .Int:
            intValue = parseInt()
        case .Long:
            longValue = parseLong()
        case .Float:
            floatValue = parseFloat()
        case .Double:
            doubleValue = parseDouble()
        case .Byte_Array:
            byteArrayValue = parseByteArray()
        case .String:
            stringValue = parseString()
        case .List:
            listValue = parseList()
        case .Compound:
            compoundValue = parseCompound()
        case .Int_Array:
            intArrayValue = parseIntArray()
        case .End:
//            print("end of line")
            break
        default:
            print("tag data corrupt")
        }
    }
    
    
    func parseShort() -> Int {
        let lengthData = [
            tagData.subdataWithRange(NSRange(location: 0, length: 1)),
            tagData.subdataWithRange(NSRange(location: 1, length: 1))
        ]
        var len1: Int8 = 0
        let ld = NSMutableData()
        ld.appendData(lengthData[1])
        ld.appendData(lengthData[0])
        ld.getBytes(&len1, length: 2)
        parseData(2)
        return Int(len1)
    }
    
    func parseInt() -> Int {
        let lengthData = [
            tagData.subdataWithRange(NSRange(location: 0, length: 1)),
            tagData.subdataWithRange(NSRange(location: 1, length: 1)),
            tagData.subdataWithRange(NSRange(location: 2, length: 1)),
            tagData.subdataWithRange(NSRange(location: 3, length: 1))
        ]
        var len1: Int16 = 0
        let ld = NSMutableData()
        ld.appendData(lengthData[3])
        ld.appendData(lengthData[2])
        ld.appendData(lengthData[1])
        ld.appendData(lengthData[0])
        ld.getBytes(&len1, length: 4)
        parseData(4)
        return Int(len1)
    }
    
    func parseLong() -> Int {
        let lengthData = [
            tagData.subdataWithRange(NSRange(location: 0, length: 1)),
            tagData.subdataWithRange(NSRange(location: 1, length: 1)),
            tagData.subdataWithRange(NSRange(location: 2, length: 1)),
            tagData.subdataWithRange(NSRange(location: 3, length: 1)),
            tagData.subdataWithRange(NSRange(location: 4, length: 1)),
            tagData.subdataWithRange(NSRange(location: 5, length: 1)),
            tagData.subdataWithRange(NSRange(location: 6, length: 1)),
            tagData.subdataWithRange(NSRange(location: 7, length: 1))
        ]
        
        var len1: Int = 0
        let ld = NSMutableData()
        ld.appendData(lengthData[7])
        ld.appendData(lengthData[6])
        ld.appendData(lengthData[5])
        ld.appendData(lengthData[4])
        ld.appendData(lengthData[3])
        ld.appendData(lengthData[2])
        ld.appendData(lengthData[1])
        ld.appendData(lengthData[0])
        parseData(8)
        ld.getBytes(&len1, length: 8)
        return len1

    }
    
    func parseDouble() -> Double {
        let lengthData = [
            tagData.subdataWithRange(NSRange(location: 0, length: 1)),
            tagData.subdataWithRange(NSRange(location: 1, length: 1)),
            tagData.subdataWithRange(NSRange(location: 2, length: 1)),
            tagData.subdataWithRange(NSRange(location: 3, length: 1)),
            tagData.subdataWithRange(NSRange(location: 4, length: 1)),
            tagData.subdataWithRange(NSRange(location: 5, length: 1)),
            tagData.subdataWithRange(NSRange(location: 6, length: 1)),
            tagData.subdataWithRange(NSRange(location: 7, length: 1))
        ]
        
        var len1: Double = 0
        let ld = NSMutableData()
        ld.appendData(lengthData[7])
        ld.appendData(lengthData[6])
        ld.appendData(lengthData[5])
        ld.appendData(lengthData[4])
        ld.appendData(lengthData[3])
        ld.appendData(lengthData[2])
        ld.appendData(lengthData[1])
        ld.appendData(lengthData[0])
        parseData(8)
        ld.getBytes(&len1, length: 8)
        
        return len1
    }
    
    func parseFloat() -> Float32 {
        let lengthData = [
            tagData.subdataWithRange(NSRange(location: 0, length: 1)),
            tagData.subdataWithRange(NSRange(location: 1, length: 1)),
            tagData.subdataWithRange(NSRange(location: 2, length: 1)),
            tagData.subdataWithRange(NSRange(location: 3, length: 1))
        ]

        let ld = NSMutableData()
        ld.appendData(lengthData[3])
        ld.appendData(lengthData[2])
        ld.appendData(lengthData[1])
        ld.appendData(lengthData[0])
        var fl: Float32 = 0
        ld.getBytes(&fl, length: 4)
        parseData(4)
        return fl
    }
    
    func parseString() -> String {
        let len = parseShort()
        let stringData = tagData.subdataWithRange(NSRange(location: 0, length: len))
        let value = NSString(data: stringData, encoding: NSUTF8StringEncoding) as? String
        parseData(len)
        if let s = value {
            return s
        } else {
            print("error parsing string")
            return ""
        }
    }
    
    func parseList() -> [NBTTag] {
        var arr = [NBTTag]()
        var id: Int = 0
        tagData.subdataWithRange(NSRange(location: 0, length: 1)).getBytes(&id, length: 1)
        var listType: NBTTagID = .Unknown
        if id > -1 && id < 12 {
            listType = NBTTagID(rawValue: id)!
        } else {
            listType = NBTTagID(rawValue: -1)!
        }
        parseData(1)
        
        let listLength = parseInt()
        
        for var x = 0; x < listLength; x++ {
            let newTag = NBTTag(data: tagData, withID: listType, hasName: false)
            parseData(newTag.dataLength)
            arr.append(newTag)
        }
        
        return arr
    }
    
    func parseCompound() -> [NBTTag] {
        var arr = [NBTTag]()
        var noEnd = false
        while !noEnd {
            let nextTag = NBTTag(data: tagData)
            arr.append(nextTag)
            noEnd = (nextTag.ID == .End) || (nextTag.ID == .Unknown)
            parseData(nextTag.dataLength)
        }
        return arr
    }
    
    func parseByteArray() -> [NSData] {
        var arr = [NSData]()
        let length = parseInt()
        for var x = 0; x < length; x++ {
            arr.append(tagData.subdataWithRange(NSRange(location: 0, length: 1)))
            parseData(1)
        }
        return arr
        
    }
    
    func parseIntArray() -> [Int] {
        var arr = [Int]()
        let length = parseInt()
        for var x = 0; x < length; x++ {
            arr.append(parseInt())
        }
        return arr
        
    }
    
    func parseData(length: Int) {
        tagData = tagData.subdataWithRange(NSRange(location: length, length: tagData.length - length))
        dataLength = dataLength + length
    }
    
    
    
    func parseName() {
        switch ID {
        case .Byte, .Short,
        .Int, .Long,
        .Float, .Double,
        .Byte_Array,
        .String, .List,
        .Compound, .Int_Array:
            tagName = parseString()
            
        case .End: return
        default: return
        }
    }
    
    var description: String {
        var returnString = ""
        if let t = tagName {
            returnString += "\(t) "
        }
        returnString += "(\(ID)): "
        switch ID {
        case .Byte:
            if let b = byteValue {
                returnString = "\(returnString)\(b)"
            }
        case .Short:
            if let s = shortValue {
                returnString = "\(returnString)\(s)"
            }
        case .Int:
            if let i = intValue {
                returnString = "\(returnString)\(i)"
            }
        case .Double:
            if let d = doubleValue {
                returnString = "\(returnString)\(d)"
            }
        case .Float:
            if let f = floatValue {
                returnString = "\(returnString)\(f)"
            }
        case .Long:
            if let l = longValue {
                returnString = "\(returnString)\(l)"
            }
        case .String:
            if let s = stringValue {
                returnString = "\(returnString)\(s)"
            }
        case .Compound:
            if let c = compoundValue {
                returnString += "["
                
                
                if c.count > 0 && c[0].ID != .End {
                    returnString += "\n"
                }
                
                for x in c {
                    if x.ID == .End {
                        continue
                    }
                    
                    returnString += "\(x.description)"
                    returnString += "\n"
                }
                returnString += "]"
            }
        case .List:
            if let l = listValue {
                returnString += "["
                if l.count > 0 {
                    returnString += "\n"
                }
                for x in l {
                    returnString += "\(x.description)"
                    returnString += "\n"
                }
                returnString += "]"
            }
        case .Byte_Array:
            if let b = byteArrayValue {
                returnString = "\(returnString)\(b.count)"
            }
        case .Int_Array:
            if let i = intArrayValue {
                returnString = "\(returnString)\(i.count)"
            }
        case .End:
            returnString = ""
        default:
            returnString = "\(returnString) not ready yet"

        }
        
        return returnString
    }
    
}