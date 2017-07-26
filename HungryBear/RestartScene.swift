//
//  Restart.swift
//  HungryBear
//
//  Created by Cappillen on 7/21/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class RestartScene: SKScene {
    
    //Connecting UI
    //Main labels
    var scoreLabel: SKLabelNode!
    var prevScoreLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    
    //feel good text
    var feelText: SKLabelNode!
    
    //Buttons
    var restartButton: MSButtonNode!
    var mainMenuButton: MSButtonNode!
    var settingsButtonNode: MSButtonNode!
    
    var score: Int = 0
    var highscore: Int = 0
    var prevScore: Int = 0
    var prevHighscore: Int = 0
    
    override func didMove(to view: SKView) {
        
        //Play the growl
        let growlSound = SKAudioNode.init(fileNamed: "monster-growl1")
        let adjustVolume = SKAction.changeVolume(to: 1.0, duration: 0.0)
        let playAudio = SKAction.play()
        growlSound.name = "monstergrowl"
        growlSound.autoplayLooped = false
        
        //Add it to the scene and play it
        self.addChild(growlSound)
        growlSound.run(adjustVolume)
        growlSound.run(playAudio)
        
        //Declaring user defaults
        let userDefault = UserDefaults.standard
        
        //Connecting UI 
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        highscoreLabel = self.childNode(withName: "highscoreLabel") as! SKLabelNode
        prevScoreLabel = self.childNode(withName: "prevScoreLabel") as! SKLabelNode
        feelText = self.childNode(withName: "feelText") as! SKLabelNode
        feelText.isHidden = true
        feelText.text = "good try"
        
        //initialize the prevhighscore
        prevHighscore = userDefault.integer(forKey: "prevHigh")
        
        //Connect the buttons
        restartButton = self.childNode(withName: "restartButton") as! MSButtonNode
        //Restart Selected handler
        restartButton.selectedHandler = { [unowned self] in
            self.loadGame(fileName: "GameScene")
        }
        
        mainMenuButton = self.childNode(withName: "mainMenuButton") as! MSButtonNode
        //Main Menu selected handler
        mainMenuButton.selectedHandler = { [unowned self] in
            self.loadGame(fileName: "MainMenu")
        }
        settingsButtonNode = self.childNode(withName: "settingsButton") as! MSButtonNode
        
        //User defaults
        //Set the points to the labels
        scoreLabel.text = "score: \(score)"
        
        highscore = userDefault.integer(forKey: "highscore")
        highscoreLabel.text = "highscore: \(highscore)"
        
        //Set the text for the feel text
        if self.score > 10 {
            print("good try")
            feelText.text = "good try"
        } else if self.score < 3 {
            print("get them next time")
            feelText.fontSize = 25
            feelText.text = "get em' next time"
        }
        //Check highscore
        if highscore > prevHighscore {
            print("we have a new highscore")
            feelText.text = "new highscore"
            if score > prevHighscore + 20 {
                feelText.text = "godlike!!!"
            }
        } else if score > highscore - 3 {
            print("so close")
            feelText.text = "so close"
        }
        prevScore = userDefault.integer(forKey: "prevScore")
        prevScoreLabel.text = "previous score: \(prevScore)"
        
        //Saving NSUserDefaults for prevScore
        prevScore = score
        userDefault.set(prevScore, forKey: "prevScore")
        
        //Start the feelText animation
        feelText.xScale = 2
        feelText.yScale = 2
        
        //Update the prevHighscore
        if highscore > prevHighscore {
            userDefault.set(highscore, forKey: "prevHigh")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        animateFeelText()
    }
    
    func animateFeelText() {
        feelText.isHidden = false
        if feelText.xScale > 1 {
            feelText.xScale -= 0.1
            feelText.yScale -= 0.1
        }
    }
    
    func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
        
        // Determine the font scaling factor that should let the label text fit in the given rectangle.
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
        
        // Change the fontSize.
        labelNode.fontSize *= scalingFactor
        
        // Optionally move the SKLabelNode to the center of the rectangle.
        labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
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
