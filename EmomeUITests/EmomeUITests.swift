//
//  EmomeUITests.swift
//  EmomeUITests
//
//  Created by Huai-Che Lu on 9/28/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import XCTest

class EmomeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeScreenUIComponents() {
        
        let app = XCUIApplication()
        
        XCTAssert(app.buttons["express"].exists)
        XCTAssert(app.buttons["suggest"].exists)
        XCTAssert(app.buttons["me"].exists)
    }
    
    func testColorSplashUIComponents() {
        
        let app = XCUIApplication()
        
        app.buttons["express"].tap()
        
        XCTAssert(app.buttons["sad"].exists)
        XCTAssert(app.buttons["frustrated"].exists)
        XCTAssert(app.buttons["anger"].exists)
        XCTAssert(app.buttons["anxious"].exists)
        XCTAssert(app.buttons["btn eraser"].exists)
    }
}
