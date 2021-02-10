//
//  ScorecardScene.swift
//  Ball Hop
//
//  Created by Joshua Alexander Mitchell on 3/18/20.
//  Copyright © 2020 Joshua Alexander Mitchell. All rights reserved.
//

import Foundation

import SpriteKit

class ScorecardScene: SKScene {
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        let kMargin: CGFloat = 30.0
        let kScale: CGFloat = 0.25
        let kFontName = "Chalkduster"
        
        let lastScoreLabel = SKLabelNode(fontNamed: kFontName)
        lastScoreLabel.text = String(score)
        lastScoreLabel.fontSize = 100
        lastScoreLabel.fontColor = SKColor.white
        lastScoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.75)
        addChild(lastScoreLabel)
        
        let bestScoreLabel = SKLabelNode(fontNamed: kFontName)
        bestScoreLabel.text = "BEST \(GameScene.bestScore())"
        bestScoreLabel.fontSize = 50
        bestScoreLabel.fontColor = SKColor.white
        //bestScoreLabel.verticalAlignmentMode = .top
        bestScoreLabel.position = CGPoint(x: size.width/2, y: lastScoreLabel.position.y - lastScoreLabel.frame.height/2 - bestScoreLabel.frame.height/2 - kMargin)
        addChild(bestScoreLabel)
        
        // Consider replacing with shape node
        let replayButton = SKSpriteNode(imageNamed: "EmptyButton")
        replayButton.scale(to: CGSize(width: kScale * replayButton.size.width, height: kScale * replayButton.size.height))
        replayButton.position = CGPoint(x: size.width/2, y: bestScoreLabel.position.y - bestScoreLabel.frame.height/2 - replayButton.size.height/2 - kMargin)
        replayButton.name = "replay"
        addChild(replayButton)
        
        let replayLabel = SKLabelNode(fontNamed: kFontName)
        replayLabel.text = "REPLAY"
        replayLabel.fontSize = 100
        replayLabel.fontColor = SKColor.white
        replayLabel.name = "replay"
        replayLabel.position = CGPoint.zero
        replayButton.addChild(replayLabel)
        
        let menuButton = SKSpriteNode(imageNamed: "LargeEmptyButton")
        menuButton.scale(to: CGSize(width: kScale * menuButton.size.width, height: kScale * menuButton.size.height))
        menuButton.position = CGPoint(x: size.width/2, y: replayButton.position.y - replayButton.size.height/2 - menuButton.size.height/2 - kMargin)
        menuButton.name = "menu"
        addChild(menuButton)
        
        let menuLabel = SKLabelNode(fontNamed: kFontName)
        menuLabel.text = "MAIN MENU"
        menuLabel.fontSize = 100
        menuLabel.fontColor = SKColor.white
        menuLabel.name = "menu"
        menuLabel.position = CGPoint.zero
        menuButton.addChild(menuLabel)
        
        let adButton = SKSpriteNode(imageNamed: "LargeEmptyButton")
        adButton.scale(to: CGSize(width: kScale * adButton.size.width, height: kScale * adButton.size.height))
        adButton.position = CGPoint(x: size.width/2, y: menuButton.position.y - menuButton.size.height/2 - adButton.size.height/2 - kMargin)
        addChild(adButton)
        
        let adLabel = SKLabelNode(fontNamed: kFontName)
        adLabel.text = "REMOVE ADS"
        adLabel.fontSize = 100
        adLabel.fontColor = SKColor.white
        adLabel.position = CGPoint.zero
        adButton.addChild(adLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            debugPrint("Ops, no touch found...")
            return
        }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if let name = touchedNode.name {
            if name == "replay" {
                //let newScene = GameScene(size: size)
                //let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
                //view?.presentScene(newScene, transition: transition)
                
                let aspectRatio = size.height / size.width
                let newScene = GameScene(size:CGSize(width: 320, height: 320 * aspectRatio))
                let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
                print(size)
                view?.presentScene(newScene, transition: transition)
            } else if name == "menu" {
                let newScene = MenuScene(size: self.size)
                let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
                view?.presentScene(newScene, transition: transition)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
