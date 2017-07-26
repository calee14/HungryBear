//
//  Food.swift
//  HungryBear
//
//  Created by Cappillen on 7/18/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class Food: SKSpriteNode {
    
    
    func getTexture() -> String {
        
        let rand = arc4random_uniform(100)
        var typeOfFood = ""
        
        if rand < 8 {
            typeOfFood = "bannana"
        } else if rand < 16 {
            typeOfFood = "bread"
        } else if rand < 24 {
            typeOfFood = "burger"
        } else if rand < 32 {
            typeOfFood = "cheese"
        } else if rand < 40 {
            typeOfFood = "cherry"
        } else if rand < 48 {
            typeOfFood = "chocolate"
        } else if rand < 56 {
            typeOfFood = "eggs"
        } else if rand < 64 {
            typeOfFood = "honey"
        } else if rand < 72 {
            typeOfFood = "milk"
        } else if rand < 80 {
            typeOfFood = "orange-slice"
        } else if rand < 100 {
            typeOfFood = "pipsi"
        }
        
        return typeOfFood
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        //Gives the texture to the food
        let newTexture = SKTexture(imageNamed: getTexture())
        
        //Creating a new animal
        //Position, name, size, physics, etc.
        let position = CGPoint(x: 885, y: Int(arc4random_uniform(240) + 40))
        let name = "food"
        let size = newTexture.size()
        let physics = SKPhysicsBody(rectangleOf: CGSize(width: newTexture.size().width, height: newTexture.size().height), center: CGPoint(x: 0, y: 0))
        
        physics.affectedByGravity = false
        physics.contactTestBitMask = 3
        physics.categoryBitMask = 1 
        physics.collisionBitMask = 0
        
        //Gives the new properties of the animal
        self.zPosition = 13
        self.texture = newTexture
        self.position = position
        self.name = name
        self.size = size
        self.physicsBody = physics
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
