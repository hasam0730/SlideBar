//
//  PageScrollView.swift
//  SlideBar
//
//  Created by Developer on 6/30/18.
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

protocol PageScrollViewDatasource: class {
	func registerPageViews() -> [UIViewController]
}

class PageScrollView: UIScrollView {
	weak var datasource: PageScrollViewDatasource?
	private var subVCList: [UIViewController]?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if subVCList == nil {
			subVCList = datasource?.registerPageViews()
			setupSubViews()
		} else {
			return
		}
		
	}
	
	private func setupSubViews() {
		
	}
	
	
}
