//
//  EMOSuggestionView.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/16/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import Alamofire

class EMOSuggestionView: UIView {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    var url: NSURL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 3.0)
        
        self.userInteractionEnabled = true
    }

    func bindWithSuggestion(suggestion: EMOSuggestion) {
        
        self.titleLabel.text = suggestion.title
        self.categoryLabel.text = suggestion.category
        self.descriptionLabel.text = suggestion.message
        
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
