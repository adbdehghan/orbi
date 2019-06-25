//
//  BatteryServiceModel.swift
//  BluetoniumExample
//
//  Created by Dick Verbunt on 24/12/15.
//  Copyright © 2015 E-sites. All rights reserved.
//

import Foundation
import Bluetonium


struct SettingsServiceModelConstants {
    static let serviceUUID = "00001534-1212-EFDE-1523-785FEF13D123"
    static let settingsUUID = "00001536-1212-EFDE-1523-785FEF13D123"
    static let LEDUUID = "00001535-1212-EFDE-1523-785FEF13D123"
}

class SettingsServiceModel: ServiceModel {
    
    var controlPoint = Data()
    var RGBData = Data()
    
    override open var serviceUUID:String {
        return SettingsServiceModelConstants.serviceUUID
    }

    override func mapping(_ map: Map) {
        controlPoint  <- (map[SettingsServiceModelConstants.settingsUUID], SettingsDataTransformer())
        RGBData  <- (map[SettingsServiceModelConstants.LEDUUID], SettingsDataTransformer())
    }
    
    override func characteristicBecameAvailable(withUUID uuid: String) {
        
        if uuid != SettingsServiceModelConstants.settingsUUID || uuid != SettingsServiceModelConstants.LEDUUID{
            return
        }
        
        writeValue(withUUID: uuid)
    }
}

class SettingsDataTransformer: DataTransformer {
    
    func transform(dataToValue data: Data?) -> MapValue {
        
        guard let data = data else {
            return UInt16()
        }
        
        return data.withUnsafeBytes { (buffer: UnsafePointer<UInt16>) in
            if (buffer[0] & 0x01 == 0) {
                return UInt16(buffer[1]) as UInt16
            } else {
                return CFSwapInt16LittleToHost(UInt16(buffer[1])) as UInt16
            }
        }
    }
    
    func transform(valueToData value: MapValue?) -> Data {
        guard let value = value as? Data else {
            return Data()
        }
        return value
    }
}

