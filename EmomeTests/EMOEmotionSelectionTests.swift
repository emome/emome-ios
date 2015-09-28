//
//  EMOSelectEmotionTests.swift
//  Emome
//
//  Created by Huai-Che Lu on 9/28/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import XCTest
@testable import Emome

class EMOSelectEmotionTests: XCTestCase {
    
    let emotionSelectionViewController = EMOEmotionSelectionViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEmotions() {
        let emotionCount = 5
        XCTAssertEqual(emotionSelectionViewController.emotions.count, emotionCount)
    }
    
}
