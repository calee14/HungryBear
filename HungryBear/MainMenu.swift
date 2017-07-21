//
//  MainMenu.swift
//  HungryBear
//
//  Created by Cappillen on 7/18/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    //Connect UI objects
    var playButton: MSButtonNode!
    var playButton2: MSButtonNode!
    var settingsButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        //Connect the UI objects
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        
        //playButton selected handler
        playButton.selectedHandler = { [unowned self] in
            
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
