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
    var spd: Int!
    var duration: Double!
    var boundaryTop: CGFloat!
    var boundaryDown: CGFloat!
    
    func startMoving() {
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
