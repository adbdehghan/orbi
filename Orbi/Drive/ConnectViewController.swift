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


class ConnectViewController: BottomPopupViewController,ManagerDelegate {

    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var backContainerView: UIView!
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        BleSingleton.shared.bleManager.startScanForDevices(advertisingWithServices: nil)
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
            self.performSegue(withIdentifier: "main", sender: self)
        })
        
    }
    
    func manager(_ manager: Manager, disconnectedFromDevice device: Device, willRetry retry: Bool) {
        
    }
    
    func manager(_ manager: Manager, RSSIUpdated device: Device) {
        
    }
    
    func manager(_ manager: Manager, IsBLEOn status: Bool) {
        
    }
    
    @IBAction func BackAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
