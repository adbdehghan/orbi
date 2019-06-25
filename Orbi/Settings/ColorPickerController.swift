//
//  ColorPickerController.swift
//  Counter
//
//  Created by Irina Zavilkina on 21.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit
import BottomPopup

protocol ColorPickerControllerDelegate
{
    func colorPickerController(_ controller: ColorPickerController, didSelectColor color: UIColor)
}

class ColorPickerController: BottomPopupViewController
{
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var noteContainerView: UIView!
    @IBOutlet weak var doneButtonContainerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    // MARK: - Outlets

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var colorPickerContainerView: UIView!
    @IBOutlet weak var colorPickerView: ColorPickerView!

    // MARK: - Public variables

    var selectedColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0.4467909336, alpha: 1)
    var colorsPalette: [UIColor] = []
    
    var delegate: ColorPickerControllerDelegate? = nil

    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Bottom popup attribute methods
    // You can override the desired method to change appearance
    
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
    
    
    // MARK: - Constructors

    class func controller() -> ColorPickerController
    {
        let id = String(describing: self)
        let controller = UIStoryboard(name: id, bundle: nil).instantiateInitialViewController() as! ColorPickerController
        
        return controller
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupSubviews()
    }
    
    // MARK: - Actions

    @IBAction func changeColor(_ sender: ColorPickerView)
    {
        selectedColor = sender.selectedColor
        delegate?.colorPickerController(self, didSelectColor: sender.selectedColor)
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private methods
    
    fileprivate func setupSubviews()
    {
        backContainerView.layer.cornerRadius = backContainerView.frame.width / 2
        doneButtonContainerView.layer.cornerRadius = 28
        noteContainerView.layer.cornerRadius = 20
        doneButton.layer.cornerRadius = 25
        doneButton.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.862745098, blue: 0.9333333333, alpha: 1)
        doneButton.layer.borderWidth = 4
//        backgroundImageView.image = UIApplication.shared.keyWindow?.snapshot()
        
        colorPickerView.selectedColor = selectedColor
    }
    
    @IBAction func BackAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneAction(_ sender: Any)
    {
        let settingManager = CalibrationManager()
        settingManager.SaveCalibValues(MaxSpeed: settingManager.maxSpeedValue, Sensivity: settingManager.controlSensivityValue, LEDColor: colorPickerView.selectedColor)
        dismiss(animated: true, completion: nil)
    }
}
