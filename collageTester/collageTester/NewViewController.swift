//
//  NewViewController.swift
//  collageTester
//
//  Created by Carlos Mayers on 10/6/21.
//

import UIKit
import FittedSheets

class NewViewController: UIViewController {
    
    @IBOutlet weak var chooseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
            button.backgroundColor = UIColor.systemRed
            button.setTitle("Test Button", for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.view.addSubview(button)

        // Do any additional setup after loading the view.
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        let optionVC = OptionTableViewController(style: .grouped)
        optionVC.didSelectedOption { (selectedOption) in
            self.chooseButton.setTitle(selectedOption, for: .normal)
        }
        
        let sheetController = SheetViewController(controller: optionVC)
        //sheetController.hasBlurBackground = true
        //sheetController.overlayColor = UIColor.gray.withAlphaComponent(0.2)
        sheetController.cornerRadius = 25
        
        self.present(sheetController, animated: false, completion: {})
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
