//
//  Level.swift
//  FriendSwap
//
//  Created by Erik van der Neut on 1/09/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

import Foundation

// MARK: - Constants:

let NumColumns = 9
let NumRows = 9

// MARK: - Class definition:

class Level
{
    // MARK: - Properties:
    
    let friends = Array2D<Friend>(columns: NumColumns, rows: NumRows)       // friends keeps track of the friend objects in the level
    let tiles   = Array2D<Tile>(columns: NumColumns, rows: NumRows)         // tiles describes structure of the level
    
    // MARK: - Methods:
    
    init(filename: String)
    {
        // Load the JSON level file into a dictionary object:
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename)
        {
            // Array named "tiles" contains an array for each row of the level:
            if let tilesArray: AnyObject = dictionary["tiles"]
            {
                // Step through each row:
                for (row, rowArray) in enumerate(tilesArray as [[Int]])
                {
                    // Reverse order of rows, because 0,0 is at bottom in SpriteKit:
                    let tileRow = NumRows - row - 1
                    
                    // Step through columns in current row and create Tile whenever you find 1:
                    for (column, value) in enumerate(rowArray)
                    {
                        if value == 1
                        {
                            tiles[column, tileRow] = Tile()
                        }
                    }
                }
            }
        }
    }
    
    func friendAtColumn(column: Int, row: Int) -> Friend?
    {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return friends[column, row]
    }
    
    func shuffle() -> Set<Friend>
    {
        return createInitialFriends()
    }
    
    func createInitialFriends() -> Set<Friend>
    {
        var set = Set<Friend>()
        
        // Loop through rows and columns of 2D array:
        for row in 0..<NumRows
        {
            for column in 0..<NumColumns
            {
                if tiles[column, row] != nil
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
        }
        
        return set
    }
    
    func tileAtColumn(column: Int, row: Int) -> Tile?
    {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
}
