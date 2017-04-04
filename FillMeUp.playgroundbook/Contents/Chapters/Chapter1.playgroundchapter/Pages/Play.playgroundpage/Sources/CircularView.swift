//
//  CircularView.swift
//
//  Created by Antonio Antonino on 21/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import Foundation
import UIKit

//A circular view inscribed in the specified frame rect
class CircularView: UIView {
    
    private let shapeLayer: CAShapeLayer
    
    weak var debugDelegate: DebugDelegate?
    
    //Returns the radius of the view
    var radius: CGFloat {
        return self.bounds.width / 2
    }
    
    init(frame: CGRect, fillColor: UIColor, strokeColor: UIColor, borderWidth: CGFloat) {
        self.shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.borderWidth = borderWidth
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.contentMode = .redraw          //Automatically calls the draw(_:) method when changing its frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.debugDelegate?.log?(message: "Circular view - Draw: \(rect)")
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        self.shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
    }
}

