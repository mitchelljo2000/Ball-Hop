//
//  MenuScene.swift
//  Ball Hop
//
//  Created by Joshua Alexander Mitchell on 3/25/20.
//  Copyright © 2020 Joshua Alexander Mitchell. All rights reserved.
//

import Foundation

import SpriteKit

class MenuScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        let kMargin: CGFloat = 30.0
        let kScale: CGFloat = 0.25
        let kFontName = "Chalkduster"
        
        let bestScoreLabel = SKLabelNode(fontNamed: kFontName)
        bestScoreLabel.text = "BEST \(GameScene.bestScore())"
        bestScoreLabel.fontSize = 20
        bestScoreLabel.fontColor = SKColor.white
        bestScoreLabel.verticalAlignmentMode = .top
        bestScoreLabel.position = CGPoint(x: size.width/4, y: size.height - 40.0)
        addChild(bestScoreLabel)
        
        let logoLabel = SKLabelNode(fontNamed: kFontName)
        logoLabel.text = "BALL HOP"
        logoLabel.fontSize = 55
        logoLabel.fontColor = SKColor.red
        logoLabel.position = CGPoint(x: size.width/2, y: size.height * 0.75)
        addChild(logoLabel)
        
        // Consider replacing with shape node
        let playButton = SKSpriteNode(imageNamed: "EmptyButton")
        playButton.scale(to: CGSize(width: kScale * playButton.size.width, height: kScale * playButton.size.height))
        playButton.position = CGPoint(x: size.width/2, y: logoLabel.position.y - logoLabel.frame.height/2 - playButton.size.height/2 - kMargin)
        playButton.name = "play"
        addChild(playButton)
        
        let playLabel = SKLabelNode(fontNamed: kFontName)
        playLabel.text = "PLAY"
        playLabel.fontSize = 100
        playLabel.fontColor = SKColor.white
        playLabel.name = "play"
        playLabel.position = CGPoint.zero
        playButton.addChild(playLabel)
        
        let rateButton = SKSpriteNode(imageNamed: "EmptyButton")
        rateButton.scale(to: CGSize(width: kScale * rateButton.size.width, height: kScale * rateButton.size.height))
        rateButton.position = CGPoint(x: size.width/2, y: playButton.position.y - playButton.size.height/2 - rateButton.size.height/2 - kMargin)
        rateButton.name = "rate"
        addChild(rateButton)
        
        let rateLabel = SKLabelNode(fontNamed: kFontName)
        rateLabel.text = "RATE"
        rateLabel.fontSize = 100
        rateLabel.fontColor = SKColor.white
        rateLabel.name = "rate"
        rateLabel.position = CGPoint.zero
        rateButton.addChild(rateLabel)
        
        let adButton = SKSpriteNode(imageNamed: "LargeEmptyButton")
        adButton.scale(to: CGSize(width: kScale * adButton.size.width, height: kScale * adButton.size.height))
        adButton.position = CGPoint(x: size.width/2, y: rateButton.position.y - rateButton.size.height/2 - adButton.size.height/2 - kMargin)
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
            if name == "play" {
                //let newScene = GameScene(size: size)
                //let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
                //view?.presentScene(newScene, transition: transition)
                
                let aspectRatio = size.height / size.width
                let newScene = GameScene(size:CGSize(width: 320, height: 320 * aspectRatio))
                let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
                print(size)
                view?.presentScene(newScene, transition: transition)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
