//
//  ImageEditViewController.swift
//
//  Created by Antonio Antonino on 20/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import UIKit
import PlaygroundSupport

//Controller responsible of handling the interaction between the user and the imageview showing the filtered image
public class ImageEditViewController: UIViewController {
    
    //MARK: - Filter scale factors
    
    //Constants to normalize the rate at which the filter properties get changes by the gestures. Higher values slow down the increase speed of the respective properties
    fileprivate static let radiusIncreaseRateFactor: Float = 70
    fileprivate static let scaleIncreaseRateFactor: CGFloat = 100
    
    //Additional space that would let a gesture to be recognized even if it does not happen strictly inside the existing effect circumference
    fileprivate static let toleranceThreshold: CGFloat = 30
    
    
    //MARK: - Filter properties
    
    fileprivate var filteredImageView: FilteredImageView!
    fileprivate var initialFilterConfiguration: CIFilter?   //The initial configuration of the filter, so that the image can be correctly reset
    fileprivate var filter: CIFilter?                       //The filter applied to the image
    
    //Values saved everytime a gesture begins
    fileprivate var initialEffectCenter: CGPoint?
    fileprivate var initialEffectAngle: NSNumber?
    fileprivate var initialEffectScale: NSNumber?
    
    fileprivate var effectOverlay: CircularView?            //The circular overview to show when the user is not able to find where the filter is located
    
    
    //MARK: - Debug
    
    public var debugEnabled = false {
        didSet {
            if self.debugEnabled {
                self.view.addSubview(self.testConsole)
            } else {
                self.testConsole.removeFromSuperview()
            }
        }
    }
    
    fileprivate let testConsole: UITextView = {
        let label = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.isEditable = false
        label.isSelectable = false
        label.showsVerticalScrollIndicator = false
        
        return label
    }()
    
    @objc fileprivate func clearLog() {
        self.testConsole.text = ""
    }
    
    fileprivate func log(_ message: String) {
        if self.debugEnabled {
            print(message)
            self.testConsole.text = self.testConsole.text + message + "\n"
            let range = NSRange(location: self.testConsole.text.characters.count - 1, length: 1)
            self.testConsole.scrollRangeToVisible(range)
        }
    }
    
    
    //MARK: - Initializers
    
    public init(image: UIImage, filter: CIFilter? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.filter = filter
        self.configureUI(withImage: image)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let overlay = self.effectOverlay, overlay.superview != nil {
            self.removeEffectOverlay()
        }
    }
    
