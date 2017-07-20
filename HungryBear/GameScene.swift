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
    var foodLayer: SKNode!
    var foodSource: SKNode!
    var powerBar: PowerBar!
    var powerButton: MSButtonNode!
    
    //Initialize variables
    var spawnTimer: CFTimeInterval = 0
    var secondSpawnTimer: CFTimeInterval = 0
    var animalSpawnTimer: CFTimeInterval = 0
    var foodSpawnTimer: CFTimeInterval = 0
    var randFoodSpawnTimer: CFTimeInterval = 10
    var randObstacleSpawnTimer: CFTimeInterval = 1
    var randAnimalSpawnTimer: CFTimeInterval = 5
    var scrollSpd: CGFloat = 200
    var prevSpacePosition: CGPoint!
    var points = 0
    var highscore = 0
    var distanceFromCenterCount = 4
    var distanceCounter = 40
    var shakeTimer: CFTimeInterval = 0
    var animalMoveTimer: CFTimeInterval = 0
    var multiplierSpd = -7.0
    var lock = false
    var landscape = ""
    
    var toBeDeleted = [SKSpriteNode]()
    
    //Connect UI objects
    var pointsLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        //Setup your scene here
        
        physicsWorld.contactDelegate = self
        //Get reference to the UI objects
        
        //Connect player
        player = self.childNode(withName: "//player") as! Player
        player.playerState = .running
        
        //Connect the power bar feature
        powerBar = self.childNode(withName: "powerBar") as! PowerBar
        powerBar.connectBars()
        
        powerButton = self.childNode(withName: "powerButton") as! MSButtonNode
        
        powerButton.selectedHandler = {
            
            //If the player is dead or no powerups the power ups don't have any effect
            if self.powerBar.numOfBars != 0 && self.player.playerState != .death {
                self.boostsThePlayer()
            }
        }
        
        //Connect obstacleLayer
        obstaclelayer = self.childNode(withName: "obstacleLayer")
        
        //Connect wolf
        wolf = self.childNode(withName: "//wolf") as! Monster
        wolf.monsterState = .walking
        wolf.gameScene = self
        
        //Connect the food spawners
        foodLayer = self.childNode(withName: "foodLayer")
        foodSource = self.childNode(withName: "food")
        
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
        
        //Start the background music
        let backgroundSound = SKAudioNode.init(fileNamed: "BackgroundMix3")
        let adjustVolume = SKAction.changeVolume(to: 1.0, duration: 0.0)
        let playAudio = SKAction.play()
        backgroundSound.name = "background"
        print("the au\(backgroundSound)")
        backgroundSound.autoplayLooped = true
        
        //Add it to the scene and play it
        self.addChild(backgroundSound)
        backgroundSound.run(adjustVolume)
        backgroundSound.run(playAudio)
        
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
        if nodeA.name == "player" && nodeB.name == "obstacle" || nodeB.name == "player" && nodeA.name == "obstacle" && player.playerState == .running {
            print("It says player state is not ability it is \(player.playerState)")
            if player.playerState == .ability { print("It says: player state says \(player.playerState)") }
            
            //Timer for running collision actions
            if shakeTimer > 0.7 && player.playerState != .ability{
                //Runs the shake scene to give the player something to see
                let shakeScene = SKAction.run({
                let shake = SKAction.init(named: "ShakeItUp")
                for node in self.children {
                    node.run(shake!)
                    }
                })
                
                self.player.run(shakeScene)
            
                //Play the sound
                //Booom
                //Start the background music
                let boomSound = SKAudioNode.init(fileNamed: "tree-crash")
                let adjustVolume = SKAction.changeVolume(to: 0.6, duration: 0.0)
                let playAudio = SKAction.play()
                print("the au\(boomSound)")
                boomSound.autoplayLooped = false
                
                //Add it to the scene and play it
                self.addChild(boomSound)
                boomSound.run(adjustVolume)
                boomSound.run(playAudio)
                
                
                ///
                print("this is nodeB: \(nodeB)")
                //Moves the player back
                let move = SKAction.move(to: CGPoint(x: player.position.x - CGFloat(distanceCounter), y: player.position.y), duration: 1)
                let seq = SKAction.sequence([move])
                player.run(seq)
            
                //Updates the count of the counters to death
                distanceFromCenterCount -= 1
                print(distanceFromCenterCount)
                distanceFromMonster()
                print("something")
                shakeTimer = 0
            }
            
        }
        
        if nodeA.name == "player" && nodeB.name == "food" || nodeA.name == "food" && nodeB.name == "player" {
            //Run code for if the player collided with the food
            
            //Give the power bar a bar
            powerBar.addBar()
            
            //remove the food the human has eaten
            if nodeB.name == "food" {
                let food = nodeB
                toBeDeleted.append(food as! SKSpriteNode)
            } else if nodeA.name == "food"{
                let food = nodeA
                toBeDeleted.append(food as! SKSpriteNode)
            }
        }
        // else if nodeA.name == "player" && nodeB.name == "obstacle" {
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
        
    } //End of the didBeginContact func
    
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
        
        //Locks the Orientations HOPEFULLY TPODO: check if its working
        print("The lock is \(lock)")
        if lock == false {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
                print("landscape Left")
                AppUtility.lockOrientation(.landscapeRight)
                landscape = "right"
                lock = true
            } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                print("landScap Right")
                AppUtility.lockOrientation(.landscapeLeft)
                landscape = "left"
                lock = true
            } else {
                print("There is no orientation")
            }
            
            
            
        }
        
        print("there are \(powerBar.numOfBars)")
        //TODO: fix the
        
        //Scroll the ground
        scroller(spd: scrollSpd)
        
        print(player.position)
        //Check if the monster is going to eat the player
        distanceFromMonster()
        
        //The accelerometer
        updateAcellerometerData()
        
        //Check direction
        //checkDirection()
        
        //Update the monster
        wolf.follow()
        
        //Update the foods spawners
        updateFood()
        
        //Updates the animals
        updateAnimals()
        
        //Spawns the obstacles
        updateObstacles()
        
        for object in toBeDeleted {
            object.removeFromParent()
        }
        
        toBeDeleted = [SKSpriteNode]()
        
        //update time
        foodSpawnTimer += fixedDelta
        animalSpawnTimer += fixedDelta
        secondSpawnTimer += fixedDelta
        spawnTimer += fixedDelta
        shakeTimer += fixedDelta
        animalMoveTimer += fixedDelta
    }
    
    func boostsThePlayer() {
        //Run the player's boost ability here
        
        if player.playerState == .ability { return }
        
        //Use up a bar
        self.powerBar.removeBar()
        
        //Run the animations
        let boost = SKAction.run({
            let moveAction = SKAction.move(to: CGPoint(x: self.player.position.x + 10 , y: self.player.position.y), duration: 1)
        
            //Make the screen scroll faster
            self.scrollSpd += 200
        
            //Chagnes the state to ability
            //So when we collide it won't count
            self.player.playerState = .ability
        
            //Make us run faster
            self.player.running(spd: 0.3)
            
            self.player.run(moveAction)
        })
        
        //Duration of the boosts
        let wait = SKAction.wait(forDuration: 1)
        
        //Reset everythin
        let reset = SKAction.run({
            
            //Reset scrollSpd
            self.scrollSpd = 200
            
            //Change the player state back to running
            self.player.running(spd: 0.5)
            self.player.playerState = .running
        })
        
        let theBoost = SKAction.sequence([boost, wait, reset])
        player.run(theBoost)
        
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
        //Checks if we are going to be eaten by the monster
        //If so run an animation and change the scene
        print("Counter: \(distanceFromCenterCount)")
        
        //If the player is in his ability mode get out
        if player.playerState == .ability { return }
        
        //Checking if the player isn't dead yet and if not make him run the death animation
        if player.position.x <= CGFloat(0 - (distanceCounter * 4)) && player.playerState != .death {
            
            //Make sure there are no more active action
            player.removeAllActions()
            
            player.playerState = .death 
            player.position.x -= CGFloat(distanceCounter * 4 / 60) * CGFloat(fixedDelta)
            
            //Stop the music 
            let stepSound = self.childNode(withName: "background") as! SKAudioNode
            stepSound.removeFromParent()
            
            //Stop updating the acceleromter and stop player
            //Do what ever to stop the player
            //motionManager.stopAccelerometerUpdates()
            multiplierSpd = 0
            landscape = ""
            
            //Stop scrolling the background
            scrollSpd = 0
            
            //Actions for the death scene
            let attack = SKAction.run({
                self.wolf.attack()
            })
            
            
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
            scene.lock = true
            
            //Show Debug
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            
            
            //4)
            let changeScene = SKAction.run({
                let transition = SKTransition.moveIn(with: .right, duration: 1)
                skView.presentScene(scene, transition: transition)
            })
            
            //Runs our hero's death animation
            let runEaten = SKAction.run({
                self.player.death()
            })
            
            let wait1 = SKAction.wait(forDuration: 4)
            let wait2 = SKAction.wait(forDuration: 0.5)
            let seq = SKAction.sequence([attack, wait2, runEaten, wait1, changeScene])
            run(seq)
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
        let dir: String = landscape
        guard let data = motionManager.accelerometerData else { return }
        
        if dir == "left" {
           multiplierSpd = -7
        } else if dir == "right" {
            multiplierSpd = 7
        }
        //Applying movement according to the data
        player.position = CGPoint(x: player.position.x, y: CGFloat(player.position.y) + CGFloat(multiplierSpd * data.acceleration.x))
        //print("other \(data)")
    }
    
    func updateFood() {
        
        //Moves all the children on the food layer
        
        //Loops through all the foods in the layer
        for food in foodLayer.children as! [Food] {
            
            let foodPosition = foodLayer.convert(food.position, to: self)
            
            food.position.x -= scrollSpd * CGFloat(fixedDelta)
            if foodPosition.x <= -26 {
                
                print("we print the new food \(foodLayer.children)")
                food.removeFromParent()
            }
        }
        
        //Make a new food
        if foodSpawnTimer >= randFoodSpawnTimer {
            
            let newFood = Food()
            foodLayer.addChild(newFood)
            
            foodSpawnTimer = 0
            randFoodSpawnTimer = CFTimeInterval(arc4random_uniform(10) + 9)
            
        }
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
            //let newPosition = creatureSource.position
            //newAnimal.position = self.convert(newPosition, to: creatureLayer)
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
            
            //If num is less than 25 only add one obstacel
            if num < 25 {
                //Set reference of the only one obstacle
                let newObstacle = Obstacle()
                //newObstacle.texture = SKTexture(imageNamed: newObstacle.getTexture())
                newObstacle.resetEverything()
                //print("new obstacle texture \(newObstacle.texture)")
                obstaclelayer.addChild(newObstacle)
            
                //Generate new random y position that can be anywhere on the map
                let randomPosition = CGPoint(x: obstacleSource.position.x, y: CGFloat.random(min: 25, max: 295))
            
                //Converts new obstacles position to the new position to the obstacle layer
                newObstacle.position = self.convert(randomPosition, to: obstaclelayer)
                
            } else if num < 50 {
                //if num is less than 50 more than 25 we can add two obstacle
                
                //Set reference to the first obstacle
                let newObstacle = Obstacle()
                newObstacle.resetEverything()
                //print("new obstacle texture \(newObstacle.texture)")
                obstaclelayer.addChild(newObstacle)
                
                //Generate new random y position on top half of the screen
                let randomPosition = CGPoint(x: obstacleSource.position.x, y: CGFloat.random(min: 180, max: 295))
                
                //Converts new obstacles position to the new position to the obstacle layer
                newObstacle.position = self.convert(randomPosition, to: obstaclelayer)
                
                //Add second obstacle to bottom half
                let secondObstacle = Obstacle()
                secondObstacle.resetEverything()
                print("new obstacle texture \(secondObstacle)")
                obstaclelayer.addChild(secondObstacle)
            
                //Generate the random y position for the bottom half of the screen
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
