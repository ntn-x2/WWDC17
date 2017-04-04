//
//  ImageFilterType.swift
//
//  Created by Antonio Antonino on 19/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import CoreImage

//Enum wrapped around some instances of CIFilter
public enum ImageFilterType: String {
    case blackHoleDistortion = "CIHoleDistortion"
    case bumpDistortion = "CIBumpDistortion"
    case bumpDistortionLinear = "CIBumpDistortionLinear"
    case circleSplashDistortion = "CICircleSplashDistortion"
    case pinchDistortion = "CIPinchDistortion"
    case twirlDistortion = "CITwirlDistortion"
    
    //Returns the collection containing all the filters implemented
    static var filtersCollection: Set<ImageFilterType> {
        let collection: Set<ImageFilterType> = [.blackHoleDistortion,
                                                .bumpDistortion,
                                                .bumpDistortionLinear,
                                                .circleSplashDistortion,
                                                .twirlDistortion]
        return collection
    }
    
    //Returns all the keys that a specific filter can accept as input
    public var availableKeys: Set<String> {
        var keys: Set<String> = [kCIInputCenterKey, kCIInputRadiusKey]
        switch self {
        case .bumpDistortion:
            keys.insert(kCIInputScaleKey)
        case .bumpDistortionLinear:
            keys.formUnion([kCIInputScaleKey, kCIInputAngleKey])
        case .pinchDistortion:
            keys.insert(kCIInputScaleKey)
        case .twirlDistortion:
            keys.insert(kCIInputAngleKey)
        default:
            break
        }
        return keys
    }
    
    //Returns the CIFilter associated
    public var imageFilter: CIFilter {
        return CIFilter(name: self.rawValue)!
    }
}

