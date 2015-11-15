//
//  EMOSeggestionViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 10/26/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOSeggestionViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	
	var pageImages: [UIImage] = []
	var pageViews: [UIButton?] = []
	var pageUrls: [String?] = []
	var currentPage: Int? = 0
	var suggestions: [String?] = []
	var monsterFigures: [UIImage] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// 1
		pageImages = [UIImage(named: "card-spotify")!,
			UIImage(named: "card-yelp")!]
		suggestions = ["Hey, last time I felt sad in a rainy day, I came across this playlist. It really helped.",
			"How about having some hot chocolate today? I feel much better having it in such a cold day :)"]
		monsterFigures = [UIImage(named: "img-monster-1")!, UIImage(named: "img-monster-2")!]
		
		let pageCount = pageImages.count
		
		// 2
		pageControl.currentPage = 0
		pageControl.numberOfPages = pageCount
		
		// 3
		for _ in 0..<pageCount {
			pageViews.append(nil)
		}
		
		// 4
		let pagesScrollViewSize = scrollView.frame.size
		scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
			height: pagesScrollViewSize.height)
		
		// 5
		loadVisiblePages()

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
	
	func loadPage(page: Int) {
		if page < 0 || page >= pageImages.count {
			// If it's outside the range of what you have to display, then do nothing
			return
		}
		
		// 1
		if let pageView = pageViews[page] {
			// Do nothing. The view is already loaded.
		} else {
			// 2
			var frame = scrollView.bounds
			frame.origin.x = frame.size.width * CGFloat(page)
			frame.origin.y = 0.0
			
			// 3
			let newPageView = UIButton()
			newPageView.setImage(pageImages[page], forState: .Normal)
			newPageView.contentMode = .ScaleAspectFit
			newPageView.frame = frame
			scrollView.addSubview(newPageView)
			
			var monsterFrame = scrollView.bounds
			monsterFrame.origin.x = monsterFrame.size.width * CGFloat(page) + 30.0
			monsterFrame.origin.y = 70.0
			monsterFrame.size.width = 120.0
			monsterFrame.size.height = 120.0
			
			let monsterView = UIImageView()
			monsterView.image = monsterFigures[page]
			monsterView.frame = monsterFrame
			monsterView.contentMode = .ScaleAspectFit
			scrollView.addSubview(monsterView)
			
			var textFrame = scrollView.bounds
			textFrame.origin.x = textFrame.size.width * CGFloat(page) + 160.0
			textFrame.origin.y = 70.0
			textFrame.size.width = 200.0
			textFrame.size.height = 120.0
			
			let newTextView = UITextView()
			newTextView.text = suggestions[page]
			newTextView.frame = textFrame
			newTextView.font = UIFont.systemFontOfSize(18.0)
			scrollView.addSubview(newTextView)
			
			newPageView.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
			
			// 4
			pageViews[page] = newPageView
		}
	}
	
	func pressed(sender: UIButton!) {
		pageUrls = ["spotify://user:spotify:playlist:5eSMIpsnkXJhXEPyRQCTSc", "yelp:///biz/the-city-bakery-new-york"]
		let openURL = NSURL(string: pageUrls[currentPage!]!)
		UIApplication.sharedApplication().openURL(openURL!)
	}
	
	func purgePage(page: Int) {
		if page < 0 || page >= pageImages.count {
			// If it's outside the range of what you have to display, then do nothing
			return
		}
		
		// Remove a page from the scroll view and reset the container array
		if let pageView = pageViews[page] {
			pageView.removeFromSuperview()
			pageViews[page] = nil
		}
	}
	
	func loadVisiblePages() {
		// First, determine which page is currently visible
		let pageWidth = scrollView.frame.size.width
		let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
		currentPage = page
		
		// Update the page control
		pageControl.currentPage = page
		
		// Work out which pages you want to load
		let firstPage = page - 1
		let lastPage = page + 1
		
		// Purge anything before the first page
		for var index = 0; index < firstPage; ++index {
			purgePage(index)
		}
		
		// Load pages in our range
		for index in firstPage...lastPage {
			loadPage(index)
		}
		
		// Purge anything after the last page
		for var index = lastPage+1; index < pageImages.count; ++index {
			purgePage(index)
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		// Load the pages that are now on screen
		loadVisiblePages()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    @IBAction func finishEmome() {
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
