//
//  GameScene.swift
//  FriendSwap
//
//  Created by Erik van der Neut on 16/08/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    // -------------------------------------------------------------------------
    // MARK: - Properties:
    
    var level:      Level!              // public reference to current level (no value initially)
    let TileWidth:  CGFloat = 32.0      // constant for width of each tile
    let TileHeight: CGFloat = 36.0      // constant for height of each tile
    let gameLayer = SKNode()            // base layer, centered on screen, container for all other layers
    let friendsLayer = SKNode()         // holds friend sprites, is child of gameLayer
    let tilesLayer = SKNode()           // holds the background tile images
    var swipeFromColumn: Int?           // swipe start column
    var swipeFromRow: Int?              // swipe start row
    var swipeHandler: ((Swap) -> ())?   // way to communicate back to GameViewController that a swap must be attempted (a closure instead of a delegate)
    
    // -------------------------------------------------------------------------
    // MARK: - Methods:
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
        setup()
    }
    
    func setup()
    {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * 0.5 * CGFloat(NumColumns),
            y: -TileHeight * 0.5 * CGFloat(NumRows))
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)

        friendsLayer.position = layerPosition
        gameLayer.addChild(friendsLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    func addTiles()
    {
        for row in 0..<NumRows
        {
            for column in 0..<NumColumns
            {
                if let tile = level.tileAtColumn(column, row: row)
                {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.position = pointForColumn(column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func addSpritesForFriends(friends: Set<Friend>)
    {
        for friend in friends
        {
            let sprite = SKSpriteNode(imageNamed: friend.friendType.spriteName)
            sprite.position = pointForColumn(friend.column, row: friend.row)
            friendsLayer.addChild(sprite)
            friend.sprite = sprite
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint
    {
        return CGPoint(
            x: CGFloat(column) * TileWidth + 0.5 * TileWidth,
            y: CGFloat(row) * TileHeight + 0.5 * TileHeight)
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int)
    {
        if point.x >= 0 && point.x < CGFloat(NumColumns) * TileWidth &&
           point.y >= 0 && point.y < CGFloat(NumRows) * TileHeight
        {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        }
        else
        {
            return (false, 0, 0)
        }
    }
    
    func trySwapHorizontal(horzDelta: Int, vertical vertDelta: Int)
    {
        // Calculate row/column of the friend to swap:
        let toColumn = swipeFromColumn! + horzDelta
        let toRow    = swipeFromRow!    + vertDelta
    
        // If the swipe-end row/column is outside the grid, then ignore the swipe altogether:
        if toColumn < 0 || toColumn >= NumColumns { return }   /* RETURN when swiping off the side edges of the level */
        if toRow    < 0 || toRow    >= NumRows    { return }   /* RETURN when swiping off top or bottom edge of the level */
        
        // Make sure there is a friend to swap with at this location (i.e. make sure this is not a gap in the level):
        if let toFriend = level.friendAtColumn(toColumn, row: toRow)
        {
            if let fromFriend = level.friendAtColumn(swipeFromColumn!, row: swipeFromRow!)
            {
                // Everything checked out OK, so let's do the friend swap:
                println("**** swapping \(fromFriend) with \(toFriend)****")
                if let handler = swipeHandler
                {
                    let swap = Swap(friendA: fromFriend, friendB: toFriend)
                    handler(swap)
                }
            }
        }
    }
    
    func animateSwap(swap: Swap, completion: () -> ())
    {
        let spriteA = swap.friendA.sprite!
        let spriteB = swap.friendB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition =  90
        
        let Duration: NSTimeInterval = 0.3
        
        let moveA = SKAction.moveTo(spriteB.position, duration: Duration)
        moveA.timingMode = .EaseOut
        spriteA.runAction(moveA, completion: completion)
        
        let moveB = SKAction.moveTo(spriteA.position, duration: Duration)
        moveB.timingMode = .EaseOut
        spriteB.runAction(moveB)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Touches:
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        
        // Convert touch location to a point on the friends layer:
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(friendsLayer)
        
        // Test whether this is a valid swipe starting location on the level grid:
        let (success, column, row) = convertPoint(location)
        if (success)
        {
            // Make sure it's not an empty square:
            if let friend = level.friendAtColumn(column, row: row)
            {
                // Record this starting point of the swipe, so we can compare later to get direction:
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        // Ignore the swipe when the swipe started outside the valid area or if the friends have already been swapped:
        if swipeFromColumn == nil { return }          /* RETURN when invalid starting location */
        
        // Calculate the row and column for the current finger position:
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(friendsLayer)
        
        let (success, column, row) = convertPoint(location)
        if success
        {
            // Figure out swipe direction by comparing current row/column to starting row/column:
            // NOTE: use the ! to unwrap the values from the optional variables:
            var horzDelta = 0, vertDelta = 0
            if      column < swipeFromColumn! { horzDelta = -1 }   // swipe left
            else if column > swipeFromColumn! { horzDelta =  1 }   // swipe right
            else if row    < swipeFromRow!    { vertDelta = -1 }   // swipe down
            else if row    > swipeFromRow!    { vertDelta =  1 }   // swipe up
            
            // Only perform the swap if the user swiped out of the starting square:
            if horzDelta != 0 || vertDelta != 0
            {
                trySwapHorizontal(horzDelta, vertical: vertDelta)
                
                // Ignore rest of this swipe motion:
                swipeFromColumn = nil
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
    {
        touchesEnded(touches, withEvent: event)
    }
}
