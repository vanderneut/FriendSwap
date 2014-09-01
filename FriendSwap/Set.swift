//
//  Set.swift
//  FriendSwap
//
//  Created by Erik van der Neut on 1/09/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

class Set<T: Hashable>: SequenceType, Printable
{
    var dictionary = Dictionary<T, Bool>()      // private
    
    func addElement(newElement: T)
    {
        dictionary[newElement] = true
    }
    
    func removeElement(element: T)
    {
        dictionary[element] = nil
    }
    
    func containsElement(element: T) -> Bool
    {
        return dictionary[element] != nil
    }
    
    func allElements() -> [T]
    {
        return Array(dictionary.keys)
    }
    
    var count: Int
    {
        return dictionary.count
    }
    
    func unionSet(otherSet: Set<T>) -> Set<T>
    {
        var combinedSet = Set<T>()
        
        for object in dictionary.keys
        {
            combinedSet.dictionary[object] = true
        }
        
        for object in otherSet.dictionary.keys
        {
            combinedSet.dictionary[object] = true
        }
        
        return combinedSet
    }
    
    func generate() -> IndexingGenerator<Array<T>>
    {
        return allElements().generate()
    }
    
    var description: String
    {
        return dictionary.description
    }
}
