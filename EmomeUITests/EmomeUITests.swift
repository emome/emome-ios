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
    

    func testShowEmotionReslut() {
        let app = XCUIApplication()
        
        app.buttons["What can I do?"].tap()
        // Should pop up an alert with a single button
        XCTAssertEqual(app.alerts.count, 1)
        XCTAssertEqual(app.alerts["happy"].collectionViews.buttons.count, 1)
        
        app.alerts["happy"].collectionViews.buttons["OK"].tap()
        // The alert should be dismissed
        XCTAssertEqual(app.alerts.count, 0)
    }
    
}
