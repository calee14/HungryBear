//
//  PowerBar.swift
//  HungryBear
//
//  Created by Cappillen on 7/19/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class PowerBar: SKSpriteNode {
    
    var numOfBars = 8
    var maxNumOfBars = 8
    var bar1: SKSpriteNode!
    var bar2: SKSpriteNode!
    var bar3: SKSpriteNode!
    var bar4: SKSpriteNode!
    
    func connectBars() {
        
//        for _ in self.children {
//            maxNumOfBars += 1
//        }
        
        bar1 = self.childNode(withName: "bar1") as! SKSpriteNode
        bar2 = self.childNode(withName: "bar2") as! SKSpriteNode
        bar3 = self.childNode(withName: "bar3") as! SKSpriteNode
        bar4 = self.childNode(withName: "bar4") as! SKSpriteNode
        
//        for bar in self.children {
//            bar.isHidden = true
//        }
    }
    
    func addBar() {
        if numOfBars != maxNumOfBars {
            numOfBars += 1
            let newBar = self.childNode(withName: "bar\(numOfBars)") as! SKSpriteNode
            newBar.isHidden = false
        }
    }
    
    func removeBar() {
        
        if numOfBars != 0 {
            numOfBars -= 1
            let removeBar = self.childNode(withName: "bar\(numOfBars + 1)") as! SKSpriteNode
            removeBar.isHidden = true
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
