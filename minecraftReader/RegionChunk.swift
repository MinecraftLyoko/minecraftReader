//
//  RegionChunk.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/5/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation
import zlib


class RegionChunk {
    
    class func translateDataToChunks(data: NSData, header: RegionHeader) -> [RegionChunk] {
        var chunks = [RegionChunk]()
        
        for loc in header.locations {
            let subdata = data.subdataWithRange(NSRange(location: loc.offset.hashValue, length: loc.length.hashValue))
            chunks.append(RegionChunk(data: subdata))
        }
        return chunks
    }
    
    enum ChunkCompression: Int {
        case GZIP = 0
        case ZLIB = 1
    }
    
    var chunkLength: UInt32
    var compression: ChunkCompression
    var chunkData: NSData
    var chunkNBT: NBTTag
    
    init(data: NSData) {

        
        var len: UInt32 = 0
        data.subdataWithRange(NSRange(location: 0, length: 4)).getBytes(&len, length: 4)
        chunkLength = len
        
        var comp: Int = 0
        data.subdataWithRange(NSRange(location: 4, length: 1)).getBytes(&comp, length: 1)
        compression = ChunkCompression(rawValue: comp)!
        
        chunkData = data.subdataWithRange(NSRange(location: 5, length: data.length - 5))
        
        chunkData = chunkData.zlibDeflate()
        chunkNBT = NBTTag(data: chunkData)

        
    }
}