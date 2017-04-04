//
//  TemplateImageViewController.swift
//
//  Created by Antonio Antonino on 27/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit

//Controller used to show a specific image to the user.
public class TemplateImageViewController: UIViewController {
    
    private var imageView: UIImageView!
    
    private var viewAppeared = false
    
    public var image: UIImage? {
        get {
            return self.imageView?.image
        }
        set {
            if let newImage = newValue {
                self.imageView?.image = newImage
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.viewAppeared {
            self.configureUI()
            self.viewAppeared = true
        }
    }
    
    private func configureUI() {
        self.imageView = UIImageView(frame: self.view.frame)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        if let backgroundImage = UIImage(named: "wood_background.PNG") {
            self.imageView.image = backgroundImage
        } else {
            fatalError("There is no image called wood_backgrond.PNG. Please check the resources.")
        }
        
        self.view.addSubview(self.imageView)
    }
}
