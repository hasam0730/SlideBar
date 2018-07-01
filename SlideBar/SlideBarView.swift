//
//  SlideBarView.swift
//  SlideBar
//
//  Created by Hasam
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

protocol SlideBarViewDataSource: class {
    func titlesListSlideBar() -> [String]
}

protocol SlideBarViewDelegate: class {
	func didSelectSlideBar(at index: Int)
}

@IBDesignable
class SlideBarView: UIControl {

    @IBInspectable private var lineHeight: CGFloat = 1.0
    @IBInspectable private var lineColor: UIColor = UIColor.gray
    @IBInspectable private var isEqualWidth: Bool = false
	@IBInspectable private var horizontalPadding: CGFloat = 0.0
	
    private var titlesList: [String]?
    private var numberOfItems: Int?
    private var latestScreenSize: CGSize = UIScreen.main.bounds.size
    private var colorsList = [UIColor]()
    private let bottomLine = UIView()
    private var isDragging: Bool = false
	private var currentIndex: Int = 0
    private var itemsList = [UIButton]()
	private let animateDuration = 0.3
	
    weak var datasource: SlideBarViewDataSource?
	weak var delegate: SlideBarViewDelegate?
	
	private func initData() {
		titlesList = datasource?.titlesListSlideBar()
		numberOfItems = titlesList?.count
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if titlesList == nil || numberOfItems == nil {
			initData()
			setupItemView()
		}
	}
    
    private func getRandomColor() -> UIColor {
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }

    // setting up views of items
    private func setupItemView() {
        for indx in 0..<numberOfItems! {
            colorsList.append(getRandomColor())
            
			let btn = UIButton()
			btn.frame = frame(of: btn, at: indx)

            btn.backgroundColor = colorsList[indx]
            btn.tag = indx
            
            btn.addTarget(self, action: #selector(self.didTapSlideBarItem(_:)), for: .touchUpInside)
            
            btn.setTitle(titlesList![indx], for: .normal)
            
            self.addSubview(btn)
			itemsList.append(btn)
        }
        
        // add bottom line
        bottomLine.frame = CGRect(x: itemsList.first!.frame.minX,
                                  y: itemsList.first!.frame.maxY-lineHeight,
                                  width: itemsList.first!.frame.size.width,
                                  height: lineHeight)
        
        bottomLine.backgroundColor = lineColor
        
        self.addSubview(bottomLine)
    }
	
	private func frame(of button: UIButton, at index: Int) -> CGRect {
		let widthItem = self.bounds.width/CGFloat(numberOfItems!)
		if isEqualWidth {
			return CGRect(x: CGFloat(index) * widthItem, y: 0, width: widthItem, height: self.frame.size.height)
		} else {
			let fontAttributes: [NSAttributedStringKey: UIFont] = [NSAttributedStringKey.font: button.titleLabel!.font]
			let widthText = titlesList![index].size(withAttributes: fontAttributes).width
			
			var xItem: CGFloat = 0.0
			if index > 0 {
				xItem = itemsList[index-1].frame.width + itemsList[index-1].frame.minX
			}
			
			if (xItem + widthText + horizontalPadding) > UIScreen.main.bounds.width {
				fatalError("❗️❗️❗️The length of the string exceeds the screen")
			}
			
			return CGRect(origin: CGPoint(x: xItem, y: 0.0), size: CGSize(width: widthText + horizontalPadding, height: self.bounds.height))
		}
	}
    
    // fired when did tap slide bar item
    @objc private func didTapSlideBarItem(_ sender: UIButton) {
        currentIndex = sender.tag
        isDragging = false
        animateBottomLine(to: sender.tag)
        // sendActions(for: .valueChanged)
		delegate?.didSelectSlideBar(at: currentIndex)
    }
    
    // move bottom line when tap slidebar item (button)
    private func animateBottomLine(to index: Int) {
        UIView.animate(withDuration: animateDuration) {
            self.bottomLine.frame.origin.x = self.itemsList[index].frame.minX
			self.bottomLine.frame.size.width = self.itemsList[Int(index)].frame.width
        }
    }
    
    // move bottom line when scroll view in main view is scrolling
    // fired in "scrollViewDidScroll" function in UIScrollViewDelegate
	public func moveLineConstantly(follow scrollView: UIScrollView) {
		if isEqualWidth == true {
			if scrollView.panGestureRecognizer.state != .possible {
				isDragging = true
			}
			if isDragging == true {
				bottomLine.frame.origin.x = scrollView.contentOffset.x / CGFloat(numberOfItems!)
				currentIndex = Int(scrollView.contentOffset.x / latestScreenSize.width)
			}
		} else {
			fatalError("‼️Only use this function in EqualWidth mode. Set isEqualWidth in attribute inspector to 'Off' or use function 'moveBottomLine(to index: Int)' instead")
		}
    }
	
	public func moveBottomLine(to index: Int) {
		currentIndex = index
		animateBottomLine(to: index)
	}
	
    // relayout after implementing rotate iphone ("viewWillTransition")
    public func relayoutViewDidTransition(size: CGSize) {
		latestScreenSize = size
        // size: size man hinh moi khi rotate
        let itemWidth = size.width / CGFloat(numberOfItems!)

        for indx in 0..<numberOfItems! {

			var itemFrame: CGRect!
			if isEqualWidth {
				itemFrame = CGRect(x: CGFloat(indx) * (size.width / CGFloat(numberOfItems!)),
								   y: self.bounds.minY,
								   width: itemWidth,
								   height: self.subviews[indx].frame.height)
			} else {
				var xItem: CGFloat = 0.0
				if indx > 0 {
					xItem = itemsList[indx-1].frame.width + itemsList[indx-1].frame.minX
				}
				itemFrame = CGRect(x: xItem,
								   y: self.bounds.minY,
								   width: itemsList[indx].frame.width,
								   height: self.subviews[indx].frame.height)
			}
			
            self.subviews[indx].frame = itemFrame
        }
        
        bottomLine.frame = CGRect(x: itemsList[currentIndex].frame.minX,
                                  y: itemsList[currentIndex].frame.maxY-lineHeight,
                                  width: itemsList[currentIndex].frame.width,
                                  height: lineHeight)
    }
	
	
}



//usage:
//extension ViewController: UIScrollViewDelegate {
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		secondSlideBar.moveLineConstantly(follow: scrollView)
//
//	}
//	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//		let currentScrollIndex = scrollView.contentOffset.x / currentScreenSize.width
//		secondSlideBar.moveBottomLine(to: Int(currentScrollIndex))
//	}
//}
