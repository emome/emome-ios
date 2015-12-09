//
//  EMOScenario.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/7/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation


struct EMOScenario: ResponseObjectSerializable, ResponseCollectionSerializable {
    let id: String
    let title: String
    
    init(withId id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let pair = representation as! [String: String]
        self.id = [String](pair.keys)[0]
        self.title = representation.valueForKeyPath(self.id) as! String
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [EMOScenario] {
        var scenarios: [EMOScenario] = []
        
        if let representation = representation as? [[String: String]] {
            for scenarioRepresenation in representation {
                if let scenario = EMOScenario(response: response, representation: scenarioRepresenation) {
                    scenarios.append(scenario)
                }
            }
        }
        
        return scenarios
    }
}
