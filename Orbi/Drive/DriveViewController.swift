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
import CoreBluetooth
import BottomPopup
import SRCountdownTimer

class DriveViewController: UIViewController,ManagerDelegate,BatteryServiceModelDelegate,SRCountdownTimerDelegate  {
    var countdownTimer: SRCountdownTimer!
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
    
    
    let BLE_PACKET_CONFIG_INDEX = 0
    var BLE_PACKET_ANGLE_LOW_INDEX =  1
    let BLE_PACKET_ANGLE_HIGH_INDEX = 2
    let BLE_PACKET_VELOCITY_INDEX = 3
    let BLE_PACKET_CHECKSUM_INDEX = 4
    
    let BLE_PACKET_CONFIG_BRAKE_POS = 0
    let BLE_PACKET_CONFIG_CALIB_POS = 1
    let BLE_PACKET_CONFIG_NITRO_POS = 2
    let BLE_PACKET_CONFIG_DRIFT_POS = 3
    var data:[UInt8] = [UInt8](repeating: 0, count:5)

    var nitroCount: CGFloat = 100
    var driftCount: CGFloat = 100
    var progresBarNitro: CircularProgressBar!
    var progresBarDrift: CircularProgressBar!
    var mainProccess: Timer!
    var timerNitro: Timer!
    var timerDrift: Timer!

    var Speed = 0
    var Angle:Int=0,Brake:UInt8=0,Calibrate:UInt8=0,Nitro:UInt8=0,Drift:UInt8=0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLESetup()
        MainProcessSetup()
        UiConfigurations()
        JoystickSetup()
    }
    
    fileprivate func MainProcessSetup() {
        mainProccess = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.SendControlParams), userInfo: nil, repeats: true)
        mainProccess.fire()
    }
    
    fileprivate func JoystickSetup() {
        joystick.trackingHandler = { joystickData in
            
            let speed = joystickData.strength
            let angle = joystickData.angle
            
            self.Speed = speed
            self.Angle = angle
            
            // print("Speed: \(speed)  Angle: \(angle)")
            // self.SendControlParams()
            
            self.SendControlParams()
            
            let strength = Float(joystickData.strength)/100
            self.SpeedProgressView.setProgress(strength,animated: false)
        }
    }
    
    fileprivate func BLESetup() {
        BleSingleton.shared.bleManager.delegate = self
        
        if BleSingleton.shared.bleManager.connectedDevice != nil {
            for model in BleSingleton.shared.bleManager.connectedDevice!.registedServiceModels {
                if let batteryServiceModel = model as? BatteryServiceModel {
                    batteryServiceModel.delegate = self
                }
            }
        }
    }
    
    fileprivate func UiConfigurations()
    {        
        let overlay = UIView(frame: self.view.frame)
        overlay.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        overlay.alpha = 0.85
        overlay.tag = 32
        self.view.addSubview(overlay)
        
        self.countdownTimer = SRCountdownTimer()
        self.countdownTimer.frame = CGRect(x: overlay.frame.width/2-100, y: overlay.frame.height/2-100, width: 200, height: 200)
        self.countdownTimer.labelFont = UIFont(name: "HelveticaNeue-Light", size: 50.0)
        self.countdownTimer.labelTextColor = CalibrationManager().ledColor
        self.countdownTimer.timerFinishingText = "Let's Go"
        self.countdownTimer.lineWidth = 5
        self.countdownTimer.lineColor = CalibrationManager().ledColor
        self.countdownTimer.start(beginingValue: 5, interval: 1)
        self.countdownTimer.delegate = self
        self.countdownTimer.tag = 13
        overlay.addSubview(self.countdownTimer)
        
        
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
        BatteryIndicator.level = 0
        
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
        
        self.BatteryIndicator.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.ShowBatteryStatus)))
        
    }
    
    @objc func ShowBatteryStatus()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let connectController = storyBoard.instantiateViewController(withIdentifier: "chargeIndicatorVC") as! ChargeIndicatorViewController
        self.present(connectController, animated: true, completion: nil)
    }
    
    @objc func timerDidEnd()
    {
        let overlay = self.view.viewWithTag(32)
        overlay!.removeFromSuperview()
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
    
    func manager(_ manager: Manager, IsBLEOn status: Bool) {
        
    }
    
    func batteryLevelChanged(_ batteryLevel: UInt8) {
        BatteryIndicator.level = Int(batteryLevel)
        BleSingleton.shared.batteryPercentage = CGFloat(batteryLevel)
    }
    
    @objc func SendControlParams(){
        
        data = [UInt8](repeating: 0, count:5)
        let brake = ((Brake & 0xFF) << BLE_PACKET_CONFIG_BRAKE_POS)
        let calibrate = ((Calibrate & 0xFF) << BLE_PACKET_CONFIG_CALIB_POS)
        let nitro = ((Nitro & 0xFF) << BLE_PACKET_CONFIG_NITRO_POS)
        let drift = ((Drift & 0xFF) << BLE_PACKET_CONFIG_DRIFT_POS)
        
        data[BLE_PACKET_CONFIG_INDEX] = brake | calibrate  | nitro | drift
        
        data[BLE_PACKET_ANGLE_LOW_INDEX] = toUint(signed:(Angle & 0xFF))
        data[BLE_PACKET_ANGLE_HIGH_INDEX] = toUint(signed:((Angle >> 8) & 0xFF))
        data[BLE_PACKET_VELOCITY_INDEX] = toUint(signed: Speed)
        let sum = checkSum(data:data)
        
        data[BLE_PACKET_CHECKSUM_INDEX] = (toUint(signed:sum > 255 ? sum%256 : sum) & 0xFF)
        
        BleSingleton.shared.controllerServiceModel.controlPoint = Data(data)
        BleSingleton.shared.controllerServiceModel.writeValue(withUUID: "00001525-1212-EFDE-1523-785FEF13D123")
        
    }
    
    func toUint(signed: Int) -> UInt8 {
        
        let unsigned = signed >= 0 ?
            UInt8(signed) :
            UInt8(signed  - Int.min) + UInt8(Int.max) + 1
        
        return unsigned
    }
    
    @objc func nitroProccess() {
        nitroCount -= 10
        Nitro = 1
        progresBarNitro.progress = nitroCount
        if nitroCount <= 0 {
            timerNitro.invalidate()
            Nitro = 0
            nitroCount = 100
            progresBarNitro.progress = nitroCount
            NitroButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func driftProccess() {
        driftCount -= 5
        Drift = 1
        progresBarDrift.progress = driftCount
        if driftCount <= 0 {
            timerDrift.invalidate()
            Drift = 0
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        mainProccess.invalidate()
        BleSingleton.shared.bleManager.delegate = nil
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func BrakeButtonAction(_ sender: Any) {
        Haptico.shared().generateFeedbackFromPattern("OOO", delay: 0.1)
        Brake = 1
    }
    
    @IBAction func BrakeButtonActionCanceled(_ sender: Any) {
        Brake = 0
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

    func checkSum(data:[UInt8]) -> Int
    {
        var sum:Int = 0
        for i in 0..<data.count - 1
        {
            sum += Int(data[i])
        }
        return sum
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

