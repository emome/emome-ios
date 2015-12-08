//
//  EMOSuggestion.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/16/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation

final class EMOSuggestion: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    let id: String
    let userId: String
    let title: String
    let category: String?
    let message: String
    let activityType: EMOActivityType
    let url: NSURL?
    
    init(id: String,
        userId: String,
        activityType: EMOActivityType,
        title: String,
        category: String,
        description: String,
        url: NSURL?) {
    
        self.id = id
        self.userId = userId
        self.activityType = activityType
        self.title = title
        self.category = category
        self.message = description
        self.url = url
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKey("suggestion_id") as! String
        self.message = representation.valueForKey("message") as! String
        self.title = "Sample Title"
        self.userId = ""
        self.category = ""
        self.url = nil
        let dataDict = representation.valueForKey("content") as! [String: AnyObject]
        switch dataDict["type"] as! String {
        case "Yelp":
            self.activityType = .Yelp
        case "Spotify":
            self.activityType = .Spotify
        default:
            self.activityType = .Other
        }
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [EMOSuggestion] {
        var suggestions: [EMOSuggestion] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for suggestionRepresentation in representation {
                if let suggestion = EMOSuggestion(response: response, representation: suggestionRepresentation) {
                    suggestions.append(suggestion)
                }
            }
        }
        return suggestions
    }
}