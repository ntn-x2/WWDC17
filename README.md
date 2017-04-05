# WWDC17
FillMeUp, WWDC17 playgroundbook

## Main idea

FillMeUp has been designed with the main goal of showing people with a bit of programming knowledge, some basic functionalities that CoreImage framework allows to implement.

After some brainstorming, I came to the conclusion that photo editing apps are among the most engaging from users’ perspective, hence I tried to focus on a product that could help them to understand how that is achievable. Testing after development strengthened the idea that the playground was engaging and visually interactive.

Using many of the features that the new playground book offers, I implemented a three-page book that introduces users to the world of photo editing, by explaining which Apple technologies allow to do it and providing further references for the most curious and interested.

My initial idea was to implement a playground which used the same distortion filters as the final one, but applied to real-time camera frames captured using AVFoundation framework, without the requirement of having to choose a picture. Then I found that a bug in playground does not allow to access camera directly, so my plans got slightly changed.

## Implementation

The first page is an introductory page that explains what the book’s main topic is, while showing in the live view some funny images edited using the same tools available in the last page.
The second page is a setup page which uses the built-in function of playgrounds that allows users to choose an image from the gallery or the camera. This is achievable by adding a typed placeholder token and specifying UIImage as the type parameter: with this solution I bypassed the bug preventing the direct use of the camera.
The third and last page is the actual interactive one. Based on the image selected in the previous page and stored into the playground key-value store, it gives the user the possibility to choose a distortion filter from the six available and, once the code is run, to start playing around with that in the live view by directly pinching, panning, rotating and tapping the image to change the parameters, and shaking to reset.
The filters have been implemented with an enum wrapped around some of the filters available in the CIFilter class: this made also easier to provide the correct suggestions to the users when they have to type the filter they want, since CIFilter class still uses strings to specify the name of the filter. That would have been harder and more confusing for the final users.
The live view contains a custom UIImageView that listens for some gestures to occur and than delegates the handling of those gestures to its delegate, which is the view controller in which the view is inserted.
