//
//  GameScene.swift
//  HungryBear
//
//  Created by Cappillen on 7/10/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import Foundation

enum Direction {
    case up, down, right, left, still
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let motionManager = CMMotionManager()
    var dir: Direction = .still
    
    //Fixed Delta
    var fixedDelta: CFTimeInterval = 1.0/60.0 //60 FPS
    
    //Connect objects
    var player: Player!
    var obstaclelayer: SKNode!
    var obstacleSource: Obstacle!
    var creatureLayer: SKNode!
    var creatureSource: Animals!
    var wolf: Monster!
    var groundSource: SKSpriteNode!
    var groundSource2: SKSpriteNode!
    var bottomSource: SKSpriteNode!
    var bottomSource2: SKSpriteNode!
    
    //Initialize variables
    var spawnTimer: CFTimeInterval = 0
    var secondSpawnTimer: CFTimeInterval = 0
    var animalSpawnTimer: CFTimeInterval = 0
    var randObstacleSpawnTimer: CFTimeInterval = 1
    var randAnimalSpawnTimer: CFTimeInterval = 5
    var scrollSpd: CGFloat = 200
    var prevSpacePosition: CGPoint!
    var points = 0
    var highscore = 0
    var distanceFromCenterCount = 4
    var shakeTimer: CFTimeInterval = 0
    var animalMoveTimer: CFTimeInterval = 0
    var multiplierSpd = -7.0
    var shouldAutorotate: Bool = false
    
    //Connect UI objects
    var pointsLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        //Setup your scene here
        
        physicsWorld.contactDelegate = self
        //Get reference to the UI objects
        
        //Connect player
        player = self.childNode(withName: "//player") as! Player
        player.running()
        
        //Connect obstacleLayer
        obstaclelayer = self.childNode(withName: "obstacleLayer")
        //Connect wolf
        wolf = self.childNode(withName: "//wolf") as! Monster
        wolf.monsterState = .walking
        
        //Connect scrollLayer
        groundSource2 = self.childNode(withName: "groundSource2") as! SKSpriteNode
        groundSource = self.childNode(withName: "groundSource") as! SKSpriteNode
        bottomSource = self.childNode(withName: "bottomSource") as! SKSpriteNode
        bottomSource2 = self.childNode(withName: "bottomSource2") as! SKSpriteNode
        
        //Connect obstacles
        obstacleSource = self.childNode(withName: "obstacle") as! Obstacle
        obstacleSource.physicsBody?.usesPreciseCollisionDetection = true
        creatureLayer = self.childNode(withName: "creatureLayer")
        creatureSource = self.childNode(withName: "creature") as! Animals
        
        //Connect UI objects
        pointsLabel = childNode(withName: "pointsLabel") as! SKLabelNode
        highscoreLabel = self.childNode(withName: "highscoreLabel") as! SKLabelNode
        
        //Declaring swipe gestures
        //Creating the Swipe Right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        //Creating the Swipe Down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        //Creating the SwipeUp
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        //Creating the SwipeLeft
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene().swiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        //Creates a border the size of the frame
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.contactTestBitMask = 1
        self.physicsBody = border
        
        //Starts the accelerometer updates
        motionManager.startAccelerometerUpdates()
        motionManager.accelerometerUpdateInterval = 0.1
        print("starting up the acceleromter")
        
        //Set the score label to 0
        pointsLabel.text = "\(points)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "creature" && nodeB.name == "obstacle" || nodeA.name == "obstacle" && nodeB.name == "creature" {
            if animalMoveTimer >= 0.4 {
            print("the animal collided")
            //Checks if it's the animal
            if nodeA.name == "creature" {
                print("found the creature")
                //if we found the animals we check kill it
                let nodeA = contactA.node as! Animals
                
                //Runs the death scene
                if nodeA.position.x < 300 {
                    print(nodeA.state)
                    
                    let deathScene = SKAction.run({
                        nodeA.deathScene()
                    })
                    
                    let sequence = SKAction.sequence([deathScene])
                    run(sequence)
                    
                }
            } else if nodeB.name == "creature" {
                
                print("found the creature")
                //if we found the animals we check kill it
                let nodeB = contactB.node as! Animals
                
                //Runs the death scene
                if nodeB.position.x < 300 {
                    print(nodeB.state)
                    
                    let deathScene = SKAction.run({
                        nodeB.deathScene()
                    })
                    
                    let sequence = SKAction.sequence([deathScene])
                    run(sequence)
                    
                }
                
                
                }
                
                animalMoveTimer = 0
            }
            
