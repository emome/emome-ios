//
//  EMOSeggestionViewController.swift
//  Emome
//
//  Created by Huai-Che Lu on 10/26/15.
//  Copyright © 2015 Emome. All rights reserved.
//

import UIKit

class EMOSeggestionViewController: EMOBaseViewController, UIScrollViewDelegate {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	
    var pageViews: [UIView?] = []
	var currentPage: Int? = 0
    
    private var suggestionsFetchingObserver: NSObjectProtocol!
	
    func addObserverForSuggestionsFetching() {
        self.suggestionsFetchingObserver = NSNotificationCenter.defaultCenter().addObserverForName(DataManagerSuggestionsFetchedNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue()) { notification in
                self.setUpPages()
                self.loadVisiblePages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addObserverForSuggestionsFetching()
        
        let scenarioId = EMODataManager.sharedInstance.selectedScenarioId == nil ? "0" :
            EMODataManager.sharedInstance.selectedScenarioId!
        
        EMODataManager.sharedInstance.fetchSuggestions(withEmotionMeasurement: EMODataManager.sharedInstance.getEmotionMeasurement(), scenarioId: scenarioId)
    }
    
    func setUpPages() {
        let pageCount = EMODataManager.sharedInstance.suggestions.count
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageCount),
            height: pagesScrollViewSize.height)
    }
	
	func loadPage(page: Int) {
        
		if page < 0 || page >= pageControl.numberOfPages {
			// If it's outside the range of what you have to display, then do nothing
			return
		}
        
		if pageViews[page] == nil {

			var frame = scrollView.bounds
			frame.origin.x = frame.size.width * CGFloat(page)
			frame.origin.y = 0.0
			
            dispatch_async(GlobalMainQueue) { () -> Void in
                let newPageView = UIView()
                newPageView.frame = frame
                self.scrollView.addSubview(newPageView)
                
                let suggestionView = NSBundle.mainBundle().loadNibNamed("EMOSuggestionView", owner: self, options: nil)![0] as! EMOSuggestionView
                suggestionView.bindWithSuggestion(EMODataManager.sharedInstance.suggestions[page])
                newPageView.addSubview(suggestionView)
                suggestionView.center = CGPoint(x: CGRectGetMidX(newPageView.bounds), y: CGRectGetMidY(newPageView.bounds))
                
                self.pageViews[page] = newPageView
            }
		}
	}
	
	func purgePage(page: Int) {
		if page < 0 || page >= pageControl.numberOfPages {
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
		for var index = lastPage+1; index < pageControl.numberOfPages; ++index {
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
