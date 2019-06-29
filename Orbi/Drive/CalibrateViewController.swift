//
//  CalibrateViewController.swift
//  Orbi
//
//  Created by adb on 6/25/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import AGCircularPicker

class CalibrateViewController: UIViewController {
 
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var screenshotImageView: UIImageView!
    var pickerView: AGCircularPickerView!
    
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
    var Speed = 0
    var Angle:Int=0,Brake:UInt8=0,Calibrate:UInt8=0,Nitro:UInt8=0,Drift:UInt8=0
    override func viewDidLoad() {
        super.viewDidLoad()
        
         screenshotImageView.image = BleSingleton.shared.screenshot
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
        
        backContainerView.layer.cornerRadius = backContainerView.frame.width/2
        labelContainerView.layer.cornerRadius = 20
        
        let valueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 360, initialValue: 0)
        let titleOption = AGCircularPickerTitleOption(title: "Rotate")
        let option = AGCircularPickerOption(valueOption: valueOption, titleOption: titleOption)
        pickerView = AGCircularPickerView(frame: CGRect(x: self.view.frame.width/2 - 125, y: self.view.frame.height/2-96, width: 250, height: 250))
        self.view.addSubview(pickerView)
        pickerView.setupPicker(delegate: self, option: option)

    }
    
    @IBAction func CloseAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
    
    func checkSum(data:[UInt8]) -> Int
    {
        var sum:Int = 0
        for i in 0..<data.count - 1
        {
            sum += Int(data[i])
        }
        return sum
    }    
    
}

extension CalibrateViewController: AGCircularPickerViewDelegate {
    
    func circularPickerViewDidChangeValue(_ value: Int, color: UIColor, index: Int) {
        Angle = value
        Calibrate = 1
        SendControlParams()
    }
    
    func circularPickerViewDidEndSetupWith(_ value: Int, color: UIColor, index: Int) {
        
    }
    
    func didBeginTracking(timePickerView: AGCircularPickerView) {
        
    }
    
    func didEndTracking(timePickerView: AGCircularPickerView) {
        Calibrate = 0
        SendControlParams()
    }
    
}
