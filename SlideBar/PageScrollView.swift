//
//  PageScrollView.swift
//  SlideBar
//
//  Created by Hasam
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

protocol PageScrollViewDatasource: class {
	func numberOfSubView() -> Int
	func viewForPage(at index: Int) -> UIView
}

class PageScrollView: UIScrollView {
	weak var datasource: PageScrollViewDatasource?
	private var framesScrollList = [CGRect]()
	private var currentScrollIndex: Int = 0
	private var numbOfPageViews: Int?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if numbOfPageViews == nil {
			numbOfPageViews = datasource?.numberOfSubView()
			setupSubViews()
		} else {
			return
		}
	}
	
	private func setupSubViews() {
		self.bounces = false
		framesScrollList.removeAll()
		let screenSize: CGSize = UIScreen.main.bounds.size
		var xCoodinate: Int = 0
		for indx in 0..<numbOfPageViews! {
			guard let subView = datasource?.viewForPage(at: indx) else { fatalError("‼️ Init view fail") }
			subView.frame = CGRect(x: CGFloat(xCoodinate), y: 0, width: screenSize.width, height: screenSize.height-frame.origin.y)
			//
			self.addSubview(subView)
			framesScrollList.append(subView.frame)
			xCoodinate += Int(screenSize.width)
		}
		//
		self.isPagingEnabled = true
		self.isScrollEnabled = true
		self.contentSize = CGSize(width: CGFloat(xCoodinate), height: self.bounds.size.height)
		//
		self.isUserInteractionEnabled = true
		self.backgroundColor = .green
	}

	func relayoutDidTransition(size: CGSize) {
		let subScrollViews = self.subviews.dropLast(2)
		self.contentSize = CGSize(width: size.width * CGFloat(subScrollViews.count),
										  height: size.height - self.frame.minY - 20)
		framesScrollList.removeAll()
		for index in 0..<self.subviews.count {

			let x = CGFloat(index) * size.width
			let y = self.bounds.minY
			 let w = size.width
			var h: CGFloat = 0.0

			if UIDevice.current.orientation.isLandscape {
				// landscape
				h = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
			} else {
				// portrait
				h = self.contentSize.height
			}
			let rect = CGRect(x: x, y: y, width: w, height: h)
			self.subviews[index].frame = rect
			framesScrollList.append(rect)
		}
	}
	
	func scrollTo(index: Int) {
		if framesScrollList.count == 0 {
			return
		}
		self.scrollRectToVisible(framesScrollList[index], animated: true)
	}
}

//usage:
//MARK: adjust rect visible of scroll view when rotate screen
//override func viewDidLayoutSubviews() {
//	super.viewDidLayoutSubviews()
//
//	myScrollView.scrollTo(index: Int(currentScrollIndex))
//}

//MARK: adjust content size of scroll view when rotate screen
//override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//	secondSlideBar.relayoutViewDidTransition(size: size)
//	myScrollView.relayoutDidTransition(size: size)
//
//	currentScreenSize = size
//}
