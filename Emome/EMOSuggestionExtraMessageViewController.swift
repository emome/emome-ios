//
//  EMOSuggestionExtraMessageViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/9/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOSuggestionExtraMessageViewController: EMOBaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var messageTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageTextView.becomeFirstResponder()
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DoneMakeSuggestion" {
            EMODataManager.sharedInstance.messageForPostingSuggestion = self.messageTextView.text
        }
    }


}
