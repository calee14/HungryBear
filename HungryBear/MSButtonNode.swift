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
    
    /* Button state management */
    var state: MSButtonNodeState = .Active {
        didSet {
            switch state {
            case .Active:
                /* Enable touch */
                self.isUserInteractionEnabled = true
                self.xScale /= CGFloat(0.7)
                self.yScale /= CGFloat(0.7)
                
                /* Visible */
                self.alpha = 1
                break;
            case .Selected:
                /* Semi transparent */
                self.alpha = 0.7
                self.xScale *= CGFloat(0.7)
                self.yScale *= CGFloat(0.7)
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
    }
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .Selected
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedHandler()
        state = .Active
    }
    
}