            return
            
        }// else if nodeA.name == "obstacle" && nodeB.name == "creature" {
//            print("the animal collided")
//            
//            //Checks if it's the animal
//            if nodeB.name == "creature" {
//                
//                //If we found it kill it
//                print("found the creature")
//                let nodeB = contactB.node as! Animals
//                
//                //Runs the death scene
//                if nodeB.position.x < 300 {
//                    print(nodeB.state)
//                    
//                    let deathScene = SKAction.run({
//                        nodeB.deathScene()
//                    })
//                    
//                    let sequence = SKAction.sequence([deathScene])
//                    run(sequence)
//                    
//                }
//            }
//            
//            return
//        }
//        
        //If any object with physics body collides with the frame boundaries
        if nodeA.name == nil {
            //nodeB.removeAllActions()
            return
        } else if nodeB.name == nil {
            //nodeA.removeAllActions()
            return
        }
        
        //If player collides with the obstacle
        if nodeA.name == "player" && nodeB.name == "obstacle" || nodeB.name == "player" && nodeA.name == "obstacle"{
            
            //Timer for running collision actions
            if shakeTimer > 0.7 {
                //Runs the shake scene to give the player something to see
                let shakeScene = SKAction.run({
                let shake = SKAction.init(named: "ShakeItUp")
                for node in self.children {
                    node.run(shake!)
                    }
                })
            
                self.player.run(shakeScene)
            
                ///
                print("this is nodeB: \(nodeB)")
                //Moves the player back
                let move = SKAction.move(to: CGPoint(x: player.position.x - 50, y: player.position.y), duration: 1)
                let seq = SKAction.sequence([move])
                player.run(seq)
                //nodeB.removeFromParent()
            
                //Updates the count of the counters to death
                distanceFromCenterCount -= 1
                print(distanceFromCenterCount)
                distanceFromMonster()
                print("something")
                shakeTimer = 0
            }
            
        }// else if nodeA.name == "player" && nodeB.name == "obstacle" {
//            
//            //Runs the shake scene to give the player something to see
//            let shakeScene = SKAction.run({
//                let shake = SKAction.init(named: "ShakeItUp")
//                for node in self.children {
//                    node.run(shake!)
//                }
//            })
//            
//            self.player.run(shakeScene)
//        }
    }
    
