//
//  EMOScenarioSelectionViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 10/26/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import QuartzCore
import pop

class EMOScenarioSelectionViewController: EMOBaseViewController {
    
    var scenarios: [EMOScenario]! = nil
    var selectedScenarioIdx: Int! = nil
    var scenarioButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var origin = CGPoint(x: 15.0, y: 150.0)
        
        self.scenarios = EMODataManager.sharedInstance.scenarios
        
        for i in 0..<self.scenarios.count {
            let scenario = self.scenarios[i]
            let frame = CGRect(origin: origin, size: CGSizeMake(100.0, 30.0))
            let button = UIButton.init(frame: frame)
            button.setTitle(scenario.title, forState: .Normal)
            button.setTitleColor(UIColor.emomeTextGrayColor(), forState: .Normal)
            button.setTitleColor(UIColor.emomeHighlightColor(), forState: .Selected)
            button.sizeToFit()
            button.frame = CGRect(origin: origin, size: CGSize(width:button.frame.width + 25.0 * 2, height:button.frame.height))
            button.titleLabel?.textAlignment = .Center
            button.addTarget(self, action: "scenarioSelected:", forControlEvents: .TouchUpInside)
            
            button.layer.borderWidth = 3.0
            button.layer.cornerRadius = 15.0
            button.layer.borderColor = UIColor.emomeGrayColor().CGColor
            
            button.tag = i + 1000
            
            self.scenarioButtons.append(button)
            self.view.addSubview(button)
            
            origin.y += 60.0
        }
        
        log.debug("\(EMODataManager.sharedInstance.getEmotionMeasurement())")
    }
    
    func resetButton(button: UIButton) {
        button.selected = false
        button.layer.borderColor = UIColor.emomeGrayColor().CGColor
    }
    
    func scenarioSelected(sender: UIButton) {
        self.selectedScenarioIdx = sender.tag - 1000
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
        
        if let idx = self.selectedScenarioIdx {
            
            let scenarioId = self.scenarios[idx].id
            
            if segue.identifier == "Scenario2Message" {
                EMODataManager.sharedInstance.scenarioIdForPostingSuggestion = scenarioId
            } else {
                EMODataManager.sharedInstance.selectedScenarioId = scenarioId
            }
        }
    }
}
