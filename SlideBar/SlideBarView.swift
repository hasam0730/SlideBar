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
    private var frameList = [CGRect]()
    private let bottomLine = UIView()
    private var isDragging: Bool = false
    private(set) var currentBtnIndex: Int = 0
    
    
    weak var delegate: SlideBarViewDataSource?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.brown
        let widthItem = self.bounds.width/CGFloat(numberOfItems!)
        
        for i in 0..<numberOfItems! {
            colorsList.append(getRandomColor())
            
            let lblTitle = UIButton(frame: CGRect(x: CGFloat(i) * widthItem, y: 0, width: widthItem, height: self.frame.size.height))
            centerList.append(lblTitle.center)
            frameList.append(lblTitle.frame)

            lblTitle.backgroundColor = colorsList[i]
            lblTitle.tag = i
            
            lblTitle.addTarget(self, action: #selector(self.didTapSlideBarItem(_:)), for: .touchUpInside)
            
            lblTitle.setTitle(titlesList![i], for: .normal)
            
            self.addSubview(lblTitle)
        }
        
        // add bottom line
        bottomLine.frame = CGRect(x: frameList.first!.minX,
                                  y: frameList.first!.maxY-lineHeight,
                                  width: frameList.first!.size.width,
                                  height: lineHeight)
        bottomLine.backgroundColor = lineColor
        self.addSubview(bottomLine)
    }
    
    @objc func didTapSlideBarItem(_ sender: UIButton) {
        currentBtnIndex = sender.tag
        isDragging = false
        animateBottomLine(to: sender.tag)
        sendActions(for: .valueChanged)
    }
    
    func animateBottomLine(to index: Int) {
        UIView.animate(withDuration: 0.3) {
            self.bottomLine.center.x = self.centerList[index].x
        }
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        titlesList = delegate?.titlesListSlideBar()
        numberOfItems = delegate?.numberOfItemsSlideBar()
        
        if titlesList == nil && numberOfItems == nil {
            return
        }
        setupView()
    }
}
