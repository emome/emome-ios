//
//  EMOSuggestionView.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/16/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOSuggestionView: UIView {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    var url: NSURL!
    

    func bindWithSuggestion(suggestion: EMOSuggestion) {
        
        self.titleLabel.text = suggestion.title
        self.categoryLabel.text = suggestion.category
        self.descriptionLabel.text = suggestion.description
        
        self.actionButton.backgroundColor = UIColor.colorForActivity(suggestion.activityType)
        self.actionButton.setTitle("\(suggestion.activityType.actionTitle)", forState: .Normal)
        self.actionButton.addTarget(self, action: "openUrl:", forControlEvents: .TouchUpInside)
        self.url = suggestion.url
    }
    
    func openUrl(sender: UIButton) {
        if url != nil {
            print("Open \(self.url)")
            UIApplication.sharedApplication().openURL(self.url)
        }
    }
    
}
