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
    // MARK: - Properties:
    
    var level:      Level!              // public reference to current level (no value initially)
    let TileWidth:  CGFloat = 32.0      // constant for width of each tile
    let TileHeight: CGFloat = 36.0      // constant for height of each tile
    let gameLayer = SKNode()            // base layer, centered on screen, container for all other layers
    let friendsLayer = SKNode()         // holds friend sprites, is child of gameLayer
    let tilesLayer = SKNode()           // holds the background tile images
    
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
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
//        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
}
