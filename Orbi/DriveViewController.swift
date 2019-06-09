//
//  DriveViewController.swift
//  Orbi
//
//  Created by adb on 6/9/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import CDJoystick

class DriveViewController: UIViewController {
    
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var BatteryContainerView: UIView!
    @IBOutlet weak var SettingContainerView: UIView!
    @IBOutlet weak var CalibrateContainerView: UIView!
    @IBOutlet weak var BrakeMainContainerView: UIView!
    @IBOutlet weak var BrakeWhiteContainerView: UIView!
    @IBOutlet weak var ActionsContainerView: UIView!
    @IBOutlet weak var joystick: CDJoystick!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backContainerView.layer.cornerRadius = backContainerView.frame.width / 2
        BatteryContainerView.layer.cornerRadius = BatteryContainerView.frame.width / 2
        SettingContainerView.layer.cornerRadius = SettingContainerView.frame.width / 2
        CalibrateContainerView.layer.cornerRadius = CalibrateContainerView.frame.width / 2
        
        BrakeMainContainerView.layer.cornerRadius = 47
        BrakeWhiteContainerView.layer.cornerRadius = 42
        BrakeWhiteContainerView.layer.borderWidth = 5
        BrakeWhiteContainerView.layer.borderColor = #colorLiteral(red: 0.8142766356, green: 0.8644046187, blue: 0.9404509068, alpha: 1)
        
        ActionsContainerView.layer.cornerRadius = 47
        
        
        joystick.trackingHandler = { joystickData in
//            self.objectView.center.x += joystickData.velocity.x
//            self.objectView.center.y += joystickData.velocity.y
        }
        
    }
 
    @IBAction func BackButtonAction(_ sender: Any) {
        
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