    fileprivate func configureUI(withImage image: UIImage) {
        //UIImageView configuration
        self.filteredImageView = FilteredImageView(frame: self.view.frame, image: image)
        self.filteredImageView.delegate = self
        self.filteredImageView.debugDelegate = self
        self.filteredImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.view.addSubview(self.filteredImageView)
        
        //DEBUG
        
        if (self.view.subviews.index(of: self.testConsole) ?? Int.max) < self.view.subviews.index(of: self.filteredImageView)! {
            self.testConsole.removeFromSuperview()
            self.view.addSubview(self.testConsole)
        }
        let testTapGetureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clearLog))
        testTapGetureRecognizer.numberOfTapsRequired = 2
        testTapGetureRecognizer.numberOfTouchesRequired = 2
        self.filteredImageView.addGestureRecognizer(testTapGetureRecognizer)
    }
    
    
    //MARK: - Image filtering
    
    public func setFilter(_ filter: CIFilter) {
        if let imageToFilter = self.filteredImageView.originalImage {
            filter.setImageToFilter(CIImage(image: imageToFilter)!)
            self.filteredImageView.filteredImage = filter.outputImage
        }
        //Saves the filte and its initial configuration, and removes any possible overlay. Then starts listening for shaking gestures
        self.filter = filter
        self.saveInitialFilter(fromFilter: filter)
        
        //Draw the effect overlay
        let effectCenterConverted = self.vectorCenterConverted(self.filter!.effectCenter!)
        let effectRadiusConverted = self.effectRadiusConverted(self.filter!.effectRadius!)
        self.addEffectOverlay(inRect: self.getEffectBoundingRect(center: effectCenterConverted, radius: effectRadiusConverted))
        
        self.becomeFirstResponder()
    }
    
    func modifyFilterParameter(_ paramName: String, withValue newValue: Any) {
        if let filter = self.filter {
            filter.modifyParameter(withKey: paramName, newValue: newValue)
            self.filteredImageView.filteredImage = filter.outputImage
        }
        self.removeEffectOverlay()
    }
    
    func resetImageView() {
        if let initialFilter = self.initialFilterConfiguration {
            self.filteredImageView.filteredImage = initialFilter.outputImage
            self.restoreInitialFilter()
        }
        self.removeEffectOverlay()
    }
    
    private func saveInitialFilter(fromFilter filter: CIFilter) {
        self.initialFilterConfiguration = (filter.copy() as! CIFilter)
    }
    
    private func restoreInitialFilter() {
        if let initialFilter = self.initialFilterConfiguration {
            self.filter = (initialFilter.copy() as! CIFilter)
        }
    }
    
    //Converts the value of the effect center into its own coordinate system
    fileprivate func vectorCenterConverted(_ center: CIVector) -> CGPoint {
        var vectorCenterConverted = self.filteredImageView.convertVector(center)
        vectorCenterConverted.y = self.filteredImageView.frame.maxY - vectorCenterConverted.y
        
        return vectorCenterConverted
    }
    
    //Converts the value of the effect radius into its own coordinate system
    fileprivate func effectRadiusConverted(_ radius: NSNumber?) -> CGFloat {
        let radiusValueConverted: CGFloat
        if let effectRadius = radius {
            radiusValueConverted = self.filteredImageView.convertFromFilter(effectRadius)
        } else {
            radiusValueConverted = 0
        }
        
        return radiusValueConverted
    }
    
    fileprivate func getEffectBoundingRect(center: CGPoint, radius: CGFloat) -> CGRect {
        return CGRect(center: center, radius: (radius > 0) ? radius : ImageEditViewController.toleranceThreshold)
    }
    
    
    //MARK: - Effect overlay add/remove
    
    fileprivate func addEffectOverlay(inRect rect: CGRect) {
        self.removeEffectOverlay()
        
        if let existingOverlay = self.effectOverlay {
            existingOverlay.frame = rect
        } else {
            self.effectOverlay = CircularView(frame: rect, fillColor: UIColor.blue.withAlphaComponent(0.2), strokeColor: UIColor.blue.withAlphaComponent(0.5), borderWidth: 10)
            self.effectOverlay!.debugDelegate = self
        }
        self.filteredImageView.addSubview(self.effectOverlay!)
    }
    
    fileprivate func removeEffectOverlay() {
        self.effectOverlay?.removeFromSuperview()
    }
}

//MARK: - Motion gestures

extension ImageEditViewController {
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.log("Shake ended!")
            self.resetImageView()
            self.removeEffectOverlay()
        }
    }
}

//MARK: - FilteredImageViewDelegate

extension ImageEditViewController: FilteredImageViewDelegate {
    
    private func gestureSetupCode() {
        self.removeEffectOverlay()
    }
    
    func didReceivePanGesture(_ gesture: UIPanGestureRecognizer) {
        let gestureLocation = gesture.location(in: self.filteredImageView)
        
        guard let imageFrame = self.filteredImageView.imageFrame, imageFrame.contains(gestureLocation) else {
            return
        }
        
        //Gesture available only for filters that have a center parameter which can be changed
        if let effectCenter = self.filter!.effectCenter {
            switch gesture.state {
            case .began:
                self.gestureSetupCode()
                let effectCenterConverted = self.vectorCenterConverted(effectCenter)
                let effectRadiusConverted = self.effectRadiusConverted(self.filter!.effectRadius)
                
                guard gestureLocation.isInCircle(withCenter: effectCenterConverted, andRadius: effectRadiusConverted + ImageEditViewController.toleranceThreshold, boundValid: true) else {
                    gesture.state = .cancelled
                    
                    self.addEffectOverlay(inRect: self.getEffectBoundingRect(center: effectCenterConverted, radius: effectRadiusConverted))
                    
                    return
                }
                self.initialEffectCenter = self.filteredImageView.convertVector(effectCenter)
            case .changed:
                let effectCenter = self.initialEffectCenter!
                let gestureTraslation = gesture.translation(in: self.filteredImageView)
                let reversedGestureTraslation = CGPoint(x: gestureTraslation.x, y: -gestureTraslation.y)
                
                let newEffectCenterConverted = CGPoint(x: effectCenter.x + reversedGestureTraslation.x , y: effectCenter.y + reversedGestureTraslation.y)
                let newEffectCenter = self.filteredImageView.convertPoint(newEffectCenterConverted)
                
                self.modifyFilterParameter(kCIInputCenterKey, withValue: newEffectCenter)
            default:
                break
            }
        }
    }
    
    func didReceivePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        let gestureLocation = gesture.location(in: self.filteredImageView)
        
