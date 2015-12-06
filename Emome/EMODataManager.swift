//
//  EMODataManager.swift
//  Emome
//
//  Created by Huai-Che Lu on 10/27/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation
import Alamofire

// Notification when suggestions are fetched
let DataManagerSuggestionsFetchedNotification = "com.emomeapp.emome.DataManagerSuggestionsFetched"


private let _sharedInstance = EMODataManager()

class EMODataManager {
    class var sharedInstance: EMODataManager {
        return _sharedInstance
    }
    
    private var _emotionRawMeasurement: [EMOEmotion: Double] = [EMOEmotion: Double]()
    private var _emotionNormalizedMeasurement: [EMOEmotion: Int] {
        get {
            var normalizedMeasurement: [EMOEmotion: Int] = [EMOEmotion: Int]()
            for emotion in EMOEmotion.allValues {
                let normalized = Int(round(_emotionRawMeasurement[emotion]! / 0.5))
                normalizedMeasurement[emotion] = min(normalized, 10)
            }
            
            return normalizedMeasurement
        }
    }
    
    func setEmotionMeasurement(measurement: Double, emotion: EMOEmotion) {
        self._emotionRawMeasurement[emotion] = measurement
    }
    
    func getEmotionMeasurement() -> [EMOEmotion: Double] {
        return self._emotionRawMeasurement
    }
    
    var scenario: String = ""
    
    private let concurrentSuggestionQueue = dispatch_queue_create("com.emomeapp.emome.suggestionQueue", DISPATCH_QUEUE_CONCURRENT)
    
    private var _suggestions: [EMOSuggestion] = []
    var suggestions: [EMOSuggestion] {
        var suggestionsCopy: [EMOSuggestion]!
        dispatch_sync(self.concurrentSuggestionQueue) { () -> Void in
            suggestionsCopy = self._suggestions
        }
        return suggestionsCopy
    }
    
    func fetchSuggestions() {
        log.debug("Start fetching suggestions")
        
        log.debug("With emotion measurement: \(self._emotionNormalizedMeasurement)")
        
        
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseJSON { response in
                log.debug("\(response.result)")   // result of response serialization
                
                if let JSON = response.result.value {
                    log.debug("JSON: \(JSON)")
                }
                
                dispatch_barrier_async(self.concurrentSuggestionQueue, { () -> Void in
                    self._suggestions.append(EMOSuggestion.init(id: "0", userId: "0", activityType: .Spotify,
                        title: "Life Sucks", category: "Playlist", description: "40 songs, 72 min",
                        url: NSURL(string: "spotify://user:spotify:playlist:5eSMIpsnkXJhXEPyRQCTSc")))
                    
                    self._suggestions.append(EMOSuggestion.init(id: "1", userId: "1", activityType: .Yelp,
                        title: "City Bakery", category: "Bakery", description: "Hot Chocolate",
                        url: NSURL(string: "yelp:///biz/the-city-bakery-new-york")))
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.postSuggestionsFetchedNotification()
                    }
                })
        }
        
    }
    
    func addSuggestion(suggestion: EMOSuggestion) {
        dispatch_barrier_async(self.concurrentSuggestionQueue) { () -> Void in
            self._suggestions.append(suggestion)
        }
    }
    
    private func postSuggestionsFetchedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(DataManagerSuggestionsFetchedNotification, object: nil)
    }
}