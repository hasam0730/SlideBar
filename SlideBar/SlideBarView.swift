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
    
    private var titlesList: [String]? = [String]()
    private var numberOfItems: Int? = 0
    
    private var colorsList = [UIColor]()
    private var centerList = [CGPoint]()
    private var framesList = [CGRect]()
    private let bottomLine = UIView()
    private var isDragging: Bool = false
    private(set) var currentIndex: Int = 0
    
    private var btnsList = [UIButton]()
    weak var delegate: SlideBarViewDataSource?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func getRandomColor() -> UIColor {
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // setting up views of items
    private func setupItemView() {
        self.backgroundColor = UIColor.brown
        let widthItem = self.bounds.width/CGFloat(numberOfItems!)
        
        for indx in 0..<numberOfItems! {
            colorsList.append(getRandomColor())
            
            let btn = UIButton(frame: CGRect(x: CGFloat(indx) * widthItem, y: 0, width: widthItem, height: self.frame.size.height))
            centerList.append(btn.center)
            framesList.append(btn.frame)

            btn.backgroundColor = colorsList[indx]
            btn.tag = indx
            
            btn.addTarget(self, action: #selector(self.didTapSlideBarItem(_:)), for: .touchUpInside)
            
            btn.setTitle(titlesList![indx], for: .normal)
            
            self.addSubview(btn)
            btnsList.append(btn)
        }
        
        // add bottom line
        bottomLine.frame = CGRect(x: framesList.first!.minX,
                                  y: framesList.first!.maxY-lineHeight,
                                  width: framesList.first!.size.width,
                                  height: lineHeight)
        
        bottomLine.backgroundColor = lineColor
        
        self.addSubview(bottomLine)
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
        UIView.animate(withDuration: 0.3) {
            self.bottomLine.center.x = self.centerList[index].x
        }
    }
    
    // move bottom line when scroll view in main view is scrolling
    // fired in "scrollViewDidScroll" function in UIScrollViewDelegate
    func moveLine(follow scrollView: UIScrollView) {
        switch scrollView.panGestureRecognizer.state {
        // began: khi dùng tay kéo scrollview
        // changed: khi đang kéo rồi buông tay ra
        // possible: khi scrollview đang scroll dù đang dùng tay hay ko
            case .began:    isDragging = true
            case .changed:  isDragging = true
            case .possible: break
            default:        isDragging = true
        }
        
        if isDragging == true {
            bottomLine.frame.origin.x = scrollView.contentOffset.x/CGFloat(numberOfItems!)
        }
    }
    
    // relayout after implementing rotate iphone screen (in "viewWillTransition" function)
    func relayoutViewDidTransition(size: CGSize) {
        // size: size man hinh moi khi rotate
        let itemWidth = size.width / CGFloat(numberOfItems!)
        centerList.removeAll()
        for indx in 0..<self.subviews.count {
            let xItem = CGFloat(indx) * (size.width / CGFloat(numberOfItems!))
            let yItem = self.bounds.minY
            let widthItem = itemWidth
            let heightItem = self.subviews[indx].frame.height
            
            self.subviews[indx].frame = CGRect(x: xItem, y: yItem, width: widthItem, height: heightItem)
            
            centerList.append(self.subviews[indx].center)
        }
        
        bottomLine.frame = CGRect(x: CGFloat(currentIndex) * itemWidth,
                                  y: framesList[currentIndex].maxY-lineHeight,
                                  width: itemWidth,
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
        } else if btnsList.count == 0 {
            setupItemView()
        }
    }
}
