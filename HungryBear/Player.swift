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
    case idle, running , death, ability
}
class Player: SKSpriteNode {

    var fallKey = "RemoveFallKey"
    var playerSpd: Double = 0.5
    
    var playerState: PlayerState = .idle {
        didSet {
            switch playerState {
            case .running:
                running(spd: playerSpd)
            case .death:
                break
            case .idle:
                break
            case .ability:
                break
            }
        }
    }
    
    func running(spd: Double) {
        
        //Makes sure that there are no running actions left over
        self.removeAction(forKey: fallKey)
        
        //Gets the animation and run it
        let animationRun = SKAction.init(named: "Running")
        animationRun?.duration = TimeInterval(spd)
        let run = SKAction.repeatForever(animationRun!)
        self.run(run, withKey: fallKey)
        
        let crashSound = SKAudioNode.init(fileNamed: "Walk-On-Grass")
        let adjustVolume = SKAction.changeVolume(to: 0.3, duration: 0.0)
        let playAudio = SKAction.play()
        crashSound.name = "walkingsound"
        print("the au\(crashSound)")
        crashSound.autoplayLooped = true
        self.addChild(crashSound)
        crashSound.run(adjustVolume)
        crashSound.run(playAudio)
    }
    
    func death() {
        let stepSound = self.childNode(withName: "walkingsound") as! SKAudioNode
        stepSound.removeFromParent()
        
        self.removeAction(forKey: fallKey)
        
        //Scaling it to its
        self.xScale = 0.225
        self.yScale = 0.225
        let deathAction = SKAction.init(named: "Death")
        self.run(deathAction!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
