//
//  Swap.swift
//  FriendSwap
//
//  Object to describe an attempted swap between two friends.
//
//  Created by Erik van der Neut on 20/10/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

func ==(lhs: Swap, rhs: Swap) -> Bool
{
    return (lhs.friendA.hashValue == rhs.friendA.hashValue && lhs.friendB.hashValue == rhs.friendB.hashValue) ||
           (lhs.friendB.hashValue == rhs.friendA.hashValue && lhs.friendA.hashValue == rhs.friendB.hashValue)
}

struct Swap: Printable, Hashable
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
    
    var hashValue: Int
    {
        // Combine hash values of the two friends with the exclusive-or (XOR) operator:
        return friendA.hashValue ^ friendB.hashValue
    }
}