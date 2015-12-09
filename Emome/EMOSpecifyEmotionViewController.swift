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
    @IBOutlet weak var anxiousSlideBar: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sadSlider.tintColor = UIColor.colorForEmotion(.Sad)
        self.frustratedSlider.tintColor = UIColor.colorForEmotion(.Frustrated)
        self.angrySlider.tintColor = UIColor.colorForEmotion(.Angry)
        self.anxiousSlideBar.tintColor = UIColor.colorForEmotion(.Anxious)
    }
    
    @IBAction func backToContentSearch() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
