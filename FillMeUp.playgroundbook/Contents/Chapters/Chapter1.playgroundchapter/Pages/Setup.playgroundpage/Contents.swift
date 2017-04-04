//#-hidden-code
//
//  Contents.swift
//
//  Created by Antonio Antonino on 28/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//
//#-end-hidden-code
//#-hidden-code
import UIKit
import PlaygroundSupport
//#-end-hidden-code
/*:
 ## What is CoreImage?
 [Core Image](https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html#//apple_ref/doc/uid/TP30001185-CH1-TPXREF101) is a framework produced by Apple and has a lot of cool and very useful features for dealing with image editing, filtering and processing.
 Among all the features, CoreImage allows *auto-enhancement* for images, *detection of faces* in an image or video, and provides several [filters](https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/) to *modify colors*, *distort* a picture or *adjust geometries* of an image.




 Here we are going to see just a small subset of filters that CoreImage provides, but in order to test them out, CoreImage needs a photo to operate. So **select a picture you want to play with, then make sure to run the code at least once**, otherwise you won't be able to test out filters in the next page.

 
 You can come back later to this page if you wish to change the picture.
 
 A suggestion: *a picture of a person or an animal will be way more funny 😄!*
 */

let imageToFilter = /*#-editable-code*/<#T##image##UIImage#>/*#-end-editable-code*/


//#-hidden-code
if let imageToStore = UIImageJPEGRepresentation(imageToFilter, 1.0) {
    PlaygroundKeyValueStore.current[Constants.imageToFilterKey] = .data(imageToStore)
    PlaygroundPage.current.assessmentStatus = .pass(message: "Cool! Now that you have choosen your image, let's see CoreImage in action in the [**last page**](@next) 😉!")
} else {
    PlaygroundPage.current.assessmentStatus = .fail(hints: ["Be sure to select a valid `UIImage` from the popup menu"], solution: nil)
}
//#-end-hidden-code
