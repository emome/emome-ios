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