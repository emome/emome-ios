//
//  EMOSelectEmotionTests.swift
//  Emome
//
//  Created by Huai-Che Lu on 9/28/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import XCTest
@testable import Emome

class EMOEmotionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEMOEmotionCount() {
        XCTAssertEqual(EMOEmotion.allValues.count, 4)
    }
    
    func testEMOEmotionDescription() {
        for emotion in EMOEmotion.allValues {
            switch emotion {
            case .Sad:
                XCTAssertEqual("\(emotion)", "sad")
            case .Frustrated:
                XCTAssertEqual("\(emotion)", "frustrated")
            case .Angry:
                XCTAssertEqual("\(emotion)", "angry")
            case .Anxious:
                XCTAssertEqual("\(emotion)", "anxious")
            }
        }
    }
}
