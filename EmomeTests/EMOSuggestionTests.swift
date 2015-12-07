//
//  EMOSuggestionTests.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/7/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import XCTest
@testable import Emome

class EMOSuggestionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuggestionsFromJSONString() {
        
        // [Test] Invalid JSON String
        var suggestions = EMOSuggestion.suggestionsFromJSONString("")
        
        // [Test] Empty JSON String
        suggestions = EMOSuggestion.suggestionsFromJSONString("")
        XCTAssertEqual(suggestions.count, 0)
        
        // [Test] Missing Parameter(s)
        
        
        // [Test] Normal Case
        suggestions = EMOSuggestion.suggestionsFromJSONString("[{suggestion_id:20}, {suggestion_id:30}]")
        
        XCTAssertEqual(suggestions.count, 3)
    }
    
}
