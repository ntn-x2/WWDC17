//#-hidden-code
//
//  Contents.swift
//
//  Created by Antonio Antonino on 28/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//
//#-end-hidden-code

/*:
 Here we are! We have our image set and ready to be edited in many funny ways, but there is still one thing we are missing... **the filter**!
 
 Choose the filter you want to test out, then have fun applying the filter to the picture you chose. Pan, pinch, rotate and tap to adjust the filter parameters and get the funniest effect you can.
 
 
 Try with one of the following filters:
 * ImageFilterType.*blackHoleDistortion*
 * ImageFilterType.*bumpDistortion*
 * ImageFilterType.*bumpDistortionLinear*
 * ImageFilterType.*circleSplashDistortion*
 * ImageFilterType.*pinchDistortion*
 * ImageFilterType.*twirlDistortion*
 
 
 *To maximize the pleasure, expand the view where the image is displayed to cover the entire screen, and enjoy!*
 
 If you want to change the image you're working on, just return to the previous page, select a new image, re-run that code and then come back here: CoreImage will still be waiting for you 😀.
 
 */


//#-code-completion(everything, show)
let filterToApply: ImageFilterType = <#T##filterType##ImageFilterType#>


/*:
 Whenever you are done playing around with these filters, uncomment the following line of code and re-run the code of this page to get this page and, hopefully, the entire book completed !
 
 Bye Bye! 👋🏽👋🏻👋🏿👋🏼👋🏾👋
 */
//completeBook()

//#-hidden-code
import PlaygroundSupport
import UIKit

let currentPage = PlaygroundPage.current

if let dataStored = PlaygroundKeyValueStore.current[Constants.imageToFilterKey] {
    if let proxy = currentPage.liveView as? PlaygroundRemoteLiveViewProxy {
        let message: PlaygroundValue = .string(filterToApply.rawValue)
        proxy.send(message)
        HintProvider.showHint(forFilterType: filterToApply)
    }
} else {
    currentPage.assessmentStatus = .fail(hints: ["Oooops, it seems like the image has not been set in the previous page 😐. Please go back and select an image to use with the filters."], solution: nil)
}
//#-end-hidden-code
