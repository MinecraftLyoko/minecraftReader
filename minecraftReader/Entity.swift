//
//  Entity.swift
//  minecraftReader
//
//  Created by Rhett Rogers on 10/7/15.
//  Copyright © 2015 Rhett Rogers. All rights reserved.
//

import Foundation

class Entity {
    var ID: String = "" // This tag does not exist for the Player entity.
    var pos: (x: Double, y: Double, z: Double) = (0,0,0) //describing the current X,Y,Z position of the entity.
    var motion: (dX: Double, dY: Double, dZ: Double) = (0,0,0) //describing the current dX,dY,dZ velocity of the entity in meters per tick.
    
    var rotation: (yaw: Float, pitch: Float) = (0,0) // representing rotation in degrees.
    /* 
    The entity's rotation clockwise around the Y axis (called yaw). Due west is 0. Does not exceed 360 degrees.

    The entity's declination from the horizon (called pitch). Horizontal is 0. Positive values look downward. Does not exceed positive or negative 90 degrees.
    */
    
    var fallDistance: Float = 0 //Distance the entity has fallen. Larger values cause more damage when the entity lands.
    
    var fire: Int = -20 //Number of ticks until the fire is put out. Negative values reflect how long the entity can stand in fire before burning. Default -20 when not on fire.
    var air: Int = 300 //How much air the entity has, in ticks. Fills to a maximum of 300 in air, giving 15 seconds submerged before the entity starts to drown, and a total of up to 35 seconds before the entity dies (if it has 20 health). Decreases while underwater. If 0 while underwater, the entity loses 1 health per second.
    var onGround: Bool = true // true if the entity is touching the ground.
    
    enum Dimension:Int {
        case Nether = -1
        case Overworld = 0
        case End = 1
    }
    
    var dimension: Dimension = .Overworld //Unknown usage; entities are only saved in the region files for the dimension they are in. -1 for The Nether, 0 for The Overworld, and 1 for The End.
    var invunerable: Bool = false //true if the entity should not take damage. This applies to living and nonliving entities alike: mobs will not take damage from any source (including potion effects), and cannot be moved by fishing rods, attacks, explosions, or projectiles, and objects such as vehicles and item frames cannot be destroyed unless their supports are removed. Note that these entities can be damaged by players in Creative mode.
    var portalCooldown: Int = 0 // The number of ticks before which the entity may be teleported back through a portal of any kind. Initially starts at 900 ticks (45 seconds) after teleportation and counts down to 0.
    var UUIDMost: Int = 0 //The most significant bits of this entity's Universally Unique IDentifier. This is joined with UUIDLeast to form this entity's unique ID.
    var UUIDLeast: Int = 0 //The least significant bits of this entity's Universally Unique IDentifier.
    /*
        UUID: The Universally Unique IDentifier of this entity. Converts a hexadecimal UUID (for example: 069a79f4-44e9-4726-a5be-fca90e38aaf5) into the UUIDLeast and UUIDMost tags. Will not apply new UUIDLeast and UUIDMost tags if both of these tags are already present. The "UUID" tag is removed once the entity is loaded. As of 1.9, the UUID is ignored in the /summon command.
    */
    
    var customName: String = ""//The custom name of this entity. Appears in player death messages and villager trading interfaces, as well as above the entity when your cursor is over it. May not exist, or may exist and be empty.
    var customNameVisible: Bool = false //if true, and this entity has a custom name, it will always appear above them, whether or not the cursor is pointing at it. If the entity hasn't a custom name, a default name will be shown. May not exist.
    var silent: Bool = false //if true, this entity will not make sound. May not exist.
    
    var glowing:Bool = false //true if the entity is glowing.
    var tags = [String]() //List of custom string data.
    
    var commandStats = [NBTTag]() //Information identifying scoreboard parameters to modify relative to the last command run
    /*
    SuccessCountObjective: Objective's name about success of the last command (will be a boolean)
    SuccessCountName: Fake player name about success of the last command
    AffectedBlocksObjective: Objective's name about how many blocks were modified in the last command (will be an int)
    AffectedBlocksName: Fake player name about how many blocks were modified in the last command
    AffectedEntitiesObjective: Objective's name about how many entities were altered in the last command (will be an int)
    AffectedEntitiesName: Fake player name about how many entities were altered in the last command
    AffectedItemsObjective: Objective's name about how many items were altered in the last command (will be an int)
    AffectedItemsName: Fake player name about how many items were altered in the last command
    QueryResultObjective: Objective's name about the query result of the last command
    QueryResultName: Fake player name about the query result of the last command
    */
    
    /*
    Non implemented
    
    Riding: (deprecated since 15w41a) The data of the entity being ridden. Note that if an entity is being ridden, the topmost entity in the stack has the Pos tag, and the coordinates specify the location of the bottommost entity. Also note that the bottommost entity controls movement, while the topmost entity determines spawning conditions when created by a mob spawner.
    See this format (recursive).
    
    Passengers(since 15w41a): The data of the entity ridding. Note that both entities control movement and the topmost entity controls spawning conditions when created by a mob spawner.
    See this format (recursive).
    */
    
    enum EntityError: ErrorType {
        case NotACompoundTag
    }
    
    init(tag: NBTTag) throws {
        if let c = tag.compoundValue {
            for x in c {
                if let name = x.tagName {
                    switch name {
                    case "id":
                        if let s = x.stringValue {
                            ID = s
                        }
                    case "Pos":
                        if let l = x.listValue {
                            let xPos = l[0].doubleValue!
                            let yPos = l[1].doubleValue!
                            let zPos = l[2].doubleValue!
                            pos = (xPos, yPos, zPos)
                            
                            
                        }
                    case "Motion":
                        if let l = x.listValue {
                            let dX = l[0].doubleValue!
                            let dY = l[1].doubleValue!
                            let dZ = l[2].doubleValue!
                            motion = (dX, dY, dZ)
                        }
                    case "Rotation":
                        if let l = x.listValue {
                            let yaw = l[0].floatValue!
                            let pitch = l[1].floatValue!
                            rotation = (yaw, pitch)
                        }
                    case "FallDistance":
                        if let f = x.floatValue {
                            fallDistance = f
                        }
                    case "Fire":
                        if let i = x.intValue {
                            fire = i
                        }
                    case "Air":
                        if let i = x.intValue {
                            air = i
                        }
                    case "OnGround":
                        if let b = x.byteValue {
                            onGround = b.toBool()
                        }
                    case "Dimension":
                        if let i = x.intValue where (i < 2 && i > -2) {
                            dimension = Dimension(rawValue: i)!
                        }
                    case "Invunerable":
                        if let b = x.byteValue {
                            invunerable = b.toBool()
                        }
                    case "PortalCooldown":
                        if let i = x.intValue {
                            portalCooldown = i
                        }
                    case "UUIDMost":
                        if let l = x.longValue {
                            UUIDMost = l
                        }
                    case "UUIDLeast":
                        if let l = x.longValue {
                            UUIDLeast = l
                        }
                    case "CustomName":
                        if let s = x.stringValue {
                            customName = s
                        }
                    case "CustomNameVisible":
                        if let b = x.byteValue {
                            customNameVisible = b.toBool()
                        }
                    case "Silent":
                        if let b = x.byteValue {
                            silent = b.toBool()
                        }
                    case "Glowing":
                        if let b = x.byteValue {
                            glowing = b.toBool()
                        }
                    default: break
                    }
                }
            }
        } else {
            throw EntityError.NotACompoundTag
        }
    }
    
    
}