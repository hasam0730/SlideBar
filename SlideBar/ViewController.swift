//
//  ViewController.swift
//  SlideBar
//
//  Created by hieu nguyen on 6/26/18.
//  Copyright © 2018 hieu nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slideView: UIView!
    let stringList = ["title1", "title2", "title3", "title4", "title5"]
    let colorsList = [UIColor.yellow, UIColor.red, UIColor.brown, UIColor.green, UIColor.cyan]
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        addItemToView(numberItems: 5, to: slideView)
//
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//        button.backgroundColor = .green
//        button.setTitle("Test Button", for: .normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//
//        self.view.addSubview(button)
//
//    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    func addItemToView(numberItems: Int, to subview: UIView) {
        let widthItem = slideView.bounds.width/CGFloat(numberItems)
        let heightItem = slideView.bounds.height
        for i in 0..<5 {
            let lblTitle = UIButton(frame: CGRect(x: CGFloat(i) * widthItem, y: widthItem, width: widthItem, height: heightItem))
            print("🎅:---\(lblTitle.frame)")
            lblTitle.backgroundColor = colorsList[i]
            lblTitle.tag = i
            
            lblTitle.addTarget(self, action: #selector(self.dosomething(_:)), for: .touchUpInside)
            subview.isUserInteractionEnabled = true
            lblTitle.setTitle(stringList[i], for: .normal)
            
            subview.addSubview(lblTitle)
            
            print("🧙‍♀️:---\(lblTitle.frame)")
        }
    }
    
    @objc func dosomething(_ sender: UIButton) {
        print(sender.tag)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "My App"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sendMailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Mail", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(handleSendMail), for: .touchUpInside)
        return button
    }()
    
    let myImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.brown
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true    // here activate the interaction needed
        image.image = UIImage(imageLiteralResourceName: "backgroundSE")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myImage.frame = UIScreen.main.bounds

        sendMailButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)

        view.addSubview(myImage)
        myImage.addSubview(sendMailButton)
        myImage.addSubview(textLabel)

//        setupLayouts()

    }
    
    func setupLayouts() {
        
    }
    
    @objc func handleSendMail() {
        print("Mail Sended")
    }

}

struct ScreenSize {
    static let width         = UIScreen.main.bounds.size.width
    static let height        = UIScreen.main.bounds.size.height
    static let maxLength     = max(ScreenSize.width, ScreenSize.height)
    static let minLength     = min(ScreenSize.width, ScreenSize.height)
}
