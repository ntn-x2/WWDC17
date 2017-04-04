//
//  CGFloat+Extensions.swift
//
//  Created by Antonio Antonino on 19/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    private static let arc4randomMax = CGFloat(UInt32.max)
    
    //Return a CGFLoat in the range [0, 1]
    public static func random0to1() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat.arc4randomMax
    }
}
