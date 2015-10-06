//
//  main.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/5/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//
import Foundation

let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DesktopDirectory, NSSearchPathDomainMask.UserDomainMask, true)

let file = "/tardis/Olympia/region/r.0.0.mca" // My change to your code - yours is presumably set off-screen

let dir = dirs[0]; //documents directory
let path = "\(dir)\(file)"

//read
if let content = NSData(contentsOfURL: NSURL(fileURLWithPath: path)) {
    let region = Region(data: content)
}