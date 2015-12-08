//
//  EMODataManagerTests.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/8/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import XCTest
@testable import Emome

class EMODataManagerTests: XCTestCase {
    
    let dataManager = EMODataManager.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNormalizeEmotionMeasurement() {
        
        var normalized = dataManager.normalizeEmotionMeasurement([EMOEmotion: Double]())
        
        for e in EMOEmotion.allValues {
            XCTAssertNotNil(normalized["\(e)"])
            XCTAssert(normalized["\(e)"] == 00)
        }
        
        let rawEmotion: [EMOEmotion: Double] = [.Sad: 4.2, .Frustrated: 3.2, .Angry: 0.4, .Anxious:5.2]
        normalized = dataManager.normalizeEmotionMeasurement(rawEmotion)

        XCTAssertNotNil(normalized["\(EMOEmotion.Sad)"])
        XCTAssertEqual(normalized["\(EMOEmotion.Sad)"], 8)
        XCTAssertNotNil(normalized["\(EMOEmotion.Frustrated)"])
        XCTAssertEqual(normalized["\(EMOEmotion.Frustrated)"], 6)
        XCTAssertNotNil(normalized["\(EMOEmotion.Angry)"])
        XCTAssertEqual(normalized["\(EMOEmotion.Angry)"], 1)
        XCTAssertNotNil(normalized["\(EMOEmotion.Anxious)"])
        XCTAssertEqual(normalized["\(EMOEmotion.Anxious)"], 10)
        
        
    }

}
