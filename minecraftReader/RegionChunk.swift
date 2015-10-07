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
        case GZIP = 1
        case ZLIB = 2
    }
    
    var chunkLength: UInt32
    var compression: ChunkCompression
    var chunkData: NSData
    var chunkNBT: NBTTag
    
    var chunkLocation: (x: Int, z: Int)?
    var biomes: [NSData]?
    var lightPopulated: NSData?
    var heightMap: [Int]?
    var data: [NSData]?
    var skyLight: [NSData]?
    var blockLight: [NSData]?
    var blocks: [NSData]?
    
    init(data: NSData) {

        
        var len: UInt32 = 0
        data.subdataWithRange(NSRange(location: 0, length: 4)).getBytes(&len, length: 4)
        chunkLength = len
        
        var comp: Int = 0
        data.subdataWithRange(NSRange(location: 4, length: 1)).getBytes(&comp, length: 1)
        compression = ChunkCompression(rawValue: comp)!
        
        chunkData = data.subdataWithRange(NSRange(location: 5, length: data.length - 5))
        
        chunkData = chunkData.zlibInflate()
        chunkNBT = NBTTag(data: chunkData)
        
        print(chunkNBT.description)
        processChunk()
//        print("\(chunkLocation)")
        
    }
    
    private func processChunk() {
        if let c = chunkNBT.compoundValue {
            for x in c {
                if let name = x.tagName where name == "Level" {
                    if let levelCompound = x.compoundValue {
                        for y in levelCompound {
                            var tempPos = (x: 0, z: 0)
                            var foundPos = false
                            if let name = y.tagName {
                                switch name {
                                case "Biomes":
                                    biomes = y.byteArrayValue
                                case "LightPopulated":
                                    lightPopulated = y.byteValue
                                case "xPos":
                                    if let i = y.intValue {
                                        tempPos.x = i
                                        foundPos = true
                                    }
                                case "zPos":
                                    if let i = y.intValue {
                                        tempPos.z = i
                                        foundPos = true
                                    }
                                default: break
                                }
                                if foundPos {
                                    chunkLocation = tempPos
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                }
            }
        }
    }
    
}