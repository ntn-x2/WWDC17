//
//  UIImageView+Extensions.swift
//
//  Created by Antonio Antonino on 20/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    //Returns the frame in which the image is drawn.
    public var imageFrame: CGRect? {
        if let image = self.image {
            let imageSize = image.size
            var resultFrame = CGRect.zero
            if imageSize.width < self.bounds.width && imageSize.height < self.bounds.height {
                resultFrame.size = imageSize
            } else {
                let widthRatio = imageSize.width / self.bounds.width
                let heightRatio = imageSize.height / self.bounds.height
                let maxRatio = max(widthRatio, heightRatio)
                resultFrame.size = CGSize(width: imageSize.width / maxRatio, height: imageSize.height / maxRatio)   //Scales the image keeping the aspect ratio unchanged
            }
            
            resultFrame.origin = CGPoint(x: self.center.x - resultFrame.size.width / 2, y: self.center.y - resultFrame.size.height / 2)
            return resultFrame.size == .zero ? nil : resultFrame
        }
        return nil
    }
}
