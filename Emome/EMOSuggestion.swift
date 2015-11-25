//
//  EMOSuggestion.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/16/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation

class EMOSuggestion {
    
    let id: String
    let userId: String
    let title: String
    let category: String
    let description: String
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
        self.description = description
        self.url = url
    }
}