//
//  Swap.swift
//  FriendSwap
//
//  Object to describe an attempted swap between two friends.
//
//  Created by Erik van der Neut on 20/10/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

struct Swap: Printable
{
    let friendA: Friend
    let friendB: Friend
    
    init(friendA: Friend, friendB: Friend)
    {
        self.friendA = friendA
        self.friendB = friendB
    }
    
    var description: String
    {
        return "Swap \(friendA) with \(friendB)"
    }
}