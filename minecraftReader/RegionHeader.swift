//
//  RegionHeader.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/5/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation

class RegionHeader {
    var locations: [RegionLocation]
    var timestamps: NSData
    init(data: NSData) {

        locations = RegionLocation.translateDataToLocations(
            data.subdataWithRange(
                NSRange(location: 0, length: 4096)
            )
        )
        
        timestamps = data.subdataWithRange(NSRange(location: 4096, length: 4096))

        
    }
}