//
//  RegionChunk.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/5/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation

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
    
    
    init(data: NSData) {
        
        var len: UInt32 = 0
        data.subdataWithRange(NSRange(location: 0, length: 4)).getBytes(&len, length: 4)
        chunkLength = len
        
        var comp: Int = 0
        data.subdataWithRange(NSRange(location: 4, length: 1)).getBytes(&comp, length: 1)
        compression = ChunkCompression(rawValue: comp)!
        
        chunkData = data.subdataWithRange(NSRange(location: 5, length: data.length - 5))
        
        print(chunkLength)
        print(compression)
        print(chunkData.length)
        // Z_DATA_ERROR   The input data was corrupted (input stream not conforming to the zlib format or incorrect check value).
        // Z_STREAM_ERROR The stream structure was inconsistent (for example if next_in or next_out was NULL).
        // Z_MEM_ERROR    There was not enough memory.
        // Z_BUF_ERROR    No progress is possible or there was not enough room in the output buffer when Z_FINISH is used.
        do {
            try chunkData = chunkData.gunzippedData()
            print(chunkData.length)
        } catch let e as GzipError {
            print("unzip failed")
            print(e)
        } catch {
            print("what")
        }

        
    }
}