//
//  Level.swift
//  FriendSwap
//
//  Created by Erik van der Neut on 1/09/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

import Foundation

// Constants:
let NumColumns = 9
let NumRows = 9

class Level
{
    let friends = Array2D<Friend>(columns: NumColumns, rows: NumRows)       // private
    
    func friendAtColumn(column: Int, row: Int) -> Friend?
    {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return friends[column, row]
    }
    
    func shuffle() -> Set<Friend>
    {
        var set = Set<Friend>()
        
        // Loop through rows and columns of 2D array:
        for row in 0..<NumRows
        {
            for column in 0..<NumColumns
            {
                // Pick random friend:
                var friendType = FriendType.random()
                
                // Create new friend object and add to the grid:
                let friend = Friend(column: column, row: row, friendType: friendType)
                friends[column, row] = friend
                
                // Add new friend to the set:
                set.addElement(friend)
            }
        }
        
        return set
    }
}
