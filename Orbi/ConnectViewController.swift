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

class ConnectViewController: UIViewController,ManagerDelegate {

    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var backContainerView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BleSingleton.shared.bleManager.delegate = self
        BleSingleton.shared.bleManager.startScanForDevices(advertisingWithServices: nil)
        
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
    }
    
    func manager(_ manager: Manager, connectedToDevice device: Device) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let connectController = storyBoard.instantiateViewController(withIdentifier: "driveViewController") as! DriveViewController
            self.present(connectController, animated: true, completion: nil)
        })
        
    }
    
    func manager(_ manager: Manager, disconnectedFromDevice device: Device, willRetry retry: Bool) {
        
    }
    
    func manager(_ manager: Manager, RSSIUpdated device: Device) {
        
    }
    
    func manager(_ manager: Manager, IsBLEOn status: Bool) {
        
    }
    
    @IBAction func BackAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let connectController = storyBoard.instantiateViewController(withIdentifier: "menuCollectionView") as! MenuCollectionViewController
        self.present(connectController, animated: true, completion: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
