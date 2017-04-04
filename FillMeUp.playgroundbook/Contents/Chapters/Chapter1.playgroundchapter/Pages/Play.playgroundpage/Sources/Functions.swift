//
//  Functions.swift
//
//  Created by Antonio Antonino on 29/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import PlaygroundSupport

//The book cannot be completed if the image has not been previously set
public func completeBook() {
    if PlaygroundKeyValueStore.current[Constants.imageToFilterKey] != nil {
        PlaygroundPage.current.assessmentStatus = .pass(message: "And that's all for this book! What you have explored, is just a very small part of the CoreImage framework, which offers many more tools to perform many more operations on both still photos and videos. If you like to make something amazing and original on your own, probably [the Apple reference guide](https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html#//apple_ref/doc/uid/TP30001185-CH1-TPXREF101) is the place where you may want to get started.")
    } else {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Oooops, it seems like the image has not been set in the previous page 😐. Please go back and select an image to use with the filters."], solution: nil)
    }
}
