//
//  DriveViewController.swift
//  Orbi
//
//  Created by adb on 6/9/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import JoystickView

class DriveViewController: UIViewController {
    
//    @IBOutlet weak var joystick: JoystickView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        joystick.delegate = self
//        joystick.form = .around
//        joystick.joystickBg = UIView()
//        joystick.joystickThumb = UIView()
    }
    func joystickView(_ joystickView: JoystickView, didMoveto x: Float, y: Float, direction: JoystickMoveDriection) {
        
    }
    
    func joystickViewDidEndMoving(_ joystickView: JoystickView) {
        
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
