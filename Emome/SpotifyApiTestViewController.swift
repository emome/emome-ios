//
//  SpotifyApiTestViewController.swift
//  
//
//  Created by HsiaoChing Lin on 10/30/15.
//
//

import UIKit
import Spotify

class SpotifyApiTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var spotifyPlaylistTableView: UITableView!
	var playlists = []
	
	@IBAction func submit(sender: UIButton) {
		let text = textIn.text		
		SPTSearch.performSearchWithQuery(text, queryType: SPTSearchQueryType.QueryTypePlaylist, accessToken: nil) { (error: NSError!, response: AnyObject!) -> Void in
			if error != nil {
				print(error)
			}
			print(text)
			let result : SPTListPage = response as! SPTListPage
			self.playlists = result.items
			print(self.playlists)
			self.spotifyPlaylistTableView.reloadData()
		}
	}
	
    @IBOutlet weak var textIn: UITextField!
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.playlists.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let playlistCell:UITableViewCell = self.spotifyPlaylistTableView.dequeueReusableCellWithIdentifier("playlistCell")! as UITableViewCell
		
		if let checkedUrl = (self.playlists[indexPath.row] as! SPTPartialPlaylist).smallestImage.imageURL {
			(playlistCell.contentView.viewWithTag(10) as! UIImageView).contentMode = .ScaleAspectFit
			downloadImage(checkedUrl, playlistCell: playlistCell)
		} else {
			print("checkedUrl failed.")
		}
		
		if let playlistName = (self.playlists[indexPath.row] as! SPTPartialPlaylist).name {
			(playlistCell.contentView.viewWithTag(20) as! UILabel).text = playlistName
		}
		
		if let playlistOwner = (self.playlists[indexPath.row] as! SPTPartialPlaylist).owner {
			(playlistCell.contentView.viewWithTag(30) as! UILabel).text = playlistOwner.canonicalUserName
			print("Owner is ", playlistOwner.canonicalUserName)
		} else {
			print("Miss owner orz...")
		}
//		
//		if let playlistUri = (self.playlists[indexPath.row] as! SPTPartialPlaylist).uri {
////			self.palylistUris.setValue(playlistUri, forKey: String(indexPath.row))
//			
//		}
		
		return playlistCell
	}
	
	func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
		NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
			completion(data: data, response: response, error: error)
			}.resume()
	}
	
	func downloadImage(url: NSURL, playlistCell: UITableViewCell){
		print("Started downloading \"\(url.URLByDeletingPathExtension!.lastPathComponent!)\".")
		getDataFromUrl(url) { (data, response, error)  in
			dispatch_async(dispatch_get_main_queue()) { () -> Void in
				guard let data = data where error == nil else { return }
				print("Finished downloading \"\(url.URLByDeletingPathExtension!.lastPathComponent!)\".")
				(playlistCell.contentView.viewWithTag(10) as! UIImageView).image = UIImage(data: data)
			}
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let playlistUri = (self.playlists[indexPath.row] as! SPTPartialPlaylist).uri
		UIApplication.sharedApplication().openURL(playlistUri)
	}
	
    override func viewDidLoad() {
		
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
