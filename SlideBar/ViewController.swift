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
    @IBOutlet weak var myScrollView: UIScrollView!
    var currentScreenSize: CGSize = CGSize(width: ScreenSize.width, height: ScreenSize.height)
    var currentScrollIndex: CGFloat = 0.0
    let stringList = ["title1", "title2", "title3", "title4", "title512378"]
	var originScrollViewSize: CGSize?
    var framesScrollList = [CGRect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondSlideBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        setupScrollView(numberOfitems: stringList.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    @IBAction func changeValue(_ sender: SlideBarView) {
        myScrollView.scrollRectToVisible(framesScrollList[sender.currentIndex], animated: true)
        currentScrollIndex = CGFloat(sender.currentIndex)
    }
    
    
    // MARK: -------------------
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        relayoutDidTransition(size: currentScreenSize)
        myScrollView.scrollRectToVisible(framesScrollList[Int(currentScrollIndex)], animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        secondSlideBar.relayoutViewDidTransition(size: size)
        currentScreenSize = size
    }
    
    
    // MARK: -------------------
	func setupScrollView(numberOfitems: Int) {
		myScrollView.delegate = self
		myScrollView.bounces = false
		let screenSize: CGSize = UIScreen.main.bounds.size
		var xCoodinate: Int = 0
		for i in 0..<stringList.count {
			//
			let img = UIImage(named: "\(i + 1)")
			//
			let imgv = UIImageView(frame: CGRect(x: CGFloat(xCoodinate),
												 y: 0,
												 width: screenSize.width,
												 height: screenSize.height))
			imgv.isUserInteractionEnabled = true
			framesScrollList.append(imgv.frame)
			imgv.image = img
			//
			myScrollView.addSubview(imgv)
			xCoodinate += Int(screenSize.width)
		}
		//
		myScrollView.isPagingEnabled = true
		myScrollView.isScrollEnabled = true
		myScrollView.contentSize = CGSize(width: CGFloat(xCoodinate), height: myScrollView.bounds.size.height)
		//
		myScrollView.isUserInteractionEnabled = true
        myScrollView.backgroundColor = .green
        
        originScrollViewSize = myScrollView.bounds.size
	}
    
    func relayoutDidTransition(size: CGSize) {
        let subScrollViews = myScrollView.subviews.dropLast(2)
        myScrollView.contentSize = CGSize(width: size.width * CGFloat(subScrollViews.count),
                                          height: size.height - myScrollView.frame.origin.y)
        framesScrollList.removeAll()
        for index in 0..<myScrollView.subviews.count {
            
            let x = CGFloat(index) * size.width
            let y = myScrollView.bounds.minY
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
            myScrollView.subviews[index].frame = rect
            framesScrollList.append(rect)
        }
    }
}

extension ViewController: SlideBarViewDataSource {
    func titlesListSlideBar() -> [String] {
        return stringList
    }
}

extension ViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		secondSlideBar.moveLineConstantly(follow: scrollView)
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		currentScrollIndex = scrollView.contentOffset.x / currentScreenSize.width
//		secondSlideBar.moveBottomLine(to: Int(currentScrollIndex))
	}
}










struct ScreenSize {
    static let width         = UIScreen.main.bounds.size.width
    static let height        = UIScreen.main.bounds.size.height
    static let maxLength     = max(ScreenSize.width, ScreenSize.height)
    static let minLength     = min(ScreenSize.width, ScreenSize.height)
}
