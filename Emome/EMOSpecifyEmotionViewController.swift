//
//  EMOSpecifyEmotionViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/8/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOSpecifyEmotionViewController: EMOBaseViewController {

    @IBOutlet weak var sadSlider: UISlider!
    @IBOutlet weak var frustratedSlider: UISlider!
    @IBOutlet weak var angrySlider: UISlider!
    @IBOutlet weak var anxiousSlider: EMOEmotionSlider!
    
    var emotionSlidersDict: [EMOEmotion: UISlider] = [EMOEmotion: UISlider]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emotionSlidersDict[.Sad] = self.sadSlider
        self.emotionSlidersDict[.Frustrated] = self.frustratedSlider
        self.emotionSlidersDict[.Angry] = self.angrySlider
        self.emotionSlidersDict[.Anxious] = self.anxiousSlider

        for emotion in EMOEmotion.allValues {
            self.emotionSlidersDict[emotion]?.tintColor = UIColor.colorForEmotion(emotion)
        }
    }
    
    @IBAction func backToContentSearch() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        for emotion in EMOEmotion.allValues {    
            let value = self.emotionSlidersDict[emotion]?.value
            
            EMODataManager.sharedInstance
                .emotionRawMeasurementForPostingSuggestion[emotion] = Double(value!)
            
        }
    }


}
