//
//  Array2D.swift
//  FriendSwap
//
// Class to mimic the plain old two-dimenstional C-arrays.
// This class is generic; it can hold objects of any type T. We will use this to
// store Friend objects and Tile objects.
//
//  Created by Erik van der Neut on 1/09/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

class Array2D<T>
{
    let columns: Int
    let rows: Int
    var array: Array<T?>    // private
    
    init(columns: Int, rows: Int)
    {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows * columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T?
    {
        get
        {
            return array[row * columns + column]
        }
        set
        {
            array[row * columns + column] = newValue
        }
    }
}
