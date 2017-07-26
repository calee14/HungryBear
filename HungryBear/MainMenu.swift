//
//  MainMenu.swift
//  HungryBear
//
//  Created by Cappillen on 7/18/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class MainMenu: SKScene {
    
    //Connect UI objects
    var playButton: MSButtonNode!
    var playButton2: MSButtonNode!
    var settingsButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        //Play the audio file
        //Start the background music
        let backgroundSound = SKAudioNode.init(fileNamed: "BackgroundMix")
        let adjustVolume = SKAction.changeVolume(to: 1.0, duration: 0.0)
        let playAudio = SKAction.play()
        backgroundSound.name = "background"
        backgroundSound.autoplayLooped = true
        
        //Add it to the scene and play it
        self.addChild(backgroundSound)
        backgroundSound.run(adjustVolume)
        backgroundSound.run(playAudio)
        
        //Connect the UI objects
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        
        //playButton selected handler
        playButton.selectedHandler = { [unowned self] in
            //let song = self.childNode(withName: "background")
            //song?.removeFromParent()
            
            //Change the scene
            self.loadGame(fileName: "GameScene")
        }
        
        playButton2 = self.childNode(withName: "playButton2") as! MSButtonNode
        
        //playButton2 selected handler
        playButton2.selectedHandler = { [unowned self] in
            
            //Change the scene
            self.loadGame(fileName: "GameScene")
        }
        
        settingsButton = self.childNode(withName: "settingsButton") as! MSButtonNode
        
        //settigns button selected handler
        settingsButton.selectedHandler = { [unowned self] in
            
            //Load the settings scene
            print("No button action set")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func loadGame(fileName: String) {
        //Grab reference to our sprite kit view
        
        //1) grab reference to our spriteKit view
        guard let skView = self.view as SKView! else {
            print("could not get SKView")
            return
        }
        //2) Load game scene
        guard let scene = SKScene(fileNamed: fileName) else {
            print("Could not make GameScene, check the name is spelled correctly")
            return
        }
        //Enusre the aspect mode is correct
        scene.scaleMode = .aspectFit
        
        //Show Debug
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        //4)
        skView.presentScene(scene)
        
    }
    
}
