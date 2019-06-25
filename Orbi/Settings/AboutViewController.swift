//
//  AboutViewController.swift
//  Orbi
//
//  Created by adb on 6/23/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var moreInfoButtonContainerView: UIView!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moreInfoButtonContainerView.layer.cornerRadius = 28
        moreInfoButton.layer.cornerRadius = 25
        moreInfoButton.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.862745098, blue: 0.9333333333, alpha: 1)
        moreInfoButton.layer.borderWidth = 4
        
        formView.frame = CGRect(x: 280, y: 0, width: self.view.frame.size.width - 310, height: formView.frame.height)
        self.view.addSubview(formView)
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
