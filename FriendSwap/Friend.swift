//
//  Friend.swift
//  FriendSwap
//
//  Created by Erik van der Neut on 1/09/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

import SpriteKit

enum FriendType: Int, Printable
{
    case Unknown = 0, Croissant, Cupcake, Danish, Donut, Macaroon, SugarCookie
    
    var spriteName: String
    {
        let spriteNames = [ "Croissant", "Cupcake", "Danish", "Donut", "Macaroon", "SugarCookie"]
        return spriteNames[toRaw() - 1]
    }
    
    var highlightedSpriteName: String
    {
        let highlightedSpriteNames = [ "Croissant-Highlighted", "Cupcake-Highlighted", "Danish-Highlighted", "Donut-Highlighted", "Macaroon-Highlighted", "SugarCookie-Highlighted"]
        return highlightedSpriteNames[toRaw() - 1]
    }
    
    static func random() -> FriendType
    {
        // Get FriendType by converting a random number between 1 and 6 (because 0 is not a friend):
        return FriendType.fromRaw(Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String
    {
        return spriteName
    }
}

class Friend: Printable
{
    var column: Int                 // vertical position in the 2D grid
    var row: Int                    // horizontal position in the 2D grid
    let friendType: FriendType      // identifies which friend this is
    var sprite: SKSpriteNode?       // optional property, because sprite may not always be set
    
    init(column: Int, row: Int, friendType: FriendType)
    {
        self.column = column
        self.row = row
        self.friendType = friendType
    }
    
    var description: String
    {
        return "type:\(friendType) square:(\(column),\(row))"
    }
}
