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
    let title: String
    let description: String
    let message: String
    let activityType: EMOActivityType
    let url: NSURL?
    let featureImageUrlString: String
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKey("suggestion_id") as! String
        self.message = representation.valueForKey("message") as! String
        let contentDict = representation.valueForKey("content") as! [String: AnyObject]
        switch contentDict["type"] as! String {
        case "Yelp":
            self.activityType = .Yelp
        case "Spotify":
            self.activityType = .Spotify
        default:
            self.activityType = .Other
        }
        
        let dataDict = contentDict["data"] as! [String: String]
        
        self.title = dataDict["track_name"]!
        self.description = dataDict["artist"]!
        
        var uriString = dataDict["url"]!
        uriString = uriString.substringToIndex(uriString.endIndex.predecessor())
        
        self.url =  NSURL(string: "spotify://\(uriString)")
        let coverImageUrlString = dataDict["cover_img_url"]!
        self.featureImageUrlString = coverImageUrlString
        
//        self.url = dataDict["data"] as! String)
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [EMOSuggestion] {
        var suggestions: [EMOSuggestion] = []
        
        log.debug("Before parsing: \(representation)")
        
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