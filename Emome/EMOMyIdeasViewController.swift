//
//  EMOMyIdeasViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/15/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOMyIdeasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let fakeData = ["spotify", "yelp", "yelp"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fakeData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyIdeaCell")
        
        cell?.textLabel?.text = self.fakeData[indexPath.row]
        
        return cell!
    }

}
