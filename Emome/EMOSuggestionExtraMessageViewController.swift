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
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        if textView.text == "any extra word helps..." {
//            textView.text = ""
//            textView.textColor = UIColor.emomeTextGrayColor()
//        }
//        textView.resignFirstResponder()
//    }
//    
//    func textViewDidEndEditing(textView: UITextView) {
//        if textView.text == "" {
//            textView.text = "any extra word helps..."
//            textView.textColor = UIColor.lightGrayColor()
//        }
//        textView.resignFirstResponder()
//    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DoneMakeSuggestion" {
            EMODataManager.sharedInstance
        }
    }


}
