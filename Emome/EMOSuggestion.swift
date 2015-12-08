//
//  EMOSuggestion.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/16/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation
import Alamofire

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Alamofire.Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value.valueForKey("data")!))
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

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
    
    
//    class func suggestionFromDictionary(dictionary: NSDictionary) -> EMOSuggestion {
//        
//        
//        // Create Suggestion instances and append them to returning array
//        
//        return suggestion
//    }
}