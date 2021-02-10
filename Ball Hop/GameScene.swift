//
//  GameScene.swift
//  Ball Hop
//
//  Created by Joshua Alexander Mitchell on 3/4/20.
//  Copyright © 2020 Joshua Alexander Mitchell. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Layer: CGFloat {
    case Obstacle
    case Player
    case UI
    case Button
}

enum GameState {
    case MainMenu
    case Tutorial
    case Play
    case ShowingScore
    case GameOver
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1 // 1
    static let Obstacle: UInt32 = 0b10 // 2
}

enum Stage {
    case one
    case two
    case three
    case four
    case five
    case six
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let kCircleRadius: CGFloat = 10.0
    let kImpulse: CGFloat = 400.0
    let kGapMultiplier: CGFloat = 4.0
    let kObstacleSpeed: CGFloat = 150.0
    let kFirstSpawnDelay: TimeInterval = 1.75
    let kEverySpawnDelay: TimeInterval = 1.5
    let kColorStep: CGFloat = 10.0
    let kFontName = "AmericanTypewriter-Bold"
    let kMargin: CGFloat = 30.0
    
    let worldNode = SKNode()
    let player = SKShapeNode(circleOfRadius: 10.0)
    var stage = Stage.one
    var redValue: CGFloat = 255.0
    var greenValue: CGFloat = 9.0
    var blueValue: CGFloat = 9.0
    var hitObstacle = false
    var hitGround = false
    var gameState: GameState = .Play
    var scoreLabel: SKLabelNode!
    var score = 0
    
    //let bounceAction = SKAction.playSoundFileNamed("bouncesound.wav", waitForCompletion: false) SIGABRT sometimes
    
    override func didMove(to view: SKView) {
        //physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        physicsWorld.contactDelegate = self
        
        addChild(worldNode)
        setupBackground()
        setupPlayer()
        startSpawning()
        setupLabel()
    }
    
    // MARK: Setup methods
    
    func setupBackground() {
        //backgroundColor = SKColor.init(red: 48.0/255.0, green: 86.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        backgroundColor = SKColor.black
    }
    
