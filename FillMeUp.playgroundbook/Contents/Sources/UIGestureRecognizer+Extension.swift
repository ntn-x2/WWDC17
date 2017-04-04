//
//  UIGestureRecognizer+Extensions.swift
//
//  Created by Antonio Antonino on 25/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit

public extension UIPanGestureRecognizer {
    
    //Shortcut to directly set an exact number of touches required to trigger the gesture
    public var exactNumberOfTouchesRequired: Int {
        set {
            self.minimumNumberOfTouches = newValue
            self.maximumNumberOfTouches = newValue
        }
        
        get {
            return self.minimumNumberOfTouches
        }
    }
}
