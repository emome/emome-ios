//
//  ViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 9/21/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    let imageNames: [String] = ["happy", "angry", "lonely", "excited", "sad"]
    let colors: [UIColor] = [
        UIColor.init(red: 253.0/255.0, green: 1.0, blue: 0.0, alpha: 1.0),
        UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
        UIColor.init(red: 204.0/255.0, green: 222.0/255.0, blue: 196.0/255.0, alpha: 1.0),
        UIColor.init(red: 152.0/255.0, green: 1.0, blue: 0.0, alpha: 1.0),
        UIColor.init(red: 66.0/255.0, green: 189.0/255.0, blue: 1.0, alpha: 1.0)
    ]
    
    var tableView: UITableView!

    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        
        for index in 0..<imageNames.count {
            
            frame.origin.x = self.view.frame.size.width * CGFloat(index)
            frame.size = self.view.frame.size
            
            let subView = UIImageView.init(frame: frame)
            subView.image = UIImage.init(named: imageNames[index])
            self.scrollView.addSubview(subView)
            
            let maskView = UIImageView(frame: CGRectMake(0.0, 100.0, self.view.frame.width, self.view.frame.height - 100.0))
            maskView.image = UIImage.init(named: "mask")
            subView.addSubview(maskView)
            
            
            
            let emotionLabel = UILabel(frame: CGRectMake(32.0, 440.0, 320.0, 100.0))
//            emotionLabel.text = imageNames[index]
            emotionLabel.font = UIFont.systemFontOfSize(50.0)
            emotionLabel.textColor = colors[index]
            let attr = [NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
            emotionLabel.attributedText = NSAttributedString.init(string: imageNames[index], attributes: attr)
            
            subView.addSubview(emotionLabel)
        }
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * CGFloat(imageNames.count), self.scrollView.frame.size.height)
        
        let emotionLabelView = UILabel(frame: CGRectMake(32.0, 410.0, 320.0, 100.0))
        emotionLabelView.text = "I'm feeling\nsad"
        emotionLabelView.textColor = UIColor.whiteColor()
        emotionLabelView.font = UIFont.systemFontOfSize(50.0)
        self.view.addSubview(emotionLabelView)
        
//        self.tableView = UITableView.init(frame: CGRectMake(0.0, 100.0, self.view.frame.width, self.view.frame.height))
//        self.tableView.dataSource = self
//        self.view.addSubview(self.tableView)
        
        let hitArea = UIButton.init(frame: CGRectMake(0.0, 400.0, self.view.frame.width, self.view.frame.height - 400.0))
        hitArea.addTarget(self, action: "showList:", forControlEvents: .TouchUpInside)
//        hitArea.backgroundColor = UIColor.redColor()
        self.view.addSubview(hitArea)
    }
    
    func showList(sender: UIButton) {
        self.performSegueWithIdentifier("showList", sender: self)
    }
    
}

