//
//  ViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 9/21/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOEmotionSelectionViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let emotions:[String] = ["happy", "angry", "lonely", "excited", "sad"]
    let emotionColors:[UIColor] = [
        UIColor.init(red: 253.0/255.0, green: 1.0, blue: 0.0, alpha: 1.0),
        UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
        UIColor.init(red: 204.0/255.0, green: 222.0/255.0, blue: 196.0/255.0, alpha: 1.0),
        UIColor.init(red: 152.0/255.0, green: 1.0, blue: 0.0, alpha: 1.0),
        UIColor.init(red: 66.0/255.0, green: 189.0/255.0, blue: 1.0, alpha: 1.0)
    ]

    @IBOutlet weak var emotionPages: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addEmotionPages()
    }
    
    func addEmotionPages() {
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        for i in 0..<self.emotions.count {
            
            
            let frame = CGRectMake(width * CGFloat(i), 0.0, width, height)
            let emotionPage = UIView.init(frame: frame)
            emotionPage.backgroundColor = self.emotionColors[i]
            self.emotionPages.addSubview(emotionPage)
            
            let emotionLabel = UILabel(frame: CGRectMake(0.0, 0.0, 320.0, 100.0))
            emotionLabel.font = UIFont.systemFontOfSize(60.0)
            let attr = [NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
            emotionLabel.attributedText = NSAttributedString.init(string: self.emotions[i], attributes: attr)
            emotionLabel.center = CGPointMake(width / 2.0, 200.0)
            emotionLabel.textAlignment = NSTextAlignment.Center
            emotionLabel.backgroundColor = UIColor.whiteColor()
            emotionPage.addSubview(emotionLabel)
        }
        
        self.emotionPages.contentSize = CGSizeMake(width * CGFloat(self.emotions.count), height)
    }
    
    @IBAction func showList(sender: AnyObject) {
        let page:Int = Int(self.emotionPages.contentOffset.x / self.emotionPages.frame.size.width)
        
        let alert = UIAlertController.init(title: "\(emotions[page])", message: "Showing results for \(emotions[page])", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

