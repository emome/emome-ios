//
//  EMOAccountViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 11/6/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import AlamofireImage
import CoreData

class EMOAccountViewController: EMOBaseViewController, FBSDKLoginButtonDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    private var feedbackUpdatedObserver: NSObjectProtocol!
    
    var histories = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loginButton = FBSDKLoginButton.init()
        loginButton.frame = CGRect(origin: CGPointMake(124.0, 120.0), size: loginButton.frame.size)
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            fetchUserInfo()
        }
        
        self.profileImageView.applyShadow()
        self.profileImageView.applyRoundCornerWithRadius(50.0)
        
        
        self.historyCollectionView.backgroundColor = UIColor.clearColor()
        
        self.feedbackUpdatedObserver = NSNotificationCenter.defaultCenter().addObserverForName(DataManagerFeedbackUpdatedNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification -> Void in
            self.historyCollectionView.reloadData()
        })
        
        
        if NSUserDefaults.standardUserDefaults().valueForKey(keyUserId) != nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "History")
            
            do {
                let results =
                try managedContext.executeFetchRequest(fetchRequest)
                histories = results as! [NSManagedObject]
                self.historyCollectionView.reloadData()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            for history in histories {
                log.verbose("history #\(history.valueForKey("id"))")
            }
        }
    }
    
    func fetchUserInfo() {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id,name,picture"]).startWithCompletionHandler({ (connection :FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let id = result["id"] as! String
                let name = result["name"] as! String
                
                self.userNameLabel.text = name
                
                let profilePicUrl = "https://graph.facebook.com/\(id)/picture?type=large"
                Alamofire.request(.GET, profilePicUrl).responseImage(completionHandler: { (response: Response<Image, NSError>) -> Void in    
                    if let image = response.result.value {
                        self.profileImageView.image = image
                    }
                    
                })
                
                Alamofire.request(.POST, "\(EmomeAPIBaseUrl)/user", parameters: ["_id": id])
                         .responseJSON { response in
                    log.debug("\(response.result.value)")
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(id, forKey: keyUserId)
                }
                
            } else {
                log.debug("FBGraphRequest error: \(error)")
            }
        })
    }
    
    
    // MARK: - FBSDKLoginButtonDelegate methods
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        log.debug("didCompleteWithResult \(result.token)")
        if FBSDKAccessToken.currentAccessToken() != nil {
            fetchUserInfo()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.profileImageView.image = nil
        self.userNameLabel.text = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey(keyUserId)
        
        
            let fetchRequest = NSFetchRequest(entityName: "History")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            do {
                try appDelegate.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: managedContext)
                self.historyCollectionView.reloadData()
            } catch let error as NSError {
                // TODO: handle the error
            }
    }

    @IBAction func backToHome(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.histories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "HistoryCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        cell.applyRoundCornerWithRadius(5.0)
        cell.applyShadow()
        
        let historyTitleLabel = cell.viewWithTag(1000) as! UILabel
        let historyDescriptionLabel = cell.viewWithTag(1001) as! UILabel
        let dateLabel = cell.viewWithTag(1002) as! UILabel
        
        historyTitleLabel.text = self.histories[indexPath.row].valueForKey("suggestionTitle") as? String
        historyDescriptionLabel.text = self.histories[indexPath.row].valueForKey("suggestionDescription") as? String
        
        dateLabel.text = "\(self.histories[indexPath.row].valueForKey("createdAt")! as? NSDate)"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        if let hasFeedback = self.histories[indexPath.row].valueForKey("hasFeedback") as? Bool {
            
            if hasFeedback {
                log.verbose("Already has feedback")
            } else {
                
                EMODataManager.sharedInstance.updateFeedBackOfHistory((self.histories[indexPath.row].valueForKey("id") as? String)!)
                
//                
//                self.histories[indexPath.row].setValue(true, forKey: "hasFeedback")
//                do {
//                    try managedContext.save()
//                    self.historyCollectionView.reloadData()
//                } catch let error as NSError  {
//                    log.debug("Could not save \(error), \(error.userInfo)")
//                }
            }
            
        }
    }

}
