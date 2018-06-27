//
//  File.swift
//  SlideBar
//
//  Created by Developer on 6/27/18.
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	func addConstraintsWithFormat(format: String, views:UIView...) {
		var viewsDictionary = [String:UIView]()
		for(index, view) in views.enumerated() {
			let key = "v\(index)"
			viewsDictionary[key] = view
			view.translatesAutoresizingMaskIntoConstraints = false
		}
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
													  options: NSLayoutFormatOptions(),
													  metrics: nil,
													  views: viewsDictionary))
	}
}
