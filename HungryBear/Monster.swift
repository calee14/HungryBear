//
//  Monster.swift
//  HungryBear
//
//  Created by Cappillen on 7/12/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

enum MonsterState {
    case walking, attacking, idle
}

class Monster: SKSpriteNode {
    
    var monsterState: MonsterState = .walking {
        didSet {
            switch monsterState {
            case .walking:
                walking()
            case .attacking:
                attack()
            case .idle:
                break
            }
        }
    }
    
    func walking() {
        //Gets the animation
        let animationWalk = SKAction.init(named: "Walk")
        let walk = SKAction.repeatForever(animationWalk!)
        self.run(walk)
    }
    
    func attack() {
        print("attack")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
