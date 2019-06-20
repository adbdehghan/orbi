//
//  SettingsViewController.swift
//  Orbi
//
//  Created by adb on 6/13/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import SummerSlider

class SettingsViewController: UIViewController {

    @IBOutlet weak var SpeedContainerView: UIView!
    @IBOutlet weak var SpeedSlider: SummerSlider!
    @IBOutlet weak var SensivityContainerView: UIView!
    @IBOutlet weak var SensivitySlider: SummerSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.revealMenu()
        SpeedContainerView.layer.cornerRadius = 20
        SensivityContainerView.layer.cornerRadius = 20
        SpeedSlider.layer.cornerRadius = 20
        
        var sampleArray = Array<Float>()
        sampleArray = [0,7,14,21,28,35,42,49,56,63,70,77,84,91]
        SpeedSlider.markColor = #colorLiteral(red: 0.3605898917, green: 0.3404306173, blue: 0.6947399378, alpha: 1)
        SpeedSlider.markWidth = 2.0
        SpeedSlider.markPositions = sampleArray
        SpeedSlider.value = 0.85
        self.SpeedSlider.setThumbImage(UIImage(named: "slider-thumb")!, for: .normal)
        self.SpeedSlider.gradientColors = [#colorLiteral(red: 1, green: 1, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.4039215686, blue: 0, alpha: 1)]
        
        
        var sensivityArray = Array<Float>()
        sensivityArray = [0,7,14,21,28,35,42,49,56,63,70,77,84,91]
        SensivitySlider.markColor = #colorLiteral(red: 0.3605898917, green: 0.3404306173, blue: 0.6947399378, alpha: 1)
        SensivitySlider.markWidth = 2.0
        SensivitySlider.markPositions = sensivityArray
        SensivitySlider.value = 0.4
        self.SensivitySlider.setThumbImage(UIImage(named: "slider-thumb")!, for: .normal)
        self.SensivitySlider.gradientColors = [#colorLiteral(red: 0, green: 0.8823529412, blue: 1, alpha: 1),#colorLiteral(red: 0.9176470588, green: 0, blue: 1, alpha: 1)]
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
