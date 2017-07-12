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
    
    func getTexture() -> String {
        
        //String we are going to return
        var tree: String = ""
        //Type of tree
        var type: String = ""
        
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
            if randNum < 25 {
                num = "-1"
            } else if randNum < 50 {
                num = "-2"
            }
            
            //Color
            if randColor < 16 {
                color = "-dark"
            } else if randColor < 32 {
                color = "-light-brown"
            } else if randColor < 50 {
                color = "-red"
            }
            
            //Side
            if randSide < 25 {
                side = "-right"
            } else if randSide < 50 {
                side = "-left"
            }
            
            tree = "\(type)\(num)\(color)\(side)"
        }
        
        return tree
    }
    
    func resetEverything() {
        //Accessing the old and in with the new
        let size = self.texture?.size()
        
        let physics = SKPhysicsBody(rectangleOf: size!, center: CGPoint(x: 0 , y: 0))
        
        //Sine we reset the hit box we have to reset the properties as well
        physics.categoryBitMask = 1
        physics.collisionBitMask = 0
        physics.contactTestBitMask = 2
        physics.friction = 0.2
        physics.mass = 0.111111119389534
        physics.affectedByGravity = false
        
        //Assigning the new properties
        self.size = size!
        self.physicsBody = physics
        
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
    
    init() {
        
        let texture = SKTexture(imageNamed: "")
        let color = UIColor.clear
        let size = texture.size()
        
        super.init(texture: texture, color: color, size: size)
        
        //Set the physical properties
        physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: 0, y: size.width / 2))
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 2
        physicsBody?.friction = 0.2
        physicsBody?.mass = 0.111111119389534
        physicsBody?.affectedByGravity = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
