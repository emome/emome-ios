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
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchResultCollectionView.backgroundColor = UIColor.clearColor()
        searchResultCollectionView.backgroundView?.backgroundColor = UIColor.clearColor()
        
        self.searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.featureImageView.image = nil
        
//        let playlist = self.playlists[indexPath.row]
        let track = self.tracks[indexPath.row]
        
        
        let featureImageUrl = track.album.largestCover?.imageURL.URLString
        Alamofire.request(.GET, featureImageUrl!).responseImage(completionHandler: { (response: Response<Image, NSError>) -> Void in
            if let image = response.result.value {
                cell.featureImageView.image = image
            }
            
        })
        
        cell.titleLabel.text = track.name
        cell.descriptionLabel.text = "\(track.artists[0].name)"
        
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
        self.performSegueWithIdentifier("ChooseEmotion", sender: self)
    }

}
