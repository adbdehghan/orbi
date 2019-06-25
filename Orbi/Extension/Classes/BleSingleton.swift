//
//  BleSingleton.swift
//  Orbi
//
//  Created by adb on 6/18/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import Foundation
import Bluetonium

final class BleSingleton {
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    
    static let shared = BleSingleton()
    
    // MARK: Local Variable
    
    let bleManager = Manager()
    let batteryServiceModel = BatteryServiceModel()
    let controllerServiceModel = ControllerServiceModel()
    let settingsServiceModel = SettingsServiceModel()
    let ledServiceModel = LEDServiceModel()
    var menuIndex = 0
    var batteryPercentage:CGFloat = 0
    
}

