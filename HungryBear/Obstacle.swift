//
//  Obstacle.swift
//  HungryBear
//
//  Created by Cappillen on 7/12/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: SKSpriteNode {
    
    //Type of tree
    var type: String = ""
    
    func getTexture() -> String {
        //Tree we are going to return
        var tree: String = ""
        
        //Random values for trees
        var size: String = ""
        var shade: String = ""
        
        let randType = arc4random_uniform(50)
        let randSize = arc4random_uniform(50)
        let randShade = arc4random_uniform(50)
        
        //Find if the obstacle is a tree of log
        if randType < 25 {
            type = "pine-tree"
            
        } else if randType < 50 {
            type = "log"
        }
        
        //if tree find the size of it and shade of it
        if type == "pine-tree" {
            
            //Size
            if randSize < 20 {
                size = "-small"
            } else if randSize < 40 {
                size = "-medium"
            } else if randSize < 50 {
                size = "-large"
            }
            
            //Shade
            if randShade < 13 {
                shade = "-dark-green"
            } else if randShade < 26 {
                shade = "-bright-green"
            } else if randShade < 39 {
                shade = "-dark-medium-green"
            } else if randShade < 50 {
                shade = "-light-green"
            }
            
            tree = "\(type)\(size)\(shade)"
        }
        
        //Random values for the logs
        var num: String = ""
        var color: String = ""
        var side: String = ""
        
        let randNum = arc4random_uniform(50)
        let randColor = arc4random_uniform(50)
        let randSide = arc4random_uniform(50)
        
        //If log find the size of it and shade of it
        if type == "log" {
            
            //Type
            if randNum < 0 {
                num = "-1"
            } else if randNum < 50 {
                num = "-2"
            }
            
            //Color
            if randColor < 0 {
                color = "-dark"
            } else if randColor < 0 {
                color = "-light-brown"
            } else if randColor < 50 {
                color = "-red"
            }
            
            //Side
            if randSide < 0  {
                side = "-right"
            } else if randSide < 50 {
                side = "-left"
            }
            
            tree = "\(type)\(num)\(color)\(side)"
        }
        
        return tree
    }
    
    func resetEverything() {
        //If its a log give it the original properties
        if self.type == "log" {
            //Accessing the old and in with the new
            let size = self.texture?.size()
            self.anchorPoint = CGPoint(x: 0.5 ,y: 0.5)
            let physics = SKPhysicsBody(texture: self.texture!, alphaThreshold: 0.9 , size: size!)
            //Since we reset the hit box we have to reset the properties as well
            physics.categoryBitMask = 1
            physics.collisionBitMask = 0
            physics.contactTestBitMask = 2
            physics.friction = 0.2
            physics.mass = 0.111111119389534
            physics.affectedByGravity = false
        
            //Assigning the new properties
            self.size = size!
            self.physicsBody = physics
        }
        
        //Else do the tree stuff
        let size = self.texture?.size()
        
        //Check the scale of the image and rescaling it
        let scaleSize = 100.0
        if Double((size?.width)!) > scaleSize || Double((size?.height)!) > scaleSize {
            
            let height: Double = Double((size?.height)!)
            let width: Double = Double((size?.width)!)
            var greatest: Double = 0
            
            if height > width{
                greatest = height
            } else {
                greatest = width
            }
            
            let newScale = scaleSize / greatest
            
            self.xScale = CGFloat(newScale)
            self.yScale = CGFloat(newScale)
            print(self.xScale)
            print(self.yScale)
        }

    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        //Gives the texture to the animal
        let newTexture = SKTexture(imageNamed: getTexture())
        
        //Creating a new animal
        //Position, name, size, physics, etc.
        let position = CGPoint(x: 760, y: 160)
        let name = "obstacle"
        let size = newTexture.size()
        let physics = SKPhysicsBody(rectangleOf: CGSize(width: newTexture.size().width / 1.2, height: newTexture.size().height / 2), center: CGPoint(x: 0, y: 0))
        
        physics.affectedByGravity = false
        physics.contactTestBitMask = 2
        physics.categoryBitMask = 1
        physics.collisionBitMask = 0
        
        //Gives the new properties of the animal
        self.zPosition = 10
        self.anchorPoint = CGPoint(x: 0.6, y: 0.3)
        self.texture = newTexture
        self.position = position
        self.name = name
        self.size = size
        self.physicsBody = physics
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
