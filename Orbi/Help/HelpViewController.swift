//
//  HelpViewController.swift
//  Orbi
//
//  Created by adb on 6/30/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet var numberContainers: [UIView]!
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: formView.frame.height)
        
        for item in numberContainers {
            item.layer.cornerRadius = item.frame.width/2
        }
        
        self.scrollView.addSubview(formView)
        self.formView.translatesAutoresizingMaskIntoConstraints = true
        
        self.formView.leadingAnchor.constraint(equalTo:self.scrollView.leadingAnchor).isActive = true
        self.formView.trailingAnchor.constraint(equalTo:self.scrollView.trailingAnchor).isActive = true
        self.formView.topAnchor.constraint(equalTo:self.scrollView.topAnchor).isActive = true
        self.formView.bottomAnchor.constraint(equalTo:self.scrollView.bottomAnchor).isActive = true
        self.formView.widthAnchor.constraint(equalTo:self.view.widthAnchor).isActive = true
        self.scrollView.delaysContentTouches = false
        
        labelContainerView.layer.cornerRadius = 20
        backContainerView.layer.cornerRadius = backContainerView.frame.width / 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1680)
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
