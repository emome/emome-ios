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

class EMOAccountViewController: EMOBaseViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loginButton = FBSDKLoginButton.init()
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            fetchUserInfo()
        }
        
        self.profileImageView.layer.cornerRadius = 50.0
    }
    
    func fetchUserInfo() {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"id,name,picture"]).startWithCompletionHandler({ (connection :FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                let id = result["id"] as! String
                let name = result["name"] as! String
                
                self.userIdLabel.text = id
                self.userNameLabel.text = name
                
                let profilePicUrl = "https://graph.facebook.com/\(id)/picture?type=large"
                Alamofire.request(.GET, profilePicUrl).responseImage(completionHandler: { (response: Response<Image, NSError>) -> Void in    
                    if let image = response.result.value {
                        self.profileImageView.image = image
                    }
                    
                })
                
                Alamofire.request(.POST, "http://52.3.174.167/login", parameters: ["_id": id])
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
        self.userIdLabel.text = nil
        self.userNameLabel.text = nil
    }

    @IBAction func backToHome(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
