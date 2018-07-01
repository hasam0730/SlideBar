//
//  ViewController.swift
//  SlideBar
//
//  Created by hieu nguyen on 6/26/18.
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var secondSlideBar: SlideBarView!
    @IBOutlet weak var myScrollView: PageScrollView!
    var currentScreenSize: CGSize = CGSize(width: ScreenSize.width, height: ScreenSize.height)
    let stringList = ["title1", "title2", "title3", "title4", "title512378"]
	var currentScrollIndex: Int = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        secondSlideBar.datasource = self
		secondSlideBar.delegate = self
		
		myScrollView.datasource = self
		myScrollView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -------------------
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

		myScrollView.scrollTo(index: Int(currentScrollIndex))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        secondSlideBar.relayoutViewDidTransition(size: size)
		myScrollView.relayoutDidTransition(size: size)
		
        currentScreenSize = size
    }
}

extension ViewController: SlideBarViewDataSource, SlideBarViewDelegate {
	func didSelectSlideBar(at index: Int) {
		currentScrollIndex = index
		myScrollView.scrollTo(index: index)
	}
	
    func titlesListSlideBar() -> [String] {
        return stringList
    }
}

extension ViewController: UIScrollViewDelegate, PageScrollViewDatasource {
	func numberOfSubView() -> Int {
		return 0
	}
	
	func viewForPage() -> UIView {
		return UIView()
	}
	
	func registerPageViews() -> [UIImageView] {
		return [UIImageView(image: UIImage(named: "1")),
				UIImageView(image: UIImage(named: "2")),
				UIImageView(image: UIImage(named: "3")),
				UIImageView(image: UIImage(named: "4")),
				UIImageView(image: UIImage(named: "5"))]
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		secondSlideBar.moveLineConstantly(follow: scrollView)
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		currentScrollIndex = Int(scrollView.contentOffset.x / currentScreenSize.width)
		secondSlideBar.moveBottomLine(to: Int(currentScrollIndex))
	}
}










struct ScreenSize {
    static let width         = UIScreen.main.bounds.size.width
    static let height        = UIScreen.main.bounds.size.height
    static let maxLength     = max(ScreenSize.width, ScreenSize.height)
    static let minLength     = min(ScreenSize.width, ScreenSize.height)
}
