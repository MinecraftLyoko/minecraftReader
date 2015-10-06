//
//  Region.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/5/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation


class Region {
    let header: RegionHeader
    let chunks: [RegionChunk]
    
    init(data: NSData) {
        header = RegionHeader(data: data.subdataWithRange(NSRange(location: 0, length: 8192)))
        chunks = RegionChunk.translateDataToChunks(data, header: header)
    }
}