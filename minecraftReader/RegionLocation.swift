//
//  RegionLocation.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/5/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation


class RegionLocation {
    var offset: UInt32
    var length: UInt32
    var timestamp: NSDate?
    
    class func translateDataToLocations(data: NSData) -> [RegionLocation] {
        var locs = [RegionLocation]()
        for x in 0...(data.length/4) - 1 {
            locs.append(RegionLocation(data: data.subdataWithRange(NSRange(location: x * 4, length: 4))))
        }
//        locs = locs.sort { (one, two) -> Bool in
//            return one.offset < two.offset
//        }
//        
        
        return locs
    }
    
    init(data: NSData) {

        let offsetData = [
            data.subdataWithRange(NSRange(location: 0, length: 1)),
            data.subdataWithRange(NSRange(location: 1, length: 1)),
            data.subdataWithRange(NSRange(location: 2, length: 1))
        ]
        let lengthData = data.subdataWithRange(NSRange(location: 3,length: 1))
        var point: UInt32 = 0
        var off: UInt32 = 0
        lengthData.getBytes(&point, length: 1)
        length = point << 12
        

        
        offsetData[0].getBytes(&off, length: 1)
        offset = off << 16
        offsetData[1].getBytes(&off, length: 1)
        offset += off << 8
        offsetData[2].getBytes(&off, length: 1)
        offset += off
        offset <<= 12
        
//        offsetData.getBytes(&off, length: 3)
//        offset = off >> 12


        
        
        
    }
    
    var description: String {
        return "\(length), \(offset)"
    }
}