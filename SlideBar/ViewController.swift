//
//  ViewController.swift
//  SlideBar
//
//  Created by hieu nguyen on 6/26/18.
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var myScrollView: UIScrollView!
	@IBOutlet weak var slideView: UIView!
    let stringList = ["title1", "title2", "title3", "title4", "title5"]
    let colorsList = [UIColor.yellow, UIColor.red, UIColor.brown, UIColor.green, UIColor.cyan]
	var centerList = [CGPoint]()
	var frameList = [CGRect]()
	let bottomLine = UIView()
	var containerView: UIView!
	var isDragging: Bool = false
	let numberOfItems = 4
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addItemToView(numberItems: numberOfItems, to: slideView)
		setupView(numberOfitems: numberOfItems)
		
		print("🎯: \(ScreenSize.width)")
    }
	
    func addItemToView(numberItems: Int, to subview: UIView) {
        containerView = UIView(frame: subview.frame)
        containerView.backgroundColor = UIColor.brown
        let widthItem = view.bounds.width/CGFloat(numberItems)
		let heightItem: CGFloat = 100.0
        for i in 0..<numberItems {
            let lblTitle = UIButton(frame: CGRect(x: CGFloat(i) * widthItem, y: 0, width: widthItem, height: subview.frame.size.height))
			centerList.append(lblTitle.center)
			frameList.append(lblTitle.frame)
            print("🎅:---\(lblTitle.frame)")
            lblTitle.backgroundColor = colorsList[i]
            lblTitle.tag = i
            
            lblTitle.addTarget(self, action: #selector(self.dosomething(_:)), for: .touchUpInside)
			
            containerView.isUserInteractionEnabled = true
			
            lblTitle.setTitle(stringList[i], for: .normal)
			
            subview.addSubview(lblTitle)
			
//			lblTitle.bringSubview(toFront: containerView)
			

            view.isUserInteractionEnabled = true
            print("🧙‍♀️:---\(lblTitle.frame)")
        }
//		subview.addSubview(containerView)
		// add bottom line
		bottomLine.frame = CGRect(x: frameList.first!.minX, y: frameList.first!.maxY-5.0, width: frameList.first!.size.width, height: 5.0)
		bottomLine.backgroundColor = UIColor.darkText
		subview.addSubview(bottomLine)
    }
    
    @objc func dosomething(_ sender: UIButton) {
		isDragging = false
		animateBottomLine(to: sender.tag)
		myScrollView.scrollRectToVisible(framesScrollList[sender.tag], animated: true)
    }
	
	func animateBottomLine(to index: Int) {
		UIView.animate(withDuration: 0.3) {
			self.bottomLine.center.x = self.centerList[index].x
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	var framesScrollList = [CGRect]()
	//  Converted to Swift 4 by Swiftify v4.1.6751 - https://objectivec2swift.com/
	func setupView(numberOfitems: Int) {
		myScrollView.delegate = self
		myScrollView.bounces = false
		let screenSize: CGSize = UIScreen.main.bounds.size
		var xCoodinate: Int = 0
		for i in 0..<numberOfitems {
			//
			let img = UIImage(named: "\(i + 1)")
			//
			let imgv = UIImageView(frame: CGRect(x: CGFloat(xCoodinate), y: 0, width: screenSize.width, height: screenSize.height-200))
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
		myScrollView.contentSize = CGSize(width: CGFloat(xCoodinate), height: screenSize.height-200)
		//
		myScrollView.isUserInteractionEnabled = true
	}
	
	func dosomethinsg(bien: CGFloat) {
		if isDragging == true {
			bottomLine.frame.origin.x = bien
		}
	}
}

extension ViewController: UIScrollViewDelegate {
	
	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		isDragging = true
		print("😃 scrollViewWillBeginDecelerating \(scrollView.contentOffset)")
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		isDragging = true
		print("😃 scrollViewWillBeginDragging \(scrollView.contentOffset)")
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		print("😃 scrollViewDidScroll \(scrollView.contentOffset.x/8)")
		dosomethinsg(bien: scrollView.contentOffset.x/CGFloat(numberOfItems))
	}
}

struct ScreenSize {
    static let width         = UIScreen.main.bounds.size.width
    static let height        = UIScreen.main.bounds.size.height
    static let maxLength     = max(ScreenSize.width, ScreenSize.height)
    static let minLength     = min(ScreenSize.width, ScreenSize.height)
}
