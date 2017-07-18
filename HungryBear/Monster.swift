//
//  Monster.swift
//  HungryBear
//
//  Created by Cappillen on 7/12/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

enum MonsterState {
    case walking, attacking, idle
}

class Monster: SKSpriteNode {
    
    //Get access to the game scene 
    var gameScene: GameScene!
    let actionKey = "RemoveSoundKey"
    
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
        self.run(walk, withKey: actionKey)
        
    }
    
    func follow() {
        //Follow the player
        let playerPos: CGPoint = gameScene.player.position
        
        if self.position.y < playerPos.y {
             //move up
            self.position.y += 0.7
        } else if self.position.y > playerPos.y {
            //move down
            self.position.y -= 0.7
        }
        
    }
    
    func attack() {
        
        self.removeAction(forKey: actionKey)
        //Get the animation
        let animationAttack = SKAction.init(named: "Eat")
        
        //Sound
        //Monster Crunch
        var monsterCrunch: AVAudioPlayer?
        
        //Try and catch athe animal cry
        do {
            let crunchURL = URL.init(fileURLWithPath: Bundle.main.path(forResource: "monster-crunch", ofType: "mp3")!)
            monsterCrunch = try AVAudioPlayer(contentsOf: crunchURL)
            monsterCrunch!.prepareToPlay()
        } catch {
            print(error)
        }
        
        //Crunch action
        let crunch = SKAction.run({
            monsterCrunch?.volume = 1.0
            monsterCrunch?.play()
        })
        
        let seq = SKAction.sequence([animationAttack!, crunch])
        self.run(seq)
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
