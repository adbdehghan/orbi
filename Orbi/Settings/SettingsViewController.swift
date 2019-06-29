//
//  SettingsViewController.swift
//  Orbi
//
//  Created by adb on 6/13/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import SummerSlider
import MaterialColorPicker
import BottomPopup
import Bluetonium

class SettingsViewController: UIViewController,MaterialColorPickerDelegate,MaterialColorPickerDataSource,ManagerDelegate {

    @IBOutlet weak var SpeedContainerView: UIView!
    @IBOutlet weak var SpeedSlider: SummerSlider!
    @IBOutlet weak var SensivityContainerView: UIView!
    @IBOutlet weak var SensivitySlider: SummerSlider!
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var pickerView: MaterialColorPicker!
    var ColorContainerView :UIView!
   
    var handle = 0;
    var maxSpeed = 0;
    var selectedColor = #colorLiteral(red: 1, green: 0, blue: 0.5007593632, alpha: 1)
    
    var RGB_R_INDEX =  0
    let RGB_G_INDEX = 1
    let RGB_B_INDEX = 2
    let RGB_CHECK_SUM_INDEX  = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.revealMenu()
        BleSingleton.shared.bleManager.delegate = self

         let settingManager = CalibrationManager()
        
        maxSpeed = Int(settingManager.maxSpeedValue)
        handle = Int(settingManager.controlSensivityValue)
        
        pickerView = MaterialColorPicker(frame: CGRect(x: 17, y: 500, width: self.view.frame.width, height: 60))
        self.formView.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.shuffleColors = false
        pickerView.selectionColor = #colorLiteral(red: 0.3607843137, green: 0.3411764706, blue: 0.6941176471, alpha: 1)
        pickerView.selectedBorderWidth = 0
        pickerView.cellSpacing = 24
        pickerView.dataSource = self
        
        SpeedContainerView.layer.cornerRadius = 20
        SensivityContainerView.layer.cornerRadius = 20
        SpeedSlider.layer.cornerRadius = 20
        
