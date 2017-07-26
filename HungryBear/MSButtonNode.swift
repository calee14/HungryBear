//
//  MSButtonNode.swift
//  HoppyBunny
//
//  Created by Martin Walsh on 20/02/2016.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum MSButtonNodeState {
    case Active, Selected, Hidden
}

class MSButtonNode: SKSpriteNode {
    
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    var isDisabled: Bool = false
    var originxScale: CGFloat = 1
    var originyScale: CGFloat = 1
    var touchPoint = CGPoint()
    
    /* Button state management */
    var state: MSButtonNodeState = .Active {
        didSet {
            switch state {
            case .Active:
                /* Enable touch */
                self.isUserInteractionEnabled = true
                self.xScale = self.originxScale
                self.yScale = self.originyScale
                
                /* Visible */
                self.alpha = 1
                break;
            case .Selected:
                /* Semi transparent */
                self.alpha = 0.7
                self.xScale = self.originxScale * CGFloat(0.7)
                self.yScale = self.originyScale * CGFloat(0.7)
                
                break;
            case .Hidden:
                /* Disable touch */
                self.isUserInteractionEnabled = false
                
                /* Hide */
                self.alpha = 0
                break;
            }
        }
    }
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.isUserInteractionEnabled = true
        
        originxScale = self.xScale
        originyScale = self.yScale
        
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDisabled { return }
        
        let touch = touches.first!
        let location = touch.location(in: self)
        touchPoint = location
        
        //Reset the scale to origin scale
        self.xScale = originxScale
        self.yScale = originyScale
        
        state = .Selected
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        print("location \(location)")
        print("start Point \(touchPoint)")
        if abs(location.x - touchPoint.x) > self.size.width * 2 || abs(location.y - touchPoint.y) > self.size.height * 2{
            state = .Active
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDisabled { return }
        if state != .Selected { return }
        selectedHandler()
        state = .Active
    }
    
}
