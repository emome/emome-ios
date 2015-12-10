//
//  EMOUIViewUtils.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/9/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {
    
    func applyRoundCornerWithRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func applyShadow() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 4.0)
        self.layer.shadowOpacity = 0.5
    }
}
