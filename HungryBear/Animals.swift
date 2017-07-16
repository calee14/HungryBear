//
//  Animals.swift
//  HungryBear
//
//  Created by Cappillen on 7/10/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

enum AnimalState {
    case still, moving, idle
}

enum Vertical {
    case up, down
}

class Animals: SKSpriteNode {
    
    var state: AnimalState = .still
    
    //Getting the variables stats for our animal
    var dir: Vertical!
    var spd: CGFloat!
    var duration: Double!
    var boundaryTop: CGFloat = 300
    var boundaryDown: CGFloat = 20
    var count = 0.0
    var gameScene: GameScene!
    
    //variables for picking our animal
    var species: String!
    
    func startMoving() {
        
        //If we are moving we can move
        if state == .moving {
            
            //Check if we need to change directions
            if count >= duration {
                count = 0
                getValues()
            }
            
            //If we are moving up move up else down down
            if dir == .up {
                self.position.y += spd
            } else if dir == .down {
                self.position.y -= spd
            }
            
            //Reset move values if we hit the boundaries
            if self.position.y >= boundaryTop || self.position.y <= boundaryDown {
                getValues()
            }
            
            //Update the count
            count += 0.5
        }
    }
    
    func animateAnimal() {
        let imageName = species
        var imageArray: [SKTexture] = []
        for i in 1...3 {
            print("i is = \(i)")
            imageArray.append(SKTexture(imageNamed: "\(imageName!)-\(i)"))
        }
        print(imageArray)
        let animate = SKAction.repeatForever(SKAction.animate(with: imageArray, timePerFrame: 0.1))
        self.run(animate)
    }
    
    func deathScene() {
        //Gets position
        let position = self.position
        let distanceFrom0 = self.position.x.distance(to: 0)
        
        //Set the animal to do nothing
        state = .idle
        
        //Creating our death scene; move to the end and delete
        let moveTo0 = SKAction.move(to: CGPoint(x: 30, y: self.position.y), duration: 2)
        
        let addPoints = SKAction.run ({
            self.gameScene.updatePoints()
        })
        let attack = SKAction.run({
            self.deathAnimation()
        })
        
        //Build and run the sequence
        let seq = SKAction.sequence([moveTo0, attack, addPoints])
        self.run(seq)
        
        print(position)
        print(distanceFrom0)
    }
    
    func getValues() {
        
        //If we are beyond the boundaries bring it back in
        if self.position.y >= boundaryTop || self.position.y <= boundaryDown {
            if dir == .up {
                dir = .down
            } else if dir == . down {
                dir = .up
            }
        } else {
            
            //Get Random direction
            let randDir = arc4random_uniform(10)
            if randDir < 5 {
                dir = .up
            } else if randDir < 10 {
                dir = .down
            }
        
            //Random Speed
            let randSpd = arc4random_uniform(2) + 1
            spd = CGFloat(randSpd)
        
            //Random Duration
            let randDuration = arc4random_uniform(7) + 3
            duration = Double(randDuration)
        
            //Boundaries
            boundaryTop = 300
            boundaryDown = 30
        }
    }
    
    func getTexture() -> String {
        
        let rand = arc4random_uniform(100)
        let textureAtlas = SKTextureAtlas(named: "animals")
        //Gets an random texture for the animals
        if rand < 7 {
            //7% chance
            species = "chicken"
        } else if rand < 14 {
            //7% chance
            species = "chipmunk"
        } else if rand < 21 {
            //7% chance
            species = "cow"
        } else if rand < 28 {
            //7% chance
            species = "cow-brown"
        } else if rand < 35 {
            //7% chance
            species = "deer"
        } else if rand < 42 {
            //7% chance
            species = "elk"
        } else if rand < 49 {
            //7% chance
            species = "goat"
        } else if rand < 56 {
            //7% chance
            species = "pig"
        } else if rand < 63 {
            //7% chance
            species = "prairie-dog"
        } else if rand < 70 {
            //7% chance
            species = "rabbit-brown"
        } else if rand < 77 {
            //7% chance
            species = "rabbit-white"
        } else if rand < 84 {
            //7% chance
            species = "sheep"
        } else if rand < 100 {
            //16% chance
            species = "cat"
        }
        print("Animal \(species)")
        checkScaling(imageText: "\(species!)-1")
        return "\(species!)-1"
    }
    
    func checkScaling(imageText: String) {
        let image = SKTexture(imageNamed: imageText)
        let imageSize = image.size()
        
        let scaleSize = 300.0
        if imageSize.width < 25 || imageSize.width < 25 {
            
            let width = imageSize.width
            let height = imageSize.height
            var greatest = 0.0
            
            if width > height {
                greatest = Double(width)
            } else if height > width {
                greatest = Double(height)
            } else {
                greatest = Double(height)
            }
            
            let newScale = scaleSize / greatest
            
            self.xScale = CGFloat(newScale)
            self.yScale = CGFloat(newScale)
            
            
        }
    }
    
    func deathAnimation() {
        //Creating a new node to run the animation
        let newNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: CGSize(width: 25,height: 25))
        newNode.position.x = 0
        newNode.position.y = self.position.y
        newNode.zPosition = 20
        newNode.xScale = 0.7
        newNode.yScale = 0.7
        gameScene.addChild(newNode)
        
        //The animation the new node will run
        let eat = SKAction.init(named: "Eat")
        let removeAnimal = SKAction.run({
            self.removeFromParent()
        })
        let removeNode = SKAction.run({
            let wait = SKAction.wait(forDuration: 0.66)
            let deleteNode = SKAction.run ({
                newNode.removeFromParent()
            })
            let seq = SKAction.sequence([wait, deleteNode])
            newNode.run(seq)
        })
        let seq = SKAction.sequence([removeAnimal, eat!, removeNode])
        newNode.run(seq)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        //Gives the texture to the animal
        let newTexture = SKTexture(imageNamed: getTexture())
        
        //Creating a new animal 
        //Position, name, size, physics, etc.
        let position = CGPoint(x: 645, y: 160)
        let name = "creature"
        let size = newTexture.size()
        let physics = SKPhysicsBody(rectangleOf: newTexture.size())
        physics.affectedByGravity = false
        physics.contactTestBitMask = 3
        physics.categoryBitMask = 1
        physics.collisionBitMask = 0
        
        //Gives the new properties of the animal
        self.zPosition = 10
        self.texture = newTexture
        self.position = position
        self.name = name
        self.size = size
        self.physicsBody = physics
        
        self.animateAnimal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
