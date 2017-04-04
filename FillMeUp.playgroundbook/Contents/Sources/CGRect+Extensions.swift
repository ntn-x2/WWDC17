//
//  CGRect+Extensions.swift
//
//  Created by Antonio Antonino on 21/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit

public extension CGRect {
    
    //Create a CGRect circumscribed to a circumference with given center and radius
    public init(center: CGPoint, radius: CGFloat) {
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        
        self.origin = origin
        self.size = CGSize(width: 2 * radius, height: 2 * radius)
    }
}
