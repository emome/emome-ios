//
//  EMOHomeActionButton.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/27/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import QuartzCore

class EMOHomeActionButton: UIButton {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 2.0 + self.bounds.height / 2.0
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
