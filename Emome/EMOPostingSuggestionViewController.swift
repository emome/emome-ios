
//
//  EMOCompleteSuggestionViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/9/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOPostingSuggestionViewController: EMOBaseViewController {

    private var suggestionsPostedObserver: NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.suggestionsPostedObserver = NSNotificationCenter.defaultCenter().addObserverForName(DataManagerSuggestionPostedNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification -> Void in
            log.debug("Complete posting suggestion!")
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
        EMODataManager.sharedInstance.postSuggestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
