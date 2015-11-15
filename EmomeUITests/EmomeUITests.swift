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
    
    func testTabBarItems() {
        
        let app = XCUIApplication()
        XCTAssertEqual(app.tabBars.buttons.count, 4)
        XCTAssert(app.tabBars.buttons["Emome"].exists)
        XCTAssert(app.tabBars.buttons["Discover"].exists)
        XCTAssert(app.tabBars.buttons["My Ideas"].exists)
        XCTAssert(app.tabBars.buttons["Me"].exists)
    }
    
    func testEmomeTab() {
        let app = XCUIApplication()
        XCTAssert(app.tabBars.buttons["Emome"].selected)
        XCTAssert(app.buttons["let's get started"].exists)
        app.buttons["let's get started"].tap()
        
        XCTAssert(app.staticTexts["hey, I know it's a long day. how are you feeling right now?"].exists)
    }
    
    func testEmometer() {
        
        let app = XCUIApplication()
        
        let startEmomeButton = app.buttons["let's get started"]
        startEmomeButton.tap()
        
        XCTAssert(app.staticTexts["hey, I know it's a long day. how are you feeling right now?"].exists)
        XCTAssert(app.staticTexts["sad"].exists)
        XCTAssert(app.staticTexts["frustrated"].exists)
        XCTAssert(app.staticTexts["angry"].exists)
        XCTAssert(app.staticTexts["fearful"].exists)
        
        XCTAssertEqual(app.sliders.count, 4)
        
        let closeButton = app.buttons["ic cross"]
        let nextButton = app.buttons["NEXT"]
        XCTAssert(closeButton.exists)
        XCTAssert(nextButton.exists)
        
        closeButton.tap()
        XCTAssert(app.buttons["let's get started"].exists)
        
        startEmomeButton.tap()
        nextButton.tap()
        
        // Scenario Selection
        XCTAssert(app.buttons["NEXT"].exists)
        XCTAssert(app.buttons["ic left arrow"].exists)
    }
    
    func testWalkThroughEmome() {
        
        let app = XCUIApplication()
        let startEmomeButton = app.buttons["let's get started"]
        
        startEmomeButton.tap()
        
        let nextButton = app.buttons["NEXT"]
        nextButton.tap()
        nextButton.tap()
        app.buttons["DONE"].tap()
        
        XCTAssert(startEmomeButton.exists)
        
    }
}
