//
//  EMOScenario.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/7/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation
import Alamofire


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
