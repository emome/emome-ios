//
//  EMODataManager.swift
//  Emome
//
//  Created by Huai-Che Lu on 10/27/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import Foundation
import Alamofire
import FBSDKCoreKit

// Notification when suggestions are fetched
let DataManagerSuggestionsFetchedNotification = "com.emomeapp.emome.DataManagerSuggestionsFetched"
let DataManagerSuggestionPostedNotification = "com.emomeapp.emome.DataManagerSuggestionPosted"
let EmomeAPIBaseUrl = "http://localhost:5000" //"http://52.3.174.167"


private let _sharedInstance = EMODataManager()

class EMODataManager {
    
    class var sharedInstance: EMODataManager {
        return _sharedInstance
    }
    
    private var _emotionRawMeasurement: [EMOEmotion: Double] = [EMOEmotion: Double]()
    
    func normalizeEmotionMeasurement(measurement: [EMOEmotion: Double]) -> [String: Int] {
        
        var normalizedMeasurement: [String: Int] = [String: Int]()
        for emotion in EMOEmotion.allValues {
            if let rawValue = measurement[emotion] {
                let normalized = Int(round(rawValue / 0.5))
                normalizedMeasurement[emotion.description] = min(normalized, 10)
            } else {
                normalizedMeasurement[emotion.description] = 0
            }
        }
            
        return normalizedMeasurement
    }
    
    func setEmotionMeasurement(measurement: Double, emotion: EMOEmotion) {
        self._emotionRawMeasurement[emotion] = measurement
    }
    
    func getEmotionMeasurement() -> [EMOEmotion: Double] {
        return self._emotionRawMeasurement
    }
    
    // MARK: - Fetch Suggestions
    
    private let concurrentSuggestionQueue = dispatch_queue_create("com.emomeapp.emome.suggestionQueue", DISPATCH_QUEUE_CONCURRENT)
    
    private var _suggestions: [EMOSuggestion] = []
    var suggestions: [EMOSuggestion] {
        var suggestionsCopy: [EMOSuggestion]!
        dispatch_sync(self.concurrentSuggestionQueue) { () -> Void in
            suggestionsCopy = self._suggestions
        }
        return suggestionsCopy
    }
    
    func fetchSuggestions(withEmotionMeasurement measurement: [EMOEmotion: Double], scenarioId: String) {
        log.debug("Start fetching suggestions")
        
        let emotionDict = self.normalizeEmotionMeasurement(measurement)
        let emotionJSONString = "{\"\(EMOEmotion.Sad)\":\(emotionDict[EMOEmotion.Sad.description]!), \"\(EMOEmotion.Frustrated)\":\(emotionDict[EMOEmotion.Frustrated.description]!), \"\(EMOEmotion.Angry)\":\(emotionDict[EMOEmotion.Angry.description]!), \"\(EMOEmotion.Anxious)\":\(emotionDict[EMOEmotion.Anxious.description]!)}"
        
        
        let parameters: [String: AnyObject] = [
            "user_id": NSUserDefaults.standardUserDefaults().valueForKey(keyUserId)!,
            "scenario_id": scenarioId,
            "emotion": emotionJSONString
        ]

        print("\(parameters)")
        
        
        Alamofire.request(.GET, "\(EmomeAPIBaseUrl)/suggestion", parameters: parameters)
            .responseCollection { (response: Response<[EMOSuggestion], NSError>) in
                
                if let suggestions = response.result.value {
                    dispatch_barrier_async(self.concurrentSuggestionQueue, { () -> Void in
                        self._suggestions = suggestions
                        dispatch_async(dispatch_get_main_queue()) {
                            self.postNotification(DataManagerSuggestionsFetchedNotification)
                        }
                    })
                }
            }
        
    }
    
    // MARK: - Save History
    
    func saveActionHistry(ofSuggestionId suggestionId: String) {
        
        let emotionDict = self.normalizeEmotionMeasurement(self._emotionRawMeasurement)
        let emotionJSONString = "{\"\(EMOEmotion.Sad)\":\(emotionDict[EMOEmotion.Sad.description]!), \"\(EMOEmotion.Frustrated)\":\(emotionDict[EMOEmotion.Frustrated.description]!), \"\(EMOEmotion.Angry)\":\(emotionDict[EMOEmotion.Angry.description]!), \"\(EMOEmotion.Anxious)\":\(emotionDict[EMOEmotion.Anxious.description]!)}"
        
        let parameters: [String: AnyObject] = [
            "user_id": NSUserDefaults.standardUserDefaults().valueForKey(keyUserId)!,
            "scenario_id": self.selectedScenarioId!,
            "suggestion_id": suggestionId,
            "emotion": emotionJSONString
        ]
        
        Alamofire.request(.POST, "\(EmomeAPIBaseUrl)/history", parameters: parameters)
            .responseJSON { response in
                log.debug("\(response.result)")
                
                if let JSON = response.result.value {
                    log.debug("JSON: \(JSON)")
                    
                }
        }
    }
    
