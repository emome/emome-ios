//
//  EMOChooseSeggestionTypeViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 12/6/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit
import Spotify
import Alamofire
import AlamofireImage

class EMOChooseSeggestionTypeViewController: EMOBaseViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var playlists: [SPTPartialPlaylist] = []
    var tracks: [SPTPartialTrack] = []
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var promptTextView: UITextView!
    
    @IBOutlet weak var searchResultCountLabel: UILabel!
    
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchResultCollectionView.backgroundColor = UIColor.clearColor()
        searchResultCollectionView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        self.searchBar.becomeFirstResponder()
        self.searchResultCollectionView.clipsToBounds = false
        
        self.headerView.clipsToBounds = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPointZero, size: CGSizeMake(self.view.bounds.width, self.headerView.bounds.height + 20))
        
        gradientLayer.colors = [UIColor.emomeBackgroundColor().CGColor, UIColor.emomeBackgroundColor().colorWithAlphaComponent(0.0).CGColor]
        gradientLayer.startPoint = CGPointMake(0.5, 0.8)
        gradientLayer.endPoint = CGPointMake(0.5, 1.0)
        self.headerView.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    @IBAction func backToHome(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text {
        
        
            SPTSearch.performSearchWithQuery(searchText, queryType: SPTSearchQueryType.QueryTypeTrack, accessToken: nil) { (error: NSError!, response: AnyObject!) -> Void in
                if error != nil {
                    print(error)
                }
                
                log.verbose("Search term: \(searchText)")
                let result : SPTListPage = response as! SPTListPage
                // self.playlists = result.items as! [SPTPartialPlaylist]
                //            print(self.playlists)
                //            self.spotifyPlaylistTableView.reloadData()
                
                //            log.verbose("\(result.items)")
                
                if let items = result.items {
                    self.tracks = items as! [SPTPartialTrack]
                    
                        let textTransitionAnim = CATransition()
                        textTransitionAnim.duration = 0.2
                        textTransitionAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                    
                    if self.promptTextView.text != "" {
                        self.promptTextView.layer.addAnimation(textTransitionAnim, forKey: "textTransition")
                        self.promptTextView.text = ""
                    }
                    
                    
                    self.searchResultCountLabel.layer.addAnimation(textTransitionAnim, forKey: "textTransition")
                    self.searchResultCountLabel.text = "\(self.tracks.count) results found"
                    
                    self.searchResultCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "SearchResultCell"
        
        struct Holder {
            static var nibLoaded = false
        }
        
        if !Holder.nibLoaded {
            collectionView.registerNib(UINib.init(nibName: "EMOSearchResultCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: identifier)
            Holder.nibLoaded = true
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! EMOSearchResultCollectionViewCell
        
        if cell.featureImageView != nil {
            cell.featureImageView.image = nil
        }
        
//        let playlist = self.playlists[indexPath.row]
        let track = self.tracks[indexPath.row]
        
        
        let featureImageUrl = track.album.largestCover?.imageURL.URLString
        Alamofire.request(.GET, featureImageUrl!).responseImage(completionHandler: { (response: Response<Image, NSError>) -> Void in
            if let image = response.result.value {
                
                cell.featureImageView.image = image
                
                let opacityAnim = CABasicAnimation(keyPath: "opacity")
                opacityAnim.fromValue = 0.0
                opacityAnim.duration = 0.7
                opacityAnim.toValue = 1.0
                
                cell.featureImageView.layer.addAnimation(opacityAnim, forKey: "opacity")
            }
            
        })
        
        cell.titleLabel?.text = track.name
        cell.descriptionLabel?.text = "\(track.artists[0].name)"
        
//        if let playlistName = playlist.name {
//            cell.titleLabel.text = playlistName
//        }
//        
//        let trackCount = playlist.trackCount
//        cell.descriptionLabel.text = "\(trackCount) tracks"
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let track = self.tracks[indexPath.row]
        
        log.verbose("\(track.name) clicked")
        EMODataManager.sharedInstance.actionTypeForPostingSuggestion = .Spotify
        EMODataManager.sharedInstance.actionDataForPostingSuggestion = [
            "track_id": track.identifier,
            "artist": track.artists[0].name,
            "track_name": track.name,
            "url": track.uri.URLString,
            "cover_img_url": track.album.largestCover.imageURL.URLString,
        ]
        
        self.performSegueWithIdentifier("ChooseEmotion", sender: nil)
        
        
    }

}
