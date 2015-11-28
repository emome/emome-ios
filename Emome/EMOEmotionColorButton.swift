//
//  EMOEmotionColorButton.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/27/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import QuartzCore

class EMOEmotionColorButton: UIButton {
    
    var circleLayer: CAShapeLayer!
    var selectionLayer: CAShapeLayer!
    var colorLayerRadius: CGFloat = 22.0
    var emotionColor: UIColor! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.setTitleColor(UIColor.emomeHighlightColor(), forState: .Selected)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override var selected: Bool {
        
        didSet {
            if self.selected {
                self.selectionLayer.opacity = 1.0
            } else {
                self.selectionLayer.opacity = 0.0
            }
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        
        if self.circleLayer == nil {
            self.circleLayer = CAShapeLayer()
            self.circleLayer.bounds = CGRectMake(0.0, 0.0, self.colorLayerRadius * 2, self.colorLayerRadius * 2)
            self.circleLayer.position = CGPointMake(rect.size.width / 2, 14.0 + self.colorLayerRadius)
            self.circleLayer.cornerRadius = self.colorLayerRadius
            self.circleLayer.backgroundColor = self.emotionColor.CGColor
            
            self.layer.addSublayer(self.circleLayer)
        }
        
        if  self.selectionLayer == nil {
            self.selectionLayer = CAShapeLayer()
            let path = UIBezierPath.init(arcCenter: CGPointMake(rect.size.width / 2, 14.0 + self.colorLayerRadius), radius: self.colorLayerRadius, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2.0, clockwise: true)
            self.selectionLayer.path = path.CGPath
            self.selectionLayer.fillColor = nil
            self.selectionLayer.lineWidth = 2.0
            self.selectionLayer.strokeColor = UIColor.whiteColor().CGColor
            self.selectionLayer.opacity = 0.0
            
            self.layer.addSublayer(self.selectionLayer)
        }
    }

}
