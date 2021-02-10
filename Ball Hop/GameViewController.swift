//
//  GameViewController.swift
//  Ball Hop
//
//  Created by Joshua Alexander Mitchell on 3/4/20.
//  Copyright © 2020 Joshua Alexander Mitchell. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                // Create the scene
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                //let scene = GameScene(size:CGSize(width: 320, height: 320 * aspectRatio))
                let scene = MenuScene(size: CGSize(width: 694 / aspectRatio, height: 694))
                
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.showsPhysics = true
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .aspectFill
                
                skView.presentScene(scene)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