//    func didEnd(_ contact: SKPhysicsContact) {
//        let contactA:SKPhysicsBody = contact.bodyA
//        let contactB:SKPhysicsBody = contact.bodyB
//        
//        let nodeA = contactA.node!
//        let nodeB = contactB.node!
//        
//        //If the player collided with the obstacle start tp move the player back
//        if nodeA.name == "player" && nodeB.name == "obstacle" || nodeB.name == "player" && nodeA.name == "obstacle"{
//            print("this is nodeB: \(nodeB)")
//            //Moves the player back
//            let move = SKAction.move(to: CGPoint(x: player.position.x - 50, y: player.position.y), duration: 1)
//            let seq = SKAction.sequence([move])
//            player.run(seq)
//            nodeB.removeFromParent()
//            
//            //Updates the count of the counters to death
//            distanceFromCenterCount -= 1
//            print(distanceFromCenterCount)
//            distanceFromMonster()
//            print("something")
//       } //else  {
//
//            //Moves the player back
//            let move = SKAction.move(to: CGPoint(x: player.position.x - 50, y: player.position.y), duration: 1)
//            let seq = SKAction.sequence([move])
//            player.run(seq)
//            nodeA.removeFromParent()
//            
//            //Updates the count of the counters to death
//            distanceFromCenterCount -= 1
//            print(distanceFromCenterCount)
//            distanceFromMonster()
//            print("something")
//        }
    //}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //Scroll the ground
        scroller(spd: scrollSpd)
        
        //The accelerometer
        updateAcellerometerData()
        
        //Check direction
        //checkDirection()
        
        //Updates the animals
        updateAnimals()
        
        //Spawns the obstacles
        updateObstacles()
        
        //update time
        animalSpawnTimer += fixedDelta
        secondSpawnTimer += fixedDelta
        spawnTimer += fixedDelta
        shakeTimer += fixedDelta
        animalMoveTimer += fixedDelta
    }
    
    func updatePoints() {
        //Add points
        points += 5
        
        //Update the label
        pointsLabel.text = String(points)
    }
    
    func scroller(spd: CGFloat) {
        
        //Scrolls the world

        //Scroll the main ground
        groundSource.position.x -= (spd) * CGFloat(fixedDelta)
        groundSource2.position.x -= (spd) * CGFloat(fixedDelta)
        
        //Scroll the bottom background
        bottomSource.position.x -= spd * CGFloat(fixedDelta)
        bottomSource2.position.x -= spd * CGFloat(fixedDelta)
        
        //Does a check for if its position is off then bring them back to touch each other
        if groundSource.position.x > groundSource2.position.x + groundSource.size.width {
            groundSource.position.x = groundSource2.position.x + groundSource.size.width
        }
        
        //Does a check for if its position is off then bring them back to touch each other
        if groundSource2.position.x > groundSource.position.x + groundSource.size.width {
            groundSource2.position.x = groundSource.position.x + groundSource2.size.width
        }
        
        //Check the grounds
        if(groundSource.position.x < -groundSource.size.width)
        {
            groundSource.position = CGPoint(x: groundSource.position.x + groundSource2.size.width * 2, y: groundSource.position.y)
        }
        
        if(groundSource2.position.x < -groundSource2.size.width )
        {
            groundSource2.position = CGPoint(x: groundSource2.position.x + groundSource.size.width * 2, y: groundSource2.position.y)
            
        }
        
        //Check the bottom background
        if(bottomSource.position.x < -bottomSource.size.width)
        {
            bottomSource.position = CGPoint(x: bottomSource.position.x + bottomSource2.size.width * 2, y: bottomSource.position.y)
        }
        
        if(bottomSource2.position.x < -bottomSource2.size.width )
        {
            bottomSource2.position = CGPoint(x: bottomSource2.position.x + bottomSource.size.width * 2, y: bottomSource2.position.y)
            
        }
        
    }
    
    func distanceFromMonster() {
        print("Counter: \(distanceFromCenterCount)")
        if distanceFromCenterCount <= 0 {
            
            guard let skView = self.view as SKView! else {
                print("could not get SKView")
                return
            }
            //2) Load game scene
            guard let scene = GameScene(fileNamed: "GameScene") else {
                print("Could not make GameScene, check the name is spelled correctly")
                return
            }
            //Enusre the aspect mode is correct
            scene.scaleMode = .aspectFit
            //Show Debug
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            //4)
            let transition = SKTransition.moveIn(with: .right, duration: 1)
            skView.presentScene(scene, transition: transition)
        }
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        
        //Checks if we are swiping
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            //Switch function if the player swiped up, down, left, right
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                dir = .right
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                dir = .down
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                dir = .left
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                dir = .up
            default:
                break
            }
        }
    }
    
    func checkDirection() {
        
        //Checks swipe gesture for the swipe feature
        //Moves our hero according to the position
        if dir == .right {
            player.position.x += 5
        } else if dir == .left {
            player.position.x -= 5
        } else if dir == .up {
            player.position.y += 5
        } else if dir == .down {
            player.position.y -= 5
        } else if dir == .still {
            return
        }
    }
    
    
    func updateAcellerometerData() {
        //While accelerometerData is active and force is being applied Clamp speed
        player.physicsBody?.velocity.dx.clamp(v1: -600, 600)
        player.physicsBody?.velocity.dy.clamp(v1: -600, 600)
        
        //TODO: Check the data
        //print("turbines to speed")
        guard let data = motionManager.accelerometerData else { return }
        
        //Applying movement according to the data
        player.position = CGPoint(x: player.position.x, y: CGFloat(player.position.y) + CGFloat(multiplierSpd * data.acceleration.x))
        //print("other \(data)")
    }
    
    func updateAnimals() {
        
        //Loop through all the animals in the scene
        for animal in creatureLayer.children as! [Animals] {
            
            //If the animal is moving on it's own let it be
            if animal.state != .still {
                
                //Animal is moving
                animal.startMoving()
                
                continue
            }
            
            //Scrolls the animal or gives makes it move
            let position = creatureLayer.convert(animal.position, to: self)
            
            //Check position
            if position.x >= (self.scene?.size.width)! / 2 {
                //if the animal is moving back 
                animal.position.x -= scrollSpd * CGFloat(fixedDelta)
            } else if position.x <= (self.scene?.size.width)! / 2 {
                //If we reached the center start moving to add flare
                animal.state = .moving
                animal.getValues()
                animal.startMoving()
            }
        }
        
        //Add a new animal
        if animalSpawnTimer > randAnimalSpawnTimer {
            
            //Creates the new animal
            let newAnimal = Animals()
            creatureLayer.addChild(newAnimal)
            print("creature ayer = \(creatureLayer.children)")
            
            //Adding a new position TODO: Add random position
            let newPosition = creatureSource.position
            newAnimal.position = self.convert(newPosition, to: creatureLayer)
            newAnimal.gameScene = self
            newAnimal.state = .still
            
            //Reset the animal spawnTimer
            animalSpawnTimer = 0
            
            //Get a new spawn time
            randAnimalSpawnTimer = CFTimeInterval(arc4random_uniform(UInt32(4.5)) + UInt32(3.5))
        }
    }
    
    func updateObstacles() {
        /* Update obstacles*/
        
        obstaclelayer.position.x -= scrollSpd * CGFloat(fixedDelta)
        
        let num = Int(arc4random_uniform(50))
        
        //Loop through the obstacle layer nodes
        for obstacles in obstaclelayer.children as! [Obstacle] {
            
            //Set reference to the obstacle position
            let obstaclePosition = obstaclelayer.convert(obstacles.position, to: self)
            
            //Check if the obstacle left the scene
            if obstaclePosition.x <= -26 {
                //26 if half of the objects width
                
                //Remove the obstacle node
                obstacles.removeFromParent()
            }
        }
                
        //Add new obstacles
        if spawnTimer >= randObstacleSpawnTimer {
            
            //Set reference of the new obstacle
            let newObstacle = Obstacle()
            //newObstacle.texture = SKTexture(imageNamed: newObstacle.getTexture())
            newObstacle.resetEverything()
            //print("new obstacle texture \(newObstacle.texture)")
            obstaclelayer.addChild(newObstacle)
            
            //Generate new random y position
            let randomPosition = CGPoint(x: obstacleSource.position.x, y: CGFloat.random(min: 180, max: 295))
            
            //Converts new obstacles position to the new position to the obstacle layer
            newObstacle.position = self.convert(randomPosition, to: obstaclelayer)
            
            //if num is greater than 25 we can add a second obstacle
            if num > 25 {
                
                //Add second obstacle to bottom half
                let secondObstacle = Obstacle()
                //secondObstacle.texture = SKTexture(imageNamed: secondObstacle.getTexture())
                secondObstacle.resetEverything()
                print("new obstacle texture \(secondObstacle)")
                obstaclelayer.addChild(secondObstacle)
            
                //Generate the random y position
                let secondRandomPosition = CGPoint(x: obstacleSource.position.x , y: CGFloat.random(min: 25, max: 130))
            
                //Conver the new postion to the new obstacle
                secondObstacle.position = self.convert(secondRandomPosition, to: obstaclelayer)
            }
            //Reset Timer
            spawnTimer = 0
            
            //Get a new rand timer
            randObstacleSpawnTimer = CFTimeInterval(arc4random_uniform(UInt32(1.5)) + UInt32(1.5))
        }
    }
    
    func stopUpdates() {
        print("stop updating the data")
        motionManager.stopAccelerometerUpdates()
    }
}
