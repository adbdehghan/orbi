//
//  ChargeIndicatorViewController.swift
//  Orbi
//
//  Created by adb on 6/25/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import MKMagneticProgress




class ChargeIndicatorViewController: UIViewController {

    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var screenshotImageView: UIImageView!
    var magProgress:MKMagneticProgress!
    var titleLabel:UILabel!
    var descriptionLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
        SetBatteryStatus()
    }
    
    fileprivate func SetupUI() {
        backContainerView.layer.cornerRadius = backContainerView.frame.width/2
        screenshotImageView.image = BleSingleton.shared.screenshot
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
        
        magProgress = MKMagneticProgress()
        magProgress.frame = CGRect(x: self.view.frame.width/2-280, y: self.view.frame.height/2-110, width: 240, height: 240)
        magProgress.setProgress(progress: BleSingleton.shared.batteryPercentage/100, animated: true)
        magProgress.progressShapeColor = #colorLiteral(red: 1, green: 0.09101440758, blue: 0.6893740892, alpha: 1)
        magProgress.backgroundShapeColor = #colorLiteral(red: 0.3402546346, green: 0.345300138, blue: 0.6140657663, alpha: 1)
        magProgress.percentColor = UIColor.white
        magProgress.lineWidth = 45
        magProgress.orientation = .bottom
        magProgress.lineCap = .round
        magProgress.title = ""
        magProgress.percentLabelFormat = "%.0f%%"
        self.view.addSubview(magProgress)
        
        titleLabel = UILabel(frame: CGRect(x: magProgress.frame.origin.x+magProgress.frame.width+80, y: self.view.frame.height/2-80, width: 250, height: 60))
        titleLabel.textAlignment = .right
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        self.view.addSubview(titleLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: titleLabel.frame.origin.x-10, y: titleLabel.frame.origin.y+titleLabel.frame.height+10, width: 260, height: 80))
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .right
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        self.view.addSubview(descriptionLabel)
    }
    
    func SetBatteryStatus()
    {
        let time = CalculateEstimatedTime()
        let batteryPercentage = BleSingleton.shared.batteryPercentage
        
        if batteryPercentage >= 99 {
             titleLabel.text = "Full Battery"
            descriptionLabel.text = "You can drive \(time) minutes with this amount of battery."
        }
        else if batteryPercentage >= 70 && batteryPercentage < 99 {
            titleLabel.text = "Good Battery"
            descriptionLabel.text = "You can drive \(time) minutes with this amount of battery."
        }
        else if batteryPercentage >= 30 && batteryPercentage < 70{
            titleLabel.text = "Medium Battery"
            descriptionLabel.text = "You can drive \(time) minutes with this amount of battery."
        }
        else if batteryPercentage >= 15 && batteryPercentage < 30 {
            titleLabel.text = "Low Battery"
            descriptionLabel.text = "You can drive \(time) minutes with this amount of battery."
        }
        else if batteryPercentage >= 3 && batteryPercentage < 15 {
            titleLabel.text = "Very low Battery"
            descriptionLabel.text = "You can drive \(time) minutes with this amount of battery."
        }
        else {
            titleLabel.text = "Orbi is off"
            descriptionLabel.text = "To continue driving please charge your Orbi"
            magProgress.removeFromSuperview()
            let emptyImage = UIImageView(image: UIImage(named: "asset_charge"))
            emptyImage.frame = CGRect(x: self.view.frame.width/2-280, y: self.view.frame.height/2-110, width: 240, height: 240)
            emptyImage.contentMode = .scaleAspectFit
            self.view.addSubview(emptyImage)
        }
    }
    
    func CalculateEstimatedTime() -> String
    {
        let batteryPercentage = BleSingleton.shared.batteryPercentage
        
        let time = String(Int((batteryPercentage * 45)/100))
        
        return time
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        
       self.dismiss(animated: true, completion: nil)
    }
}
