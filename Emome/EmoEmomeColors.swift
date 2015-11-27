//
//  EmoEmomeColors.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/1/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import SwiftColors

extension UIColor {
    class func emomeThemeColor() -> UIColor {
        return UIColor(hexString: "#55B7D1")!
    }
    
    class func colorForActivity(activity: EMOActivityType) -> UIColor {
        switch activity {
        case .Spotify:
            return UIColor(hexString: "#00D969")!
        case .Yelp:
            return UIColor(hexString: "#C41200")!
        }
    }
    
    class func colorForEmotion(emotion: EMOEmotion) -> UIColor {
        switch emotion {
        case .Sad: return UIColor(hexString: "#4179A4")!
        case .Frustrated: return UIColor(hexString: "#8B6B9E")!
        case .Anger: return UIColor(hexString: "#C55260")!
        case .Anxious: return UIColor(hexString: "#D3AA67")!
        }
    }
}
