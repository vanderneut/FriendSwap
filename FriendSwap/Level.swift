//
//  Level.swift
//  FriendSwap
//
//  Created by Erik van der Neut on 1/09/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

import Foundation

// -------------------------------------------------------------------------
// MARK: - Constants:

let NumColumns = 9
let NumRows = 9

// -------------------------------------------------------------------------
// MARK: - Class definition:

class Level
{
    // -------------------------------------------------------------------------
    // MARK: - Public Properties:
    
    let friends = Array2D<Friend>(columns: NumColumns, rows: NumRows)       // friends keeps track of the friend objects in the level
    let tiles   = Array2D<Tile>(columns: NumColumns, rows: NumRows)         // tiles describes structure of the level
    
    // -------------------------------------------------------------------------
    // MARK: - Private Properties:
    
    private var possibleSwaps = Set<Swap>()
    
    // -------------------------------------------------------------------------
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
        // Create the initial set of friends, and keep doing it if necessary until there is at least one possible swap:
        var set: Set<Friend>
        do
        {
            set = createInitialFriends()
            detectPossibleSwaps()
            println("Possible swaps:\n\(possibleSwaps)")
        }
        while possibleSwaps.count == 0
        
        return set
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
                    // Pick random friend, and keep doing that until we do NOT have three in a row or column:
                    var friendType: FriendType
                    do
                    {
                        friendType = FriendType.random()
                    }
                    while (column >= 2 &&
                           friends[column - 1, row]?.friendType == friendType &&
                           friends[column - 2, row]?.friendType == friendType)
                       || (row >= 2 &&
                           friends[column, row - 1]?.friendType == friendType &&
                           friends[column, row - 2]?.friendType == friendType)
                    
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
    
    func detectPossibleSwaps()
    {
        var set = Set<Swap>()
        
        for row in 0..<NumRows
        {
            for column in 0..<NumColumns
            {
                if let friend = friends[column, row]
                {
                    // Check to see if it's possible to swap this friend with the one on the right:
                    if column < NumColumns - 1
                    {
                        // Is there a friend in this spot? If no tile, then no friend:
                        if let other = friends[column + 1, row]
                        {
                            // Swap them:
                            friends[column,     row] = other
                            friends[column + 1, row] = friend
                            
                            // Check to see whether either friend is now part of a chain:
                            if hasChainAtColumn(column + 1, row: row) || hasChainAtColumn(column, row: row)
                            {
                                set.addElement(Swap(friendA: friend, friendB: other))
                            }
                            
                            // Swap them back:
                            friends[column + 1, row] = other
                            friends[column,     row] = friend
                        }
                    }
                    
                    // Check to see if it's possible to swap this friend with the one above it:
                    if row < NumRows - 1
                    {
                        // Is there a friend in this spot? If no tile, then no friend:
                        if let other = friends[column, row + 1]
                        {
                            // Swap them:
                            friends[column, row    ] = other
                            friends[column, row + 1] = friend
                            
                            // Check to see whether either friend is now part of a chain:
                            if hasChainAtColumn(column, row: row + 1) || hasChainAtColumn(column, row: row)
                            {
                                set.addElement(Swap(friendA: friend, friendB: other))
                            }
                            
                            // Swap them back:
                            friends[column, row + 1] = other
                            friends[column, row    ] = friend
                        }
                    }
                }
            }
        }
        
        possibleSwaps = set
    }
    
    private func hasChainAtColumn(column: Int, row: Int) -> Bool
    {
        let friendType = friends[column, row]!.friendType
        
        var horzLength = 1
        for var i = column - 1; i >= 0 && friends[i, row]?.friendType == friendType; --i, ++horzLength { }
        for var i = column + 1; i < NumColumns && friends[i, row]?.friendType == friendType; ++i, ++horzLength { }
        if horzLength >= 3 { return true }      /* RETURN true when horizontal chain found */
        
        var vertLength = 1
        for var i = row - 1; i >= 0 && friends[column, i]?.friendType == friendType; --i, ++vertLength { }
        for var i = row + 1; i < NumRows && friends[column, i]?.friendType == friendType; ++i, ++vertLength { }
        if vertLength >= 3 { return true }      /* RETURN true when vertical chain found */
        
        return false                            /* RETURN false when no chain found at all */
    }
    
    func tileAtColumn(column: Int, row: Int) -> Tile?
    {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func performSwap(swap: Swap)
    {
        let columnA = swap.friendA.column
        let rowA    = swap.friendA.row
        let columnB = swap.friendB.column
        let rowB    = swap.friendB.row
        
        friends[columnA, rowA] = swap.friendB
        swap.friendB.column = columnA
        swap.friendB.row    = rowA
        
        friends[columnB, rowB] = swap.friendA
        swap.friendA.column = columnB
        swap.friendA.row    = rowB
    }
    
    func isPossibleSwap(swap: Swap) -> Bool
    {
        return possibleSwaps.containsElement(swap)
        
        // NOTE: this works because we specified a custom == operator on Swap
    }
}