    func setupPlayer() {
        player.fillColor = SKColor.white
        player.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        player.zPosition = Layer.Player.rawValue
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: kCircleRadius)
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle // 0 in flappy bird
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        
        worldNode.addChild(player)
    }
    
    func setupLabel() {
        scoreLabel = SKLabelNode(fontNamed: kFontName)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - kMargin)
        scoreLabel.text = "0"
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.zPosition = Layer.UI.rawValue
        worldNode.addChild(scoreLabel)
    }
    
    func setupScoreCard() {
        if score > GameScene.bestScore() {
            setBestScore(bestScore: score)
        }
    }
    
    // MARK: Gameplay
    
    func switchStage() {
        switch stage {
        case .one:
            stage = .two
        case .two:
            stage = .three
        case .three:
            stage = .four
        case .four:
            stage = .five
        case .five:
            stage = .six
        case .six:
            stage = .one
        }
    }
    
    func changeColor(_ color: inout CGFloat, increase: Bool) {
        if increase {
            if color >= 255.0 {
                switchStage()
            } else {
                color += kColorStep
                if color > 255.0 {
                    color = 255.0
                }
            }
        } else {
            if color <= 9.0 {
                switchStage()
            } else {
                color -= kColorStep
                if color < 9.0 {
                    color = 9.0
                }
            }
        }
    }
    
    func createObstacle() -> SKShapeNode {
        let shape = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height / 20 ))
        shape.zPosition = Layer.Obstacle.rawValue
        
        shape.userData = NSMutableDictionary()
        
        shape.physicsBody = SKPhysicsBody(rectangleOf: shape.frame.size)
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        shape.physicsBody?.collisionBitMask = 0
        shape.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        return shape
    }
    
    func spawnObstacle() {
        let leftObstacle = createObstacle()
        let startY = size.height + leftObstacle.frame.height / 2
        
        let leftObstacleMin = -leftObstacle.frame.width / 2
        let leftObstacleMax = size.width - leftObstacle.frame.width / 2 - kGapMultiplier * player.frame.width
        leftObstacle.position = CGPoint(x: CGFloat.random(in: leftObstacleMin ... leftObstacleMax), y: startY)
        leftObstacle.name = "LeftObstacle"
        worldNode.addChild(leftObstacle)
        
        let rightObstacle = createObstacle()
        rightObstacle.position = CGPoint(x: leftObstacle.position.x + leftObstacle.frame.width / 2 + kGapMultiplier * player.frame.width + rightObstacle.frame.width / 2, y: startY)
        rightObstacle.name = "RightObstacle"
        worldNode.addChild(rightObstacle)
        
        switch stage {
        case .one:
            changeColor(&blueValue, increase: true)
        case .two:
            changeColor(&redValue, increase: false)
        case .three:
            changeColor(&greenValue, increase: true)
        case .four:
            changeColor(&blueValue, increase: false)
        case .five:
            changeColor(&redValue, increase: true)
        case .six:
            changeColor(&greenValue, increase: false)
        }
        
        leftObstacle.fillColor = SKColor.init(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: 1.0)
        rightObstacle.fillColor = SKColor.init(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: 1.0)
        
        let moveY = size.height + leftObstacle.frame.height
        let moveDuration = moveY / kObstacleSpeed
        
        let sequence = SKAction.sequence([SKAction.moveBy(x: 0, y: -moveY, duration: TimeInterval(moveDuration)), SKAction.removeFromParent()])
        leftObstacle.run(sequence)
        rightObstacle.run(sequence)
    }
    
    func startSpawning() {
        let firstDelay = SKAction.wait(forDuration: kFirstSpawnDelay)
        let spawn = SKAction.run {
            self.spawnObstacle()
        }
        let everyDelay = SKAction.wait(forDuration: kEverySpawnDelay)
        let spawnSequence = SKAction.sequence([spawn, everyDelay])
        let foreverSpawn = SKAction.repeatForever(spawnSequence)
        let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
        run(overallSequence, withKey: "spawn")
    }
    
    func stopSpawning() {
        removeAction(forKey: "spawn")
        
        worldNode.enumerateChildNodes(withName: "LeftObstacle", using: { node, stop in
            node.removeAllActions()
        })
        worldNode.enumerateChildNodes(withName: "RightObstacle", using: { node, stop in
            node.removeAllActions()
        })
    }
    
    func movePlayer(_ location : CGPoint) {
        if location.y < player.position.y {
            let angle: CGFloat = atan((player.position.y - location.y) / abs(player.position.x - location.x))
            
            if location.x > player.position.x {
                player.physicsBody?.velocity = CGVector(dx: -kImpulse * cos(angle), dy: kImpulse * sin(angle))
            } else {
                player.physicsBody?.velocity = CGVector(dx: kImpulse * cos(angle), dy: kImpulse * sin(angle))
            }
            
            //run(bounceAction)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            debugPrint("Ops, no touch found...")
            return
        }
        let location = touch.location(in: self)
        
        switch gameState {
        case .MainMenu:
            break
        case .Tutorial:
            break
        case .Play:
            movePlayer(location)
            break
        case .ShowingScore:
            let newScene = GameScene(size: size)
            let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
            view?.presentScene(newScene, transition: transition)
            break
        case .GameOver:
            break
        }
    }
    
    // MARK: Updates
    
    override func update(_ currentTime: TimeInterval) {
        updatePlayer()
        checkHitObstacle()
        
        switch gameState {
        case .MainMenu:
            break
        case .Tutorial:
            break
        case .Play:
            updatePlayer()
            checkHitObstacle()
            checkHitGround()
            updateScore()
            break
        case .ShowingScore:
            break
        case .GameOver:
            break
        }
    }
    
    func updatePlayer() {
        if player.position.x - player.frame.width / 2.0 > size.width {
            player.position.x = -player.frame.width / 2.0
            //print("fuck") // Debuggin Stuff
        } else if player.position.x + player.frame.width / 2.0 < 0.0 {
            player.position.x = size.width + player.frame.width / 2.0
        }
        
        if player.position.y - player.frame.height / 2 < 0 {
            hitGround = true
        }
        
        // Debugging Stuff
        if gameState == .Play {
            //print("Player x position:")
            //print(player.position.x)
            //print("Other:")
            //print(player.position.x + player.frame.width / 2.0)
        }
    }
    
    func checkHitObstacle() {
        if hitObstacle {
            hitObstacle = false
            // Different here
        }
    }
    
    func checkHitGround() {
        if hitGround {
            hitGround = false
            switchToShowScore()
        }
    }
    
    func updateScore() {
        worldNode.enumerateChildNodes(withName: "LeftObstacle", using: {node, stop
            in
            if let obstacle = node as? SKShapeNode {
                if let passed = obstacle.userData?["Passed"] as? NSNumber {
                    if passed.boolValue {
                        return
                    }
                }
                if self.player.position.y > obstacle.position.y + obstacle.frame.height/2 {
                    self.score += 1
                    self.scoreLabel.text = "\(self.score)"
                    // TBD: SOUND EFFECT
                    obstacle.userData?["Passed"] = NSNumber(value: true)
                }
            }
        })
    }
    
    // MARK: Game States
    
    func switchToShowScore() {
        gameState = .ShowingScore
        player.removeAllActions()
        stopSpawning()
        setupScoreCard()
        
        let aspectRatio = size.height / size.width
        //let scene = GameScene(size:CGSize(width: 320, height: 320 * aspectRatio))
        let newScene = ScorecardScene(size: CGSize(width: 694 / aspectRatio, height: 694), score: self.score)
        
        //let newScene = ScorecardScene(size: self.size, score: self.score)
        let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
        print(size)
        view?.presentScene(newScene, transition: transition)
    }
    
    // MARK: Score
    
    class func bestScore() -> Int {
        return UserDefaults.standard.integer(forKey: "BestScore")
    }
    
    func setBestScore(bestScore: Int) {
        UserDefaults.standard.set(bestScore, forKey: "BestScore")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Physics
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == PhysicsCategory.Obstacle {
            hitObstacle = true
        }
    }
}
