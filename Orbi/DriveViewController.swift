//
//  DriveViewController.swift
//  Orbi
//
//  Created by adb on 6/9/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import CDJoystick
import BatteryView
import Haptico
import GradientProgress
import Bluetonium

class DriveViewController: UIViewController,ManagerDelegate  {
    
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var BatteryContainerView: UIView!
    @IBOutlet weak var SettingContainerView: UIView!
    @IBOutlet weak var CalibrateContainerView: UIView!
    @IBOutlet weak var BrakeMainContainerView: UIView!
    @IBOutlet weak var BrakeWhiteContainerView: UIView!
    @IBOutlet weak var ActionsContainerView: UIView!
    @IBOutlet weak var NitroContainerView: UIView!
    @IBOutlet weak var DriftContainerView: UIView!
    @IBOutlet weak var SpeedContainerView: UIView!
    @IBOutlet weak var DriftButton: UIButton!
    @IBOutlet weak var NitroButton: UIButton!
    @IBOutlet weak var joystick: CDJoystick!
    @IBOutlet weak var BatteryIndicator: BatteryView!
    @IBOutlet weak var SpeedProgressView: GradientProgressBar!
    
    var nitroCount: CGFloat = 100
    var driftCount: CGFloat = 100
    var progresBarNitro: CircularProgressBar!
    var progresBarDrift: CircularProgressBar!
    var timerNitro: Timer!
    var timerDrift: Timer!
    
    let bleManager = Manager()
    
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
        
        SpeedContainerView.layer.cornerRadius = 19
        
        drawLine(onLayer: SpeedProgressView.layer, SpeedProgressView.bounds, #colorLiteral(red: 0.3605898917, green: 0.3404306173, blue: 0.6947399378, alpha: 1), [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9], 6)
        
        SpeedProgressView.gradientColors = [#colorLiteral(red: 1, green: 1, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.4039215686, blue: 0, alpha: 1)]
        BatteryIndicator.level = 50
        
        let xPosition = self.NitroButton.center.x
        let yPosition = self.NitroButton.center.y
        let position = CGPoint(x: xPosition, y: yPosition)
        progresBarNitro = CircularProgressBar(radius: 36, position: position, innerTrackColor: #colorLiteral(red: 0, green: 1, blue: 0.6, alpha: 1), outerTrackColor:#colorLiteral(red: 0, green: 1, blue: 0.6, alpha: 0.3005002248) , lineWidth: 5)
        progresBarNitro.progress = 100
        //Add to progressBar to views sublayer
        NitroButton.layer.addSublayer(progresBarNitro)
        
        let xPositionDrift = self.DriftButton.center.x
        let yPositionDrift = self.DriftButton.center.y
        let positionDrift = CGPoint(x: xPositionDrift, y: yPositionDrift)
        progresBarDrift = CircularProgressBar(radius: 36, position: positionDrift, innerTrackColor: #colorLiteral(red: 0, green: 0.8549019608, blue: 1, alpha: 1), outerTrackColor: #colorLiteral(red: 0, green: 0.8549019608, blue: 1, alpha: 0.3029170414), lineWidth: 5)
        progresBarDrift.progress = 100
        //Add to progressBar to views sublayer
        DriftButton.layer.addSublayer(progresBarDrift)
   
        NitroContainerView.layer.cornerRadius = NitroContainerView.frame.width/2
        DriftContainerView.layer.cornerRadius = DriftContainerView.frame.width/2
        
        joystick.trackingHandler = { joystickData in
            
            let x = abs(joystickData.velocity.x)
            self.SpeedProgressView.setProgress(Float(x),animated: false)
            
        }
        
        bleManager.delegate = self
        bleManager.startScanForDevices(advertisingWithServices: nil)        
    }
    
    func manager(_ manager: Manager, didFindDevice device: Device) {
        
    }
    
    func manager(_ manager: Manager, willConnectToDevice device: Device) {
        
    }
    
    func manager(_ manager: Manager, connectedToDevice device: Device) {
        
    }
    
    func manager(_ manager: Manager, disconnectedFromDevice device: Device, willRetry retry: Bool) {
        
    }
    
    func manager(_ manager: Manager, RSSIUpdated device: Device) {                
        
    }
    
    func manager(_ manager: Manager,IsBLEOn status:Bool) {
        
    }
    
    @objc func nitroProccess() {
        nitroCount -= 2
        progresBarNitro.progress = nitroCount
        if nitroCount <= 0 {
            timerNitro.invalidate()
            nitroCount = 100
            progresBarNitro.progress = nitroCount
            NitroButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func driftProccess() {
        driftCount -= 5
        progresBarDrift.progress = driftCount
        if driftCount <= 0 {
            timerDrift.invalidate()
            driftCount = 100
            progresBarDrift.progress = driftCount
            DriftButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func NitroButtonAction(_ sender: Any) {
        NitroButton.isUserInteractionEnabled = false
        timerNitro = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nitroProccess), userInfo: nil, repeats: true)
        timerNitro.fire()
    }
    
    @IBAction func DriftButtonAction(_ sender: Any) {
        DriftButton.isUserInteractionEnabled = false
        timerDrift = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(driftProccess), userInfo: nil, repeats: true)
        timerDrift.fire()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BrakeButtonAction(_ sender: Any) {
        Haptico.shared().generateFeedbackFromPattern("OOO", delay: 0.1)
    }
    
    func drawLine(onLayer layer: CALayer, _ innerRect: CGRect, _ markColor: CGColor, _ marks: Array<Float>!,_ markWidth: Float) {
        for mark in marks {
            let markWidth = CGFloat(mark)
            let postion:CGFloat! =  CGFloat((innerRect.width  * markWidth ) / 1)
            
            let line = CAShapeLayer()
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: postion, y: innerRect.height / 2 - 5))
            linePath.addLine(to:  CGPoint(x: postion, y: innerRect.height / 2 + 30))
            line.path = linePath.cgPath
            line.lineWidth = 2
            line.fillColor = nil
            line.opacity = 1.0
            line.strokeColor = markColor
            layer.addSublayer(line)
        }
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
