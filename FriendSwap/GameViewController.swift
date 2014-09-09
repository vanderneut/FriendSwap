//
//  GameViewController.swift
//  FriendSwap
//
//  Created by Erik van der Neut on 16/08/2014.
//  Copyright (c) 2014 Erik van der Neut. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    // MARK: - Properties:
    
    var scene: GameScene!
    var level: Level!

    // MARK: - Methods:
    
    func beginGame()
    {
        shuffle()
    }
    
    func shuffle()
    {
        let newFriends = level.shuffle()
        scene.addSpritesForFriends(newFriends)
    }
    
    // MARK: - Overrides:
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Configure the view.
        let skView = self.view as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.multipleTouchEnabled = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Create the level:
        level = Level(filename: "Level_4")
        scene.level = level
        
        // Present the scene:
        skView.presentScene(scene)
        
        // Kick things off:
        beginGame()
    }

    override func shouldAutorotate() -> Bool
    {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int
    {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        }
        else
        {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}
