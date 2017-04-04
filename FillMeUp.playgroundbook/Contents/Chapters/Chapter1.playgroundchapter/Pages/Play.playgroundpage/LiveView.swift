//
//  LiveView.swift
//
//  Created by Antonio Antonino on 28/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import PlaygroundSupport
import UIKit
import Foundation

let imageToShow: UIImage

if let dataStored = PlaygroundKeyValueStore.current[Constants.imageToFilterKey], case .data(let imageData) = dataStored, let imageToFilter = UIImage(data: imageData), let rotatedImage = imageToFilter.normalized {
    imageToShow = rotatedImage
} else {
    imageToShow = UIImage(named: "no_image_selected.PNG")!
}

PlaygroundPage.current.liveView = ImageEditViewController(image: imageToShow)
