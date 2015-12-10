//
//  EMOSuggestionView.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/16/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol EMOSuggestionViewDelegate {
    func suggestionViewDidSelect(seggestionView: EMOSuggestionView)
}

class EMOSuggestionView: UIView {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var featureImageView: UIImageView!
    var url: NSURL!
    var delegate: EMOSuggestionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 3.0)
    }
    
    
    func bindWithSuggestion(suggestion: EMOSuggestion) {
        
        self.titleLabel.text = suggestion.title
        self.descriptionLabel.text = suggestion.description
        
        self.actionButton.backgroundColor = UIColor.colorForActivity(suggestion.activityType)
        self.actionButton.setTitle("\(suggestion.activityType.actionTitle)", forState: .Normal)
        self.actionButton.addTarget(self, action: "openUrl:", forControlEvents: .TouchUpInside)
        self.url = suggestion.url
        self.messageLabel.text = suggestion.message
        
        Alamofire.request(.GET, suggestion.featureImageUrlString)
            .responseImage{ response in
            
            if let image = response.result.value {
                self.featureImageView.image = image
            }
        }
    }
    
    func openUrl(sender: UIButton) {
        if url != nil {
            print("Open \(self.url)")
            UIApplication.sharedApplication().openURL(self.url)
        }
        
        if let delegate = self.delegate {
            delegate.suggestionViewDidSelect(self)
        } else {
            log.debug("No delegate")
        }
    }
    
}