    private func postNotification(notificationName: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
    
    
    // MARK: - Fetch Scenarios
    
    private let concurrentScenarioQueue = dispatch_queue_create("com.emomeapp.emome.scenarioQueue", DISPATCH_QUEUE_CONCURRENT)
    
    var _scenarios: [EMOScenario] = []
    var scenarios: [EMOScenario] {
        var scneariosCopy: [EMOScenario]!
        dispatch_sync(self.concurrentScenarioQueue) { () -> Void in
            scneariosCopy = self._scenarios
        }
        return scneariosCopy
    }
    
    var selectedScenarioId: String?
    var scenario: EMOScenario!
    
    func fetchScenarios() {
        self.clearScenarios()
        Alamofire.request(.GET, "\(EmomeAPIBaseUrl)/scenario", parameters: nil)
            .responseJSON { response in
                log.debug("scenarios \(response.result)")   // result of response serialization
                if let JSON = response.result.value as? [String: AnyObject] {
                    log.debug("Scenarios: \(JSON)")
                    
                    if let scenarioData = JSON["data"] as? [String: String] {
                        dispatch_barrier_async(self.concurrentScenarioQueue, { () -> Void in
                            for (scenarioId, scenarioTitle) in scenarioData {
                                self._scenarios.append(EMOScenario.init(withId: scenarioId, title: scenarioTitle))
                            }
                        })
                    }
                }
            }
    }
    
    func clearScenarios() {
        dispatch_barrier_sync(self.concurrentScenarioQueue, { () -> Void in
            self._scenarios.removeAll()
        })
    }
    
    
    
    // MARK: - Post Suggestion

    var emotionRawMeasurementForPostingSuggestion: [EMOEmotion: Double] = [EMOEmotion: Double]()
    var scenarioIdForPostingSuggestion: String? = nil
    var messageForPostingSuggestion: String? = nil
    var actionTypeForPostingSuggestion: EMOActivityType? = nil
    var actionDataForPostingSuggestion: [String: String] = [String: String]()
    
    func postSuggestion() {
        log.debug("Start sending suggestions")
        
        let emotionDict = self.normalizeEmotionMeasurement(self.emotionRawMeasurementForPostingSuggestion)
        let emotionJSONString = "{\"\(EMOEmotion.Sad)\":\(emotionDict[EMOEmotion.Sad.description]!), \"\(EMOEmotion.Frustrated)\":\(emotionDict[EMOEmotion.Frustrated.description]!), \"\(EMOEmotion.Angry)\":\(emotionDict[EMOEmotion.Angry.description]!), \"\(EMOEmotion.Anxious)\":\(emotionDict[EMOEmotion.Anxious.description]!)}"
        
        var dataJSONString = ""
        for (key, value) in self.actionDataForPostingSuggestion {
            dataJSONString.appendContentsOf("\"\(key)\": \"\(value))\",")
        }
        
        dataJSONString = "{" + dataJSONString.substringToIndex(dataJSONString.endIndex.predecessor()) + "}"
        let contentJSONString = "{\"type\":\"\((self.actionTypeForPostingSuggestion?.description)!)\", \"data\":\(dataJSONString)}"
        log.verbose("content \(contentJSONString)")
        
        let parameters: [String: AnyObject] = [
            "user_id": NSUserDefaults.standardUserDefaults().valueForKey(keyUserId)! as! String,
            "scenario_id": self.scenarioIdForPostingSuggestion!,
            "emotion": emotionJSONString,
            "content": contentJSONString,
            "message": self.scenarioIdForPostingSuggestion!
        ]
        
        log.verbose("\(parameters)")
        
        Alamofire.request(.POST, "\(EmomeAPIBaseUrl)/suggestion", parameters: parameters)
            .responseJSON { response in
                log.debug("\(response.result)")   // result of response serialization
                
                
                log.verbose("\(NSString.init(data: (response.request?.HTTPBody)!, encoding: NSUTF8StringEncoding))")
                
                if let JSON = response.result.value {
                    log.debug("JSON: \(JSON)")
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.postNotification(DataManagerSuggestionPostedNotification)
                }
        }
    }
}