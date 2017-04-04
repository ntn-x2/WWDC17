//
//  FilteredImageView.swift
//
//  Created by Antonio Antonino on 22/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

//Delegate for handling recognized gestures
@objc protocol FilteredImageViewDelegate: class {
    @objc optional func didReceivePanGesture(_ gesture: UIPanGestureRecognizer)
    @objc optional func didReceiveVerticalPanGesture(_ gesture: UIPanGestureRecognizer)
    @objc optional func didReceivePinchGesture(_ gesture: UIPinchGestureRecognizer)
    @objc optional func didReceiveRotationGesture(_ gesture: UIRotationGestureRecognizer)
    @objc optional func didReceiveTapGesture(_ gesture: UITapGestureRecognizer)
}

//Delegate for handling debug in the on-the-screen console
@objc protocol DebugDelegate: class {
    @objc optional func log(message: String)
}

class FilteredImageView: UIImageView {
    
    //MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, image: UIImage? = nil) {
        super.init(frame: frame)
        self.configure(image: image)
    }
    
    private func configure(image: UIImage? = nil) {
        self.originalImage = image
        
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.showingFilteredImage = false
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:))))
        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(onPinch(_:))))
        self.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(onRotate(_:))))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
        
        let verticalPanGestureRecognizer = PanDirectionGestureRecognizer(panDirection: .vertical, target: self, action: #selector(onVerticalPan(_:)))
        verticalPanGestureRecognizer.exactNumberOfTouchesRequired = 2
        self.addGestureRecognizer(verticalPanGestureRecognizer)
        
        let moveCenterPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        moveCenterPanGestureRecognizer.exactNumberOfTouchesRequired = 1
        self.addGestureRecognizer(moveCenterPanGestureRecognizer)
    }
    
    //MARK: - Gestures delegate
    
    weak var delegate: FilteredImageViewDelegate?
    
    
    //MARK: - Debug delegate
    
    weak var debugDelegate: DebugDelegate?
    
    
    //MARK: - CoreImage elements
    
    private var imageOriginalSize: CGSize?          // The original size of the image set in the ImageView (to force filtered images to take exactly the same amount of space)
    private let context: CIContext = {
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            return CIContext(mtlDevice: metalDevice)
        } else if let eaglContext = EAGLContext(api: .openGLES3) {
            return CIContext(eaglContext: eaglContext)
        } else {
            return CIContext()
        }
    }()
    
    
    //MARK: - Properties
    
    //Modify the image property switching between the two states so that the image view can redraw itself with the proper image to show
    var showingFilteredImage: Bool = false {
        didSet {
            self.image = self.showingFilteredImage ? self.filteredUIImage : self.originalImage
        }
    }
    
    //The original, unfiltered image (set during creation time)
    var originalImage: UIImage? {
        didSet {
            if let newImage = self.originalImage {
                self.imageOriginalSize = newImage.size
                self.showingFilteredImage = false
            }
        }
    }
    
    //The filtered image, in the CIImage format
    var filteredImage: CIImage? {
        didSet {
            if let image = self.filteredImage, let originalImageSize = self.imageOriginalSize {
                let cgImage = self.context.createCGImage(image, from: CGRect(origin: .zero, size: originalImageSize))!
                self.filteredUIImage = UIImage(cgImage: cgImage)
                self.showingFilteredImage = true
            }
        }
    }
    
    //The UIKit representation of the filtered CIImage
    private var filteredUIImage: UIImage?
    
    
    //MARK: - Conversions
    
    var scaleFactor: CGFloat? {
        guard let filteredImage = self.filteredUIImage, let imageFrame = self.imageFrame else {
            return nil
        }
        
        return filteredImage.size.width / (imageFrame.maxX - imageFrame.minX)
    }
    
    func convertPoint(_ point: CGPoint) -> CIVector {
        
        let newX = (point.x - self.imageFrame!.origin.x) * self.scaleFactor!
        let newY = (point.y - self.imageFrame!.origin.y) * self.scaleFactor!
        
        return CIVector(x: newX, y: newY)
    }
    
    func convertVector(_ vector: CIVector) -> CGPoint {
        
        let newX = (vector.x / self.scaleFactor!) + self.imageFrame!.origin.x
        let newY = (vector.y / self.scaleFactor!) + self.imageFrame!.origin.y
        
        return CGPoint(x: newX, y: newY)
    }
    
    //Returns the correctly scaled size from a size in CIFilter
    func convertFromFilter(_ size: NSNumber) -> CGFloat {
        return CGFloat(size.floatValue) / self.scaleFactor!
    }
    
    //Returns the correctly scaled size from a size in the UIImageView reference system
    func convertFromFrame(_ size: CGFloat) -> NSNumber {
        return NSNumber(value: Float(size * self.scaleFactor!))
    }
    
    
    //MARK: - Gesture recognizers handlers
    
    @objc private func onLongPress(_ recognizer: UILongPressGestureRecognizer) {    //Shows the original image until the finger is raised
        switch recognizer.state {
        case .began:
            self.showingFilteredImage = false
        case .cancelled, .ended, .failed:
            self.showingFilteredImage = true
        default:
            break
        }
    }
    
    @objc private func onPan(_ recognizer: UIPanGestureRecognizer) {
        if self.showingFilteredImage {
            self.delegate?.didReceivePanGesture?(recognizer)
        }
    }
    
    @objc private func onPinch(_ recognizer: UIPinchGestureRecognizer) {
        if self.showingFilteredImage {
            self.delegate?.didReceivePinchGesture?(recognizer)
        }
    }
    
    @objc private func onRotate(_ recognizer: UIRotationGestureRecognizer) {
        if self.showingFilteredImage {
            self.delegate?.didReceiveRotationGesture?(recognizer)
        }
    }
    
    @objc private func onVerticalPan(_ recognizer: UIPanGestureRecognizer) {
        if self.showingFilteredImage {
            self.delegate?.didReceiveVerticalPanGesture?(recognizer)
        }
    }
    
    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        if self.showingFilteredImage {
            self.delegate?.didReceiveTapGesture?(recognizer)
        }
    }
}
