//
//  PhotosCollectionViewController.swift
//
//  Created by Antonio Antonino on 26/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit

//View controller that shows, at fixed interval rates, a random image taken from an array of images
public class PhotosCollectionViewController: UIViewController {
    
    private var imageView: UIImageView!
    
    private let photos: [UIImage]                   //The collection of photos from which to take the random ones
    private let updateInterval: TimeInterval        //The frequency of the update
    private let options: UIViewAnimationOptions     //The type of update animation
    
    private var viewAppeared = false
    
    public init(photos: [UIImage], updateInterval: TimeInterval, options: UIViewAnimationOptions) {
        self.photos = photos
        self.updateInterval = updateInterval
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.viewAppeared {
            self.configureUI()
            self.startShowingCollection()
            self.viewAppeared = true
        }
    }
    
    private func configureUI() {
        //UIImageView configuration
        self.imageView = UIImageView(frame: self.view.frame)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(self.imageView)
    }
    
    public func startShowingCollection() {
        self.setRandomImage()
        Timer.scheduledTimer(withTimeInterval: self.updateInterval, repeats: true, block: { [weak self] _ in
            self?.setRandomImage()
        })
    }
    
    private func setRandomImage() {
        let randomImageIndex = Int(arc4random_uniform(UInt32(self.photos.count)))
        UIView.transition(with: self.imageView, duration: self.updateInterval, options: self.options, animations: {
            self.imageView.image = self.photos[randomImageIndex]
        }, completion: nil)
    }
}
