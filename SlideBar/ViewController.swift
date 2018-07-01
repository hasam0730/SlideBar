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
	
    var currentScreenSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    let stringList = ["title1", "title2", "title3", "title4", "title512378"]
	var currentScrollIndex: Int = 0
	let arr = [UIColor.black, UIColor.blue, UIColor.yellow, UIColor.cyan, UIColor.green, UIColor.orange]
	
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
	func viewForPage(at index: Int) -> UIView {
		let view = UIView()
		view.backgroundColor = arr[index]
		return view
	}
	
	func numberOfSubView() -> Int {
		return stringList.count
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		secondSlideBar.scrollToMoveBottomLine(by: scrollView)
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		currentScrollIndex = Int(scrollView.contentOffset.x / currentScreenSize.width)
		secondSlideBar.scrollToMoveBottomLine(by: scrollView, to: currentScrollIndex)
	}
}
