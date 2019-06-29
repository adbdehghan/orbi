//
//  ConnectViewController.swift
//  Orbi
//
//  Created by adb on 6/17/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import Pulsator
import Bluetonium
import SideMenuSwift
import BottomPopup
import CoreBluetooth

class ConnectViewController: BottomPopupViewController,ManagerDelegate {
   
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var backContainerView: UIView!
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    var RGB_R_INDEX =  0
    let RGB_G_INDEX = 1
    let RGB_B_INDEX = 2
    let RGB_CHECK_SUM_INDEX  = 3
    var selectedColor = #colorLiteral(red: 1, green: 0, blue: 0.5007593632, alpha: 1)
    var handle = 0;
    var maxSpeed = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingManager = CalibrationManager()
        selectedColor = settingManager.ledColor
        maxSpeed = Int(settingManager.maxSpeedValue)
        handle = Int(settingManager.controlSensivityValue)
        BLESetup()
        UiSetup()
    }
     
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    fileprivate func BLESetup() {
        
        BleSingleton.shared.bleManager.delegate = self  
    }
    
    
    fileprivate func UiSetup() {
        backContainerView.layer.cornerRadius = backContainerView.frame.width / 2
        labelContainerView.layer.cornerRadius = 20
        
        let pulsator = Pulsator()
        pulsator.radius = 320.0
        pulsator.numPulse = 7
        pulsator.pulseInterval = 0.3
        pulsator.animationDuration = 4
        pulsator.backgroundColor = #colorLiteral(red: 0, green: 0.8509803922, blue: 1, alpha: 1)
        pulsator.frame.origin = view.center
        view.layer.insertSublayer(pulsator, at: 0)
        pulsator.start()
    }
    
    func manager(_ manager: Manager, didFindDevice device: Device) {
        if device.peripheral.name?.lowercased() != nil
        {
            if device.peripheral.name?.lowercased() == "orbi"
            {
                manager.connect(with: device)
            }
        }
    }
    
    func manager(_ manager: Manager, willConnectToDevice device: Device) {
        device.register(serviceModel: BleSingleton.shared.batteryServiceModel)
        device.register(serviceModel: BleSingleton.shared.controllerServiceModel)
        device.register(serviceModel: BleSingleton.shared.settingsServiceModel)        
    }
    
    func manager(_ manager: Manager, connectedToDevice device: Device) {
        
        BleSingleton.shared.bleManager.stopScanForDevices()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.SendLEDColor()
            self.SendParams()
            self.performSegue(withIdentifier: "main", sender: self)
        })
        
    }
    
    func manager(_ manager: Manager, disconnectedFromDevice device: Device, willRetry retry: Bool) {
        
    }
    
    func manager(_ manager: Manager, RSSIUpdated device: Device) {
        
    }
    
    func manager(_ manager: Manager, IsBLEOn status: Bool) {
        BleSingleton.shared.bleManager.startScanForDevices(advertisingWithServices: nil)
    }

    
    fileprivate func SendLEDColor() {
        let r = Int(selectedColor.components.red)
        let g = Int(selectedColor.components.green)
        let b = Int(selectedColor.components.blue)
        
        var rgb:[UInt8] = [UInt8](repeating: 0, count:4)
        rgb[RGB_R_INDEX] = toUint(signed:r)
        rgb[RGB_G_INDEX] = toUint(signed:g)
        rgb[RGB_B_INDEX] = toUint(signed:b)
        let sum = r + g + b
        rgb[RGB_CHECK_SUM_INDEX] = (toUint(signed:sum > 255 ? sum%256 : sum) & 0xFF)
        
        BleSingleton.shared.settingsServiceModel.RGBData = Data(rgb)
        BleSingleton.shared.settingsServiceModel.writeValue(withUUID: "00001535-1212-EFDE-1523-785FEF13D123")
    }
    
    fileprivate func SendParams() {
        var data:[UInt8] = [UInt8](repeating: 0, count:3)
        data[0] = toUint(signed:handle)
        data[1] = toUint(signed: maxSpeed)
        let sum = handle + maxSpeed
        data[2] = (toUint(signed:sum > 255 ? sum%256 : sum) & 0xFF)
        
        BleSingleton.shared.settingsServiceModel.controlPoint = Data(data)
        BleSingleton.shared.settingsServiceModel.writeValue(withUUID: "00001536-1212-EFDE-1523-785FEF13D123")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        BleSingleton.shared.bleManager.delegate = nil
    }
    
    @IBAction func BackAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func toUint(signed: Int) -> UInt8 {
        
        let unsigned = signed >= 0 ?
            UInt8(signed) :
            UInt8(signed  - Int.min) + UInt8(Int.max) + 1
        
        return unsigned
    }
}
