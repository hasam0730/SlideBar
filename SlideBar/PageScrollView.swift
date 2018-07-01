//
//  PageScrollView.swift
//  SlideBar
//
//  Created by Hasam
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

protocol PageScrollViewDatasource: class {
	func registerPageViews() -> [UIImageView]
	func numberOfSubView() -> Int
	func viewForPage() -> UIView
}

class PageScrollView: UIScrollView {
	weak var datasource: PageScrollViewDatasource?
	private var subVCList: [UIImageView]?
	var framesScrollList = [CGRect]()
	var currentScrollIndex: Int = 0
	var originScrollViewSize: CGSize?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if subVCList == nil {
			subVCList = datasource?.registerPageViews()
			setupSubViews()
		} else {
			return
		}
	}
	
	func setupSubViews() {
		self.bounces = false
		framesScrollList.removeAll()
		let screenSize: CGSize = UIScreen.main.bounds.size
		var xCoodinate: Int = 0
		for i in 0..<subVCList!.count {
			let imgv = subVCList![i]
			imgv.frame = CGRect(x: CGFloat(xCoodinate), y: 0, width: screenSize.width, height: screenSize.height)
			//
			self.addSubview(imgv)
			framesScrollList.append(imgv.frame)
			xCoodinate += Int(screenSize.width)
		}
		//
		self.isPagingEnabled = true
		self.isScrollEnabled = true
		self.contentSize = CGSize(width: CGFloat(xCoodinate), height: self.bounds.size.height)
		//
		self.isUserInteractionEnabled = true
		self.backgroundColor = .green

		originScrollViewSize = self.bounds.size
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
				h = ScreenSize.minLength
			} else {
				// portrait
				if let uwrOriginSize = originScrollViewSize {
					h = uwrOriginSize.height
				}
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
