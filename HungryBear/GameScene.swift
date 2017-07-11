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
    var player: SKSpriteNode!
    var obstaclelayer: SKNode!
    var obstacleSource: SKNode!
    var spawnTimer: CFTimeInterval = 0
    var secondSpawnTimer: CFTimeInterval = 0
    var animalSpawnTimer: CFTimeInterval = 0
    var scrollSpd: CGFloat = 200
    var prevSpacePosition: CGPoint!
    var creatureLayer: SKNode!
    var creatureSource: Animals!
    
    override func didMove(to view: SKView) {
        //Start your scene here
        
        physicsWorld.contactDelegate = self
        //Get reference to the UI objects
        
        //Connect spaceShip
        player = self.childNode(withName: "player") as! SKSpriteNode
        //Connect obstacleLayer
        obstaclelayer = self.childNode(withName: "obstacleLayer")
        //Connect obstacle
        obstacleSource = self.childNode(withName: "obstacle")
        creatureLayer = self.childNode(withName: "creatureLayer")
        creatureSource = self.childNode(withName: "creature") as! Animals
        
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "creature" && nodeB.name == "obstalce" {
            print("they collided")
            return
        } else if nodeB.name == "obstacle" && nodeA.name == "creature" {
            print("they collided")
            return
        }
        //If any object with physics body collides with the frame boundaries
        if nodeA.name == nil {
            //nodeB.removeAllActions()
            return
        } else if nodeB.name == nil {
            //nodeA.removeAllActions()
            return
        }
        
        //If player collides with the obstacle
        if nodeA.name == "player" && nodeB.name == "obstacle"{
            let shakeScene = SKAction.run({
                let shake = SKAction.init(named: "ShakeItUp")
                for node in self.children {
                    node.run(shake!)
                }
            })
            self.player.run(shakeScene)
        } else if nodeA.name == "player" && nodeB.name == "obstacle" {
            let shakeScene = SKAction.run({
                let shake = SKAction.init(named: "ShakeItUp")
                for node in self.children {
                    node.run(shake!)
                }
            })
            self.player.run(shakeScene)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        //If the player collided with the obstacle start tp move the player back
        if nodeA.name == "player" && nodeB.name == "obstacle" {
            let move = SKAction.move(to: CGPoint(x: player.position.x - 75, y: player.position.y), duration: 1)
            let seq = SKAction.sequence([move])
            player.run(seq)
            nodeB.removeFromParent()
        } else if nodeB.name == "player" && nodeA.name == "obstacle" {
            let move = SKAction.move(to: CGPoint(x: player.position.x - 75, y: player.position.y), duration: 1)
            let seq = SKAction.sequence([move])
            player.run(seq)
            nodeA.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //The accelerometer
        updateAcellerometerData()
        
        if player.position.x < 0 { print("GameOver") }
        //Check direction
        //checkDirection()
        
        updateAnimals()
        //Spawns the obstacles
        updateObstacles()
        
        //update time
        animalSpawnTimer += fixedDelta
        secondSpawnTimer += fixedDelta
        spawnTimer += fixedDelta
    }
    
    func swiped(_ gesture: UIGestureRecognizer) {
        
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
        player.position = CGPoint(x: player.position.x, y: CGFloat(player.position.y) + CGFloat(-7 * data.acceleration.x))
        //print("other \(data)")
    }
    
    func updateAnimals() {
        
        //Loop through all the animals in the scene
        for animal in creatureLayer.children as! [Animals] {
            
            //If the animal is moving on it's own let it be
            if animal.state != .still { continue }
            
            let position = creatureLayer.convert(animal.position, to: self)
            
            if position.x >= (self.scene?.size.width)! / 2 {
                //if the animal is moving back 
                animal.position.x -= scrollSpd * CGFloat(fixedDelta)
            } else if position.x <= (self.scene?.size.width)! / 2 {
                //If we reached the center start moving to add flare
                animal.state = .moving
                animal.startMoving()
            }
        }
        
        //Add a new animal
        if animalSpawnTimer > 1 {
            
            let newAnimal = creatureSource.copy() as! Animals
            creatureLayer.addChild(newAnimal)
            newAnimal.state = .still
            let newPosition = creatureSource.position
            newAnimal.position = self.convert(newPosition, to: creatureLayer)
            
            animalSpawnTimer = 0
        }
    }
    
    func updateObstacles() {
        /* Update obstacles*/
        
        obstaclelayer.position.x -= scrollSpd * CGFloat(fixedDelta)
        
        //Loop through the obstacle layer nodes
        for obstacles in obstaclelayer.children as! [SKSpriteNode] {
            
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
        if spawnTimer >= 2.5 {
            
            //Set reference of the new obstacle
            let newObstacle = obstacleSource.copy() as! SKNode
            obstaclelayer.addChild(newObstacle)
            
            //Generate new random y position
            let randomPosition = CGPoint(x: obstacleSource.position.x, y: CGFloat.random(min: 180, max: 295))
            
            //Converts new obstacles position to the new position to the obstacle layer
            newObstacle.position = self.convert(randomPosition, to: obstaclelayer)
            
            //Add second obstacle to bottom half
            let secondObstacle = obstacleSource.copy() as! SKNode
            obstaclelayer.addChild(secondObstacle)
            
            //Generate the random y position
            let secondRandomPosition = CGPoint(x: obstacleSource.position.x , y: CGFloat.random(min: 25, max: 130))
            
            //Conver the new postion to the new obstacle
            secondObstacle.position = self.convert(secondRandomPosition, to: obstaclelayer)
            
            //Reset Timer
            spawnTimer = 0
            
        }
    }
    
    func stopUpdates() {
        print("stop updating the data")
        motionManager.stopAccelerometerUpdates()
    }
}
