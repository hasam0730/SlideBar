//
//  SlideBarView.swift
//  SlideBar
//
//  Created by hieu nguyen on 6/28/18.
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

protocol SlideBarViewDataSource: class {
    func numberOfItemsSlideBar() -> Int
    func titlesListSlideBar() -> [String]
}

@IBDesignable
class SlideBarView: UIControl {

    @IBInspectable private var lineHeight: CGFloat = 1.0
    @IBInspectable private var lineColor: UIColor = UIColor.gray
    @IBInspectable private var isEqualWidth: Bool = false
	@IBInspectable private var horizontalPadding: CGFloat = 0.0
	
    private var titlesList: [String]? = [String]()
    private var numberOfItems: Int? = 0
    
    private var colorsList = [UIColor]()
    private let bottomLine = UIView()
    private var isDragging: Bool = false
	private(set) var currentIndex: Int = 0 {
		didSet {
			print("❇️ \(currentIndex)")
		}
	}
    private var itemsList = [UIButton]()
	private let animateDuration = 0.28
    weak var delegate: SlideBarViewDataSource?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        sendActions(for: .valueChanged)
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
	func moveLine(follow scrollView: UIScrollView, at index: CGFloat) {
		currentIndex = Int(index)
        switch scrollView.panGestureRecognizer.state {
        // began: khi dùng tay kéo scrollview
        // changed: khi đang kéo rồi buông tay ra
        // possible: khi scrollview đang scroll dù đang dùng tay hay ko
            // case .began:    isDragging = true
            // case .changed:  isDragging = true
            case .possible: break
            default:        isDragging = true
        }
        
        if isDragging == true {
			frameBottomLine(at: Int(index), on: scrollView)
        }
    }
	
	private func frameBottomLine(at index: Int, on scrollView: UIScrollView) {
		if isEqualWidth {
			bottomLine.frame.origin.x = scrollView.contentOffset.x / CGFloat(numberOfItems!)
		} else {
			animateBottomLine(to: index)
		}
	}
	
    // relayout after implementing rotate iphone screen (in "viewWillTransition" function)
    func relayoutViewDidTransition(size: CGSize) {
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
    
    private func initData() {
        titlesList = delegate?.titlesListSlideBar()
        numberOfItems = delegate?.numberOfItemsSlideBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        initData()
        
        if titlesList == nil && numberOfItems == nil {
            return
        } else if itemsList.count == 0 {
            setupItemView()
        }
    }
}
