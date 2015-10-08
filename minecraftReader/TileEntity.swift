//
//  TileEntity.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/7/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation

class TileEntity {
    var tagData: NBTTag
    
    init(tag: NBTTag) {
        tagData = tag
    }
}