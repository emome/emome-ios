//
//  EMOScenarioSelectionViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 10/26/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import QuartzCore

class EMOScenarioSelectionViewController: UIViewController {
    
    var scenarios = ["bossy boss", "rainy day sucks", "tired of routine tasks", "insomnia"]
    var selectedScenario:String?
    var scenarioButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var origin = CGPoint(x: 15.0, y: 180.0)
        
        for scenario in scenarios {
            let frame = CGRect(origin: origin, size: CGSizeMake(100.0, 30.0))
            let button = UIButton.init(frame: frame)
            button.setTitle(scenario, forState: .Normal)
            button.setTitleColor(UIColor.emomeTextGrayColor(), forState: .Normal)
            button.setTitleColor(UIColor.emomeHighlightColor(), forState: .Selected)
            button.sizeToFit()
            button.frame = CGRect(origin: origin, size: CGSize(width:button.frame.width + 25.0 * 2, height:button.frame.height))
            button.titleLabel?.textAlignment = .Center
            button.addTarget(self, action: "scenarioSelected:", forControlEvents: .TouchUpInside)
            
            button.layer.borderWidth = 3.0
            button.layer.cornerRadius = 15.0
            button.layer.borderColor = UIColor.emomeGrayColor().CGColor
            
            self.scenarioButtons.append(button)
            self.view.addSubview(button)
            
            origin.y += 60.0
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func resetButton(button: UIButton) {
        button.selected = false
        button.layer.borderColor = UIColor.emomeGrayColor().CGColor
    }
    
    func scenarioSelected(sender: UIButton) {
        self.selectedScenario = sender.titleLabel?.text
        _ = scenarioButtons.map(resetButton)
        sender.layer.borderColor = UIColor.emomeHighlightColor().CGColor
        sender.selected = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let scenario = self.selectedScenario {
            EMODataManager.sharedInstance.scenario = scenario
        }
    }
}
