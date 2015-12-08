//
//  EMOEnums.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/16/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation

enum EMOActivityType {
    case Spotify
    case Yelp
    case Other
    
    var actionTitle: String {
        switch self {
        case .Spotify:
            return "Listen on Spotify"
        case .Yelp:
            return "View on Yelp"
        case .Other:
            return ""
        }
    }
}

enum EMOEmotion: CustomStringConvertible {
    case Sad
    case Frustrated
    case Angry
    case Anxious
    
    static let allValues = [Sad, Frustrated, Angry, Anxious]
    
    var description: String {
        switch self {
        case .Sad:
            return "sad"
        case .Frustrated:
            return "frustrated"
        case .Angry:
            return "angry"
        case .Anxious:
            return "anxious"
        }
    }
}