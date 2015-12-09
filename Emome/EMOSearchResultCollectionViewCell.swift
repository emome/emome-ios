    //
//  EMOSearchResultCollectionViewCell.swift
//  
//
//  Created by Huai-Che Lu on 12/8/15.
//
//

import UIKit
import QuartzCore

class EMOSearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = false
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 3.0)
        self.layer.shadowOpacity = 0.5
        
        self.featureImageView.clipsToBounds = true
        let maskPath = UIBezierPath.init(roundedRect: self.featureImageView.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        self.featureImageView.layer.mask = maskLayer
    }

}
