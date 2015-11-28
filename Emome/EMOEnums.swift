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
    
    var actionTitle: String {
        switch self {
        case .Spotify:
            return "Listen on Spotify"
        case .Yelp:
            return "View on Yelp"
        }
    }
}

enum EMOEmotion: CustomStringConvertible {
    case Sad
    case Frustrated
    case Angery
    case Anxious
    
    static let allValues = [Sad, Frustrated, Angery, Anxious]
    
    var description: String {
        switch self {
        case .Sad:
            return "sad"
        case .Frustrated:
            return "frustrated"
        case .Angery:
            return "angery"
        case .Anxious:
            return "anxious"
        }
    }
}