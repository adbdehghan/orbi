//
//  ChargeIndicatorViewController.swift
//  Orbi
//
//  Created by adb on 6/25/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import MKMagneticProgress

var magProgress:MKMagneticProgress!

class ChargeIndicatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        magProgress = MKMagneticProgress()
        magProgress.frame = CGRect(x: self.view.frame.width/2-250, y: self.view.frame.height/2-100, width: 200, height: 200)
        magProgress.setProgress(progress: BleSingleton.shared.batteryPercentage, animated: true)
        magProgress.progressShapeColor = #colorLiteral(red: 1, green: 0.09101440758, blue: 0.6893740892, alpha: 1)
        magProgress.backgroundShapeColor = #colorLiteral(red: 0.3402546346, green: 0.345300138, blue: 0.6140657663, alpha: 1)
//        magProgress.titleColor = UIColor.red
        magProgress.percentColor = UIColor.white
        
        magProgress.lineWidth = 50
        magProgress.orientation = .bottom
        magProgress.lineCap = .round
        
        magProgress.title = ""
        magProgress.percentLabelFormat = "%.0f%%"
        
        self.view.addSubview(magProgress)
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