        guard let imageFrame = self.filteredImageView.imageFrame, imageFrame.contains(gestureLocation) else {
            return
        }
        
        //Gesture available only for filters that have a radius parameter which can be changed
        if let effectRadius = self.filter!.effectRadius {
            switch gesture.state {
            case .began:
                self.gestureSetupCode()
                if let effectCenter = self.filter!.effectCenter {
                    let effectCenterConverted = self.vectorCenterConverted(effectCenter)
                    let effectRadiusConverted = self.effectRadiusConverted(self.filter!.effectRadius)
                    
                    guard gestureLocation.isInCircle(withCenter: effectCenterConverted, andRadius: effectRadiusConverted + ImageEditViewController.toleranceThreshold, boundValid: true) else {
                        gesture.state = .cancelled
                        
                        self.addEffectOverlay(inRect: self.getEffectBoundingRect(center: effectCenterConverted, radius: effectRadiusConverted))
                        
                        return
                    }
                }
            case .changed:
                let deltaValue = Float(gesture.scale - 1)
                
                var radiusValueChanged = self.filteredImageView.convertFromFilter(effectRadius)
                radiusValueChanged += CGFloat(ImageEditViewController.radiusIncreaseRateFactor * deltaValue)
                let newRadiusValue = self.filteredImageView.convertFromFrame(radiusValueChanged)
                
                self.modifyFilterParameter(kCIInputRadiusKey, withValue: NSNumber(value: max(0, newRadiusValue.doubleValue)))   //Cannot set negative radius value
                gesture.scale = 1       //We reset the pinch scale everytime, since we consider everytime the relative offset compared to the previous event
            default:
                break
            }
        }
    }
    
    //Gesture available only for filters that have a scale parameter which can be changed
    func didReceiveVerticalPanGesture(_ gesture: UIPanGestureRecognizer) {
        let gestureLocation = gesture.location(in: self.filteredImageView)
        
        guard let imageFrame = self.filteredImageView.imageFrame, imageFrame.contains(gestureLocation) else {
            return
        }
        
        if let effectScale = self.filter!.effectScale {
            switch gesture.state {
            case .began:
                self.gestureSetupCode()
                self.initialEffectScale = effectScale
            case .changed:
                let gestureVerticalTraslation = gesture.translation(in: self.filteredImageView).y / ImageEditViewController.scaleIncreaseRateFactor
                //Negative since going up is negative in UIKit coordinates and positive in CoreImage coordinate (what we want)
                let newEffectScale = NSNumber(value: self.initialEffectScale!.floatValue + Float(-gestureVerticalTraslation))
                
                self.modifyFilterParameter(kCIInputScaleKey, withValue: newEffectScale)
            default:
                break
            }
        }
    }
    
    //Gesture available only for filters that have an angle parameter which can be changed
    func didReceiveRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        let gestureLocation = gesture.location(in: self.filteredImageView)
        
        guard let imageFrame = self.filteredImageView.imageFrame, imageFrame.contains(gestureLocation) else {
            return
        }
        
        //Gesture available only for filters that have an angle parameter which can be changed
        if let effectAngle = self.filter!.effectAngle {
            switch gesture.state {
            case .began:
                self.gestureSetupCode()
                self.initialEffectAngle = effectAngle
            case .changed:
                let newRotationValue = NSNumber(value: self.initialEffectAngle!.floatValue - Float(gesture.rotation))
                
                self.modifyFilterParameter(kCIInputAngleKey, withValue: newRotationValue)
            default:
                break
            }
        }
    }
    
    //If the overlay is nil or is not shown, show it. Otherwise hide it.
    func didReceiveTapGesture(_ gesture: UITapGestureRecognizer) {
        
        if let effectCenter = self.filter!.effectCenter, let effectRadius = self.filter!.effectRadius {
            let effectCenterConverted = self.vectorCenterConverted(effectCenter)
            let effectRadiusConverted = self.effectRadiusConverted(effectRadius)
            
            if self.effectOverlay == nil || self.effectOverlay!.superview == nil {
                self.addEffectOverlay(inRect: CGRect(center: effectCenterConverted, radius: effectRadiusConverted))
            } else {
                self.removeEffectOverlay()
            }
        }
    }
}

//MARK: - DebugDelegate

extension ImageEditViewController: DebugDelegate {
    func log(message: String) {
        self.log(message)
    }
}

//MARK: - PlaygroundLiveViewMessageHandler

extension ImageEditViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        if case let .string(filterName) = message {
            let filterToApply = CIFilter(name: filterName)!
            self.setFilter(filterToApply)
        }
    }
}
