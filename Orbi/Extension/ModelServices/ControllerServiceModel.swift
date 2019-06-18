//
//  BatteryServiceModel.swift
//  BluetoniumExample
//
//  Created by Dick Verbunt on 24/12/15.
//  Copyright © 2015 E-sites. All rights reserved.
//

import Foundation
import Bluetonium


struct ControllerServiceModelConstants {
    static let serviceUUID = "00001524-1212-EFDE-1523-785FEF13D123"
    static let ControllerUUID = "00001525-1212-EFDE-1523-785FEF13D123"
}

/**
 BatteryServiceModel represents the Battery CBService.
 */
class ControllerServiceModel: ServiceModel {
    
    var controlPoint = Data()
    
    override open var serviceUUID:String {
        return ControllerServiceModelConstants.serviceUUID
    }

    override func mapping(_ map: Map) {
        controlPoint  <- (map[ControllerServiceModelConstants.ControllerUUID], ControllerDataTransformer())
    }
    
    override func characteristicBecameAvailable(withUUID uuid: String) {
        
        if uuid != ControllerServiceModelConstants.ControllerUUID {
            return
        }
        
        writeValue(withUUID: uuid)
    }
}

class ControllerDataTransformer: DataTransformer {
    
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