        var sampleArray = Array<Float>()
        sampleArray = [0,7,14,21,28,35,42,49,56,63,70,77,84,91]
        SpeedSlider.markColor = #colorLiteral(red: 0.3607843137, green: 0.3411764706, blue: 0.6941176471, alpha: 1)
        SpeedSlider.markWidth = 2.0
        SpeedSlider.markPositions = sampleArray
        SpeedSlider.value = Float(settingManager.maxSpeedValue)
        SpeedSlider.addTarget(self, action: #selector(SpeedValueChanged), for: .valueChanged)
        self.SpeedSlider.setThumbImage(UIImage(named: "slider-thumb")!, for: .normal)
        self.SpeedSlider.gradientColors = [#colorLiteral(red: 1, green: 1, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.4039215686, blue: 0, alpha: 1)]
        
        var sensivityArray = Array<Float>()
        sensivityArray = [0,7,14,21,28,35,42,49,56,63,70,77,84,91]
        SensivitySlider.markColor = #colorLiteral(red: 0.3605898917, green: 0.3404306173, blue: 0.6947399378, alpha: 1)
        SensivitySlider.markWidth = 2.0
        SensivitySlider.markPositions = sensivityArray
        SensivitySlider.value = Float(settingManager.controlSensivityValue)
        SensivitySlider.addTarget(self, action: #selector(SensivityValueChanged), for: .valueChanged)
        self.SensivitySlider.setThumbImage(UIImage(named: "slider-thumb")!, for: .normal)
        self.SensivitySlider.gradientColors = [#colorLiteral(red: 0, green: 0.8823529412, blue: 1, alpha: 1),#colorLiteral(red: 0.9176470588, green: 0, blue: 1, alpha: 1)]
        
        let addColorContainerView = UIView(frame: CGRect(x: 315, y: 506, width: 48, height: 48))
        addColorContainerView.layer.cornerRadius = addColorContainerView.frame.width/2
        addColorContainerView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1215686275, blue: 0.3215686275, alpha: 0.2412039119)
        
        ColorContainerView = UIView(frame: CGRect(x: addColorContainerView.frame.size.width/2 - 19, y: addColorContainerView.frame.size.height/2 - 19, width: 38, height: 38))
        ColorContainerView.layer.cornerRadius = ColorContainerView.frame.width/2
        ColorContainerView.backgroundColor = settingManager.ledColor
        addColorContainerView.addSubview(ColorContainerView)
        
        let addColorButton = UIButton(frame: CGRect(x: addColorContainerView.frame.size.width/2 - 12, y: addColorContainerView.frame.size.height/2 - 12, width: 24, height: 24))
        addColorButton.setImage(UIImage(named: "add"), for: .normal)
        addColorButton.addTarget(self, action: #selector(self.ShowColorPicker), for: .touchUpInside)
        addColorContainerView.addSubview(addColorButton)
        
        formView.addSubview(addColorContainerView)
        
        formView.frame = CGRect(x: 280, y: 0, width: self.view.frame.size.width - 310, height: formView.frame.height)
        
        self.scrollView.addSubview(formView)
        self.formView.translatesAutoresizingMaskIntoConstraints = true
        
        self.formView.leadingAnchor.constraint(equalTo:self.scrollView.leadingAnchor).isActive = true
        self.formView.trailingAnchor.constraint(equalTo:self.scrollView.trailingAnchor).isActive = true
        self.formView.topAnchor.constraint(equalTo:self.scrollView.topAnchor).isActive = true
        self.formView.bottomAnchor.constraint(equalTo:self.scrollView.bottomAnchor).isActive = true
        self.formView.widthAnchor.constraint(equalTo:self.view.widthAnchor).isActive = true
        
        self.scrollView.delaysContentTouches = false          
  
    }
    
    @objc func SensivityValueChanged(sender: UISlider)
    {
        let settingManager = CalibrationManager()
        handle = Int(sender.value * 100)
        settingManager.SaveCalibValues(MaxSpeed: settingManager.maxSpeedValue, Sensivity: Double(handle), LEDColor: settingManager.ledColor)
        

        SendParams()
        
    }
    
    @objc func SpeedValueChanged(sender: UISlider)
    {
        let settingManager = CalibrationManager()
        maxSpeed = Int(sender.value * 100)
        settingManager.SaveCalibValues(MaxSpeed: Double(maxSpeed), Sensivity: settingManager.controlSensivityValue, LEDColor: settingManager.ledColor)
      
        SendParams()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 590)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let settingManager = CalibrationManager()
        ColorContainerView.backgroundColor = settingManager.ledColor
        selectedColor = settingManager.ledColor
        SendLEDColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SendParams()
        BleSingleton.shared.bleManager.delegate = nil      
    }
    
    func didSelectColorAtIndex(_ MaterialColorPickerView: MaterialColorPicker, index: Int, color: UIColor) {
        print("Index is ", index)
        
        selectedColor = color
        SendLEDColor()        
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
    
    
    func colors()->[UIColor]
    {
        return [#colorLiteral(red: 0.6078431373, green: 0.9294117647, blue: 0.1176470588, alpha: 1),#colorLiteral(red: 1, green: 0.7882352941, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.8156862745, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.3843137255, blue: 0.8235294118, alpha: 1)]
    }
    
    func sizeForCellAtIndex(_ MaterialColorPickerView: MaterialColorPicker, index: Int) -> CGSize {
        if index == 3{
            return CGSize(width: 50, height: 50)
        }else{
            return CGSize(width: 50, height: 50)
        }
    }
    
    @objc func ShowColorPicker(_ sender: UIButton)
    {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "colorpickerVC") as? ColorPickerController else { return }
        popupVC.height = self.view.frame.height
        popupVC.topCornerRadius = 10
        popupVC.presentDuration = 0.4
        popupVC.dismissDuration = 0.5
        popupVC.shouldDismissInteractivelty = false
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    func ShowConnectView()
    {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "connectViewController") as? ConnectViewController else { return }
        popupVC.height = self.view.frame.height
        popupVC.topCornerRadius = 10
        popupVC.presentDuration = 0.3
        popupVC.dismissDuration = 0.5
        popupVC.shouldDismissInteractivelty = false        
        present(popupVC, animated: true, completion: nil)
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
    
    func toUint(signed: Int) -> UInt8 {
        
        let unsigned = signed >= 0 ?
            UInt8(signed) :
            UInt8(signed  - Int.min) + UInt8(Int.max) + 1
        
        return unsigned
    }
}


extension SettingsViewController: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        
        let settingManager = CalibrationManager()
         ColorContainerView.backgroundColor = settingManager.ledColor
        selectedColor = settingManager.ledColor
        SendLEDColor()
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red*255, coreImageColor.green*255, coreImageColor.blue*255, coreImageColor.alpha)
    }
}
