//
//  PanDirectionGestureRecognizer.swift
//
//  Created by Antonio Antonino on 23/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit.UIGestureRecognizerSubclass

//Custom UIPanGestureRecognizer able to only recognize vertical or horizontal pan gestures
class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    private let direction: Direction
    
    init(panDirection direction: Direction, target: Any?, action: Selector?) {
        self.direction = direction
        
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if self.state == .began {
            let velocity = self.velocity(in: self.view)
            
            switch self.direction {
            case .horizontal where fabs(velocity.y) > fabs(velocity.x), .vertical where fabs(velocity.x) > fabs(velocity.y):
                self.state = .cancelled
            default:
                break
            }
        }
    }
}
