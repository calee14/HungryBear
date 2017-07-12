//
//  Player.swift
//  HungryBear
//
//  Created by Cappillen on 7/12/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

enum PlayerState {
    case idle, running , death
}
class Player: SKSpriteNode {

    var playerState: PlayerState = .idle {
        didSet {
            switch playerState {
            case .running:
                running()
            case .death:
                death()
            case .idle:
                break
            }
        }
    }
    
    func running() {
        //Gets the animation and run it
        let animationRun = SKAction.init(named: "Running")
        let run = SKAction.repeatForever(animationRun!)
        self.run(run)
    }
    
    func death() {
        print("we were eaten")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
