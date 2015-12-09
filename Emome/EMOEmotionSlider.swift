//
//  EMOEmotionSlider.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/8/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOEmotionSlider: UISlider {

    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        let defaultRect = super.trackRectForBounds(bounds)
        
        let thickness:CGFloat = 5.0
        let origin = CGPointMake(defaultRect.origin.x, defaultRect.origin.y)
        let size = CGSizeMake(defaultRect.size.width, thickness)
        
        
        return CGRect(origin: origin, size: size)
    }

}
