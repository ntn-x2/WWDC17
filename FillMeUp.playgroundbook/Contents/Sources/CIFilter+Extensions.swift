//
//  CIFilter+Extensions.swift
//
//  Created by Antonio Antonino on 19/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

public extension CIFilter {
    
    public static let radiusIncreaseRateFactor: Float = 70
    
    public static let angleIncreaseRateFactor: Float = 10
    
    public static let toleranceThreshold: CGFloat = 30
    
    public static let scaleIncreaseRateFactor: CGFloat = 100
    
    public func setImageToFilter(_ image: CIImage) {
        self.setValue(image, forKey: kCIInputImageKey)
    }
    
    public func contains(_ key: String) -> Bool {
        return self.inputKeys.contains(key)
    }
    
    public func modifyParameter(withKey key: String, newValue: Any) {
        if self.contains(key) {
            self.setValue(newValue, forKey: key)
        }
    }

    public var effectCenter: CIVector? {
        guard self.contains(kCIInputCenterKey) else {
            return nil
        }
        return self.value(forKey: kCIInputCenterKey) as? CIVector
    }
    
    public var effectRadius: NSNumber? {
        guard self.contains(kCIInputRadiusKey) else {
            return nil
        }
        return self.value(forKey: kCIInputRadiusKey) as? NSNumber
    }
    
    public var effectAngle: NSNumber? {
        guard self.contains(kCIInputAngleKey) else {
            return nil
        }
        return self.value(forKey: kCIInputAngleKey) as? NSNumber
    }
    
    public var effectScale: NSNumber? {
        guard self.contains(kCIInputScaleKey) else {
            return nil
        }
        return self.value(forKey: kCIInputScaleKey) as? NSNumber
    }
}
