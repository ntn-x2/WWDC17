//
//  UIImage+Extensions.swift
//
//  Created by Antonio Antonino on 20/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    //Returns a scaled image of the original one, fitting the size passed
    public func scaling(toSize newSize: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //Returns an image which orientation is up
    public var normalized: UIImage? {
        guard self.imageOrientation != .up else {
            if let imageData = UIImageJPEGRepresentation(self, 1.0) {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
