//
//  EMOScenario.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/7/15.
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
                    return .Success(T.collection(response: response, representation: value))
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

struct EMOScenario{ //: ResponseObjectSerializable, ResponseCollectionSerializable {
    let id: String
    let title: String
    
    init(withId id: String, title: String) {
        self.id = id
        self.title = title
    }
    
//    init?(response: NSHTTPURLResponse, representation: AnyObject) {
//        self.id = response.
//        self.title = representation.valueForKeyPath("name") as! String
//    }
//    
//    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [EMOScenario] {
//        var scenarios: [EMOScenario] = []
//        
//        if let representation = representation as? [String: AnyObject] {
//            for scenarioId in representation {
//                if let scenario = EMOScenario(response: response, representation: [])
//                    User(response: response, representation: userRepresentation) {
//                    users.append(user)
//                }
//            }
//        }
//        
//        return users
//    }
}
