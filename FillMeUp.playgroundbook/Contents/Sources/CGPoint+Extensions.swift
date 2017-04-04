//
//  CGPoint+Extensions.swift
//
//  Created by Antonio Antonino on 19/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGPoint {
    
    public func distanceFrom(_ point: CGPoint) -> Double {
        return sqrt(Double(pow(point.x - self.x, 2)) + Double(pow(point.y - self.y, 2)))
    }
    
    public func isInCircle(withCenter center: CGPoint, andRadius radius: CGFloat, boundValid: Bool) -> Bool {
        let op: (CGFloat, CGFloat) -> Bool
        if boundValid {
            op = (<=)
        } else {
            op = (<)
        }
        return op(pow((self.x - center.x), 2) + pow((self.y - center.y), 2), pow(radius, 2))
    }
}
