//
//  EMODataManager.swift
//  Emome
//
//  Created by Huai-Che Lu on 10/27/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation

class EMODataManager {
    static var sharedInstance = EMODataManager()
    
    var sadnessValue: Float = 0.0
    var frustrationValue: Float = 0.0
    var angerValue: Float = 0.0
    var fearValue: Float = 0.0
    
    var scenario: String = ""
}