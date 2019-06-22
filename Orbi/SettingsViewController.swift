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

class SettingsViewController: UIViewController,MaterialColorPickerDelegate,MaterialColorPickerDataSource {

    @IBOutlet weak var SpeedContainerView: UIView!
    @IBOutlet weak var SpeedSlider: SummerSlider!
    @IBOutlet weak var SensivityContainerView: UIView!
    @IBOutlet weak var SensivitySlider: SummerSlider!
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var pickerView: MaterialColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.revealMenu()

        
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
        SpeedSlider.value = 0.85
        self.SpeedSlider.setThumbImage(UIImage(named: "slider-thumb")!, for: .normal)
        self.SpeedSlider.gradientColors = [#colorLiteral(red: 1, green: 1, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.4039215686, blue: 0, alpha: 1)]
        
        
        var sensivityArray = Array<Float>()
        sensivityArray = [0,7,14,21,28,35,42,49,56,63,70,77,84,91]
        SensivitySlider.markColor = #colorLiteral(red: 0.3605898917, green: 0.3404306173, blue: 0.6947399378, alpha: 1)
        SensivitySlider.markWidth = 2.0
        SensivitySlider.markPositions = sensivityArray
        SensivitySlider.value = 0.4
        self.SensivitySlider.setThumbImage(UIImage(named: "slider-thumb")!, for: .normal)
        self.SensivitySlider.gradientColors = [#colorLiteral(red: 0, green: 0.8823529412, blue: 1, alpha: 1),#colorLiteral(red: 0.9176470588, green: 0, blue: 1, alpha: 1)]
        
        
        let addColorContainerView = UIView(frame: CGRect(x: 315, y: 506, width: 48, height: 48))
        addColorContainerView.layer.cornerRadius = addColorContainerView.frame.width/2
        addColorContainerView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1215686275, blue: 0.3215686275, alpha: 0.2412039119)
        
        let addColorButton = UIButton(frame: CGRect(x: addColorContainerView.frame.size.width/2 - 12, y: addColorContainerView.frame.size.height/2 - 12, width: 24, height: 24))
        addColorButton.setImage(UIImage(named: "add"), for: .normal)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 590)
    }
    

    func didSelectColorAtIndex(_ MaterialColorPickerView: MaterialColorPicker, index: Int, color: UIColor) {
        print("Index is ", index)
        
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

