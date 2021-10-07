//
//  ViewController.swift
//  collageTester
//
//  Created by Carlos Mayers on 10/6/21.
//

import UIKit
import BLTNBoard

class ViewController: UIViewController {
    
    private lazy var boardManager: BLTNItemManager = {
        let item = BLTNPageItem(title: "Push")
        item.image = UIImage(named: "ig")
        item.actionButtonTitle = "Continue"
        item.alternativeButtonTitle = "Later"
        item.descriptionText = "Would you like to stay?"
        
        item.actionHandler = { _ in
            ViewController.didTapBoardContinue()
        }
        item.alternativeHandler = { _ in
            ViewController.didTapBoardSkip()
        }
        
        return BLTNItemManager(rootItem: item)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
            button.backgroundColor = UIColor.systemRed
            button.setTitle("Test Button", for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.view.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
        boardManager.showBulletin(above: self)
    }
    
    static func didTapBoardContinue(){
        print("continued")
        
    }
    static func didTapBoardSkip(){
        print("skipped")
    }

}

