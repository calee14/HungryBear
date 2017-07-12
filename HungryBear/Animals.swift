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
    case still, moving
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
    
    func deathScene() {
        //Gets position
        let position = self.position
        let distanceFrom0 = self.position.x.distance(to: 0)
        
        //Creating our death scene; move to the end and delete
        let moveTo0 = SKAction.move(to: CGPoint(x: 0, y: self.position.y), duration: 2)
        let remove = SKAction.run({
            self.removeFromParent()
        })
        let addPoints = SKAction.run ({
            self.gameScene.updatePoints()
        })
        
        //Build and run the sequence
        let seq = SKAction.sequence([moveTo0, remove, addPoints])
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
            let randSpd = arc4random_uniform(3) + 2
            spd = CGFloat(randSpd)
        
            //Random Duration
            let randDuration = arc4random_uniform(7) + 3
            duration = Double(randDuration)
        
            //Boundaries
            boundaryTop = 300
            boundaryDown = 30
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
}
