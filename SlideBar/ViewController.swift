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
    let stringList = ["title1", "title2", "title2", "title2"]
	var portraitSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondSlideBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        setupView(numberOfitems: stringList.count)
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
    var framesScrollList = [CGRect]()
	func setupView(numberOfitems: Int) {
		myScrollView.delegate = self
		myScrollView.bounces = false
		let screenSize: CGSize = UIScreen.main.bounds.size
		var xCoodinate: Int = 0
		for i in 0..<stringList.count {
			//
			let img = UIImage(named: "\(i + 1)")
			//
			let imgv = UIImageView(frame: CGRect(x: CGFloat(xCoodinate), y: 0, width: screenSize.width, height: screenSize.height))
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
        
        portraitSize = myScrollView.bounds.size
	}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        relayoutWenTransition(size: currentScreenSize)
        myScrollView.scrollRectToVisible(framesScrollList[Int(currentScrollIndex)], animated: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        secondSlideBar.relayoutViewTransition(size: size)
        
        gettingCurrentScreenSize(size: size)
        
    }
    
    func relayoutWenTransition(size: CGSize) {
        myScrollView.contentSize = CGSize(width: size.width * CGFloat(stringList.count),
                                          height: size.height - myScrollView.frame.origin.y)
        framesScrollList.removeAll()
        for index in 0..<myScrollView.subviews.count {
            if UIDevice.current.orientation.isLandscape {
                let x = CGFloat(index) * size.width
                let y = myScrollView.bounds.minY
                // landscape
                myScrollView.subviews[index].frame = CGRect(x: CGFloat(index) * size.width,
                                                            y: myScrollView.bounds.minY,
                                                            width: size.width,
                                                            height: ScreenSize.minLength)
                framesScrollList.append(CGRect(x: CGFloat(index) * size.width,
                                               y: myScrollView.bounds.minY,
                                               width: size.width,
                                               height: ScreenSize.minLength))
            } else {
                // portrait
                if let uwrportaitSize = portraitSize {
                    myScrollView.subviews[index].frame = CGRect(x: CGFloat(index) * size.width,
                                                                y: myScrollView.bounds.minY,
                                                                width: size.width,
                                                                height: uwrportaitSize.height)
                    framesScrollList.append(CGRect(x: CGFloat(index) * size.width,
                                                   y: myScrollView.bounds.minY,
                                                   width: size.width,
                                                   height: uwrportaitSize.height))
                }
            }
        }
    }
    
    func gettingCurrentScreenSize(size: CGSize) {
        currentScreenSize = size
    }
}

extension ViewController: SlideBarViewDataSource {
    func numberOfItemsSlideBar() -> Int {
        return stringList.count
    }
    
    func titlesListSlideBar() -> [String] {
        return stringList
    }
}

extension ViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.panGestureRecognizer.state {
            // began: khi dùng tay kéo scrollview
            // changed: khi đang kéo rồi buông tay ra
            // possible: khi scrollview đang scroll dù đang dùng tay hay ko
            case .began:
                currentScrollIndex = round(scrollView.contentOffset.x / currentScreenSize.width)
            case .changed:
                currentScrollIndex = round(scrollView.contentOffset.x / currentScreenSize.width)
            case .possible: break
            default:
                currentScrollIndex = round(scrollView.contentOffset.x / currentScreenSize.width)
        }
        secondSlideBar.moveLine(follow: scrollView)
	}
}











struct ScreenSize {
    static let width         = UIScreen.main.bounds.size.width
    static let height        = UIScreen.main.bounds.size.height
    static let maxLength     = max(ScreenSize.width, ScreenSize.height)
    static let minLength     = min(ScreenSize.width, ScreenSize.height)
}
