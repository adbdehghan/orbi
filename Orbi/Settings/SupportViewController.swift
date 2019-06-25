//
//  SupportViewController.swift
//  Orbi
//
//  Created by adb on 6/25/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {

    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var updateContainerView: UIView!
    @IBOutlet weak var analyticsContainerView: UIView!
    @IBOutlet weak var callContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateContainerView.layer.cornerRadius = self.updateContainerView.frame.width/2
        self.analyticsContainerView.layer.cornerRadius = 18
        self.callContainerView.layer.cornerRadius = self.callContainerView.frame.width/2
        
        formView.frame = CGRect(x: 300, y: 15, width: self.view.frame.size.width - 230, height: formView.frame.height)
        
        self.scrollView.addSubview(formView)
        self.formView.translatesAutoresizingMaskIntoConstraints = true
        
        self.formView.leadingAnchor.constraint(equalTo:self.scrollView.leadingAnchor).isActive = true
        self.formView.trailingAnchor.constraint(equalTo:self.scrollView.trailingAnchor).isActive = true
        self.formView.topAnchor.constraint(equalTo:self.scrollView.topAnchor).isActive = true
        self.formView.bottomAnchor.constraint(equalTo:self.scrollView.bottomAnchor).isActive = true
        self.formView.widthAnchor.constraint(equalTo:self.view.widthAnchor).isActive = true
        self.scrollView.delaysContentTouches = false       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 440)
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
