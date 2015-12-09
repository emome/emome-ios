//
//  EMOHomeViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/26/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            switch identifier {
            case "Home2GetSuggestions", "Home2MakeSuggestions":
                EMODataManager.sharedInstance.fetchScenarios()
            default:
                break
            }
        }
        
    }


}
