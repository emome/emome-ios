//
//  EMOSpecifyEmotionViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/8/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class EMOSpecifyEmotionViewController: EMOBaseViewController {

    
    @IBOutlet weak var suggestionImageView: UIImageView!
    
    @IBOutlet weak var sadSlider: UISlider!
    @IBOutlet weak var frustratedSlider: UISlider!
    @IBOutlet weak var angrySlider: UISlider!
    @IBOutlet weak var anxiousSlider: EMOEmotionSlider!
    @IBOutlet weak var suggestionTitleLabel: UILabel!
    @IBOutlet weak var suggestionDescriptionLabel: UILabel!
    
    var emotionSlidersDict: [EMOEmotion: UISlider] = [EMOEmotion: UISlider]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataManager = EMODataManager.sharedInstance
        
        let suggestionImageUrl = dataManager.actionDataForPostingSuggestion["cover_img_url"]! as
        String
        
        Alamofire.request(.GET, suggestionImageUrl)
            .responseImage(completionHandler: { (response: Response<Image, NSError>) -> Void in
            if let image = response.result.value {
                self.suggestionImageView.image = image
            }
        })
        
        self.suggestionImageView.clipsToBounds = false
        self.suggestionImageView.layer.cornerRadius = 5.0
        self.suggestionImageView.layer.shadowColor = UIColor.blackColor().CGColor
        self.suggestionImageView.layer.shadowOpacity = 0.5
        self.suggestionImageView.layer.shadowOffset = CGSizeMake(0.0, 4.0)
        
        self.suggestionTitleLabel.text =
            dataManager.actionDataForPostingSuggestion["track_name"]! as String
        self.suggestionDescriptionLabel.text =
            dataManager.actionDataForPostingSuggestion["artist"]! as String
        
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
