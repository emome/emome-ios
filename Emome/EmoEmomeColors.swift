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
    class func emomeHighlightColor() -> UIColor {
        return UIColor(hexString: "#55B7D1")!
    }
    
    class func emomeBackgroundColor() -> UIColor {
        return UIColor(hexString: "#E5E5DE")!
    }
    
    class func emomeGrayColor() -> UIColor {
        return UIColor(hexString: "#9D9D9A")!
    }
    
    class func emomeTextGrayColor() -> UIColor {
        return UIColor(hexString: "#656565")!
    }
    
    class func colorForActivity(activity: EMOActivityType) -> UIColor {
        switch activity {
        case .Spotify:
            return UIColor(hexString: "#00D969")!
        case .Yelp:
            return UIColor(hexString: "#C41200")!
        case .Other:
            return UIColor.clearColor()
        }
    }
    
    class func colorForEmotion(emotion: EMOEmotion) -> UIColor {
        switch emotion {
        case .Sad: return UIColor(hexString: "#4179A4")!
        case .Frustrated: return UIColor(hexString: "#8B6B9E")!
        case .Angry: return UIColor(hexString: "#C55260")!
        case .Anxious: return UIColor(hexString: "#D3AA67")!
        }
    }
}
