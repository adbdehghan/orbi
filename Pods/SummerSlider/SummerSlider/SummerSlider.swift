//
//  SummerSlider.swift
//  SummerSliderSample
//
//  Created by derrick on 30/08/2017.
//  Copyright © 2017 Sensation. All rights reserved.
//

import UIKit

@IBDesignable public class SummerSlider: UISlider {
    
    
    @IBInspectable  public var markColor : UIColor!
    @IBInspectable  public var markPositions : Array<Float>!
    @IBInspectable  public var selectedBarColor : UIColor!
    @IBInspectable  public var unselectedBarColor : UIColor!
    
    public var gradientColors: [CGColor] = [#colorLiteral(red: 0.2666666667, green: 0.1803921569, blue: 0.8470588235, alpha: 1).cgColor, #colorLiteral(red: 0.8392156863, green: 0.2588235294, blue: 0.5333333333, alpha: 1).cgColor, #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor, #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1).cgColor]     
    public var markWidth : Float!
    public var drawingMode : DrawingMode!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupDefaultValues()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupDefaultValues()
    }
    
    public func reDraw() {
        self.setNeedsDisplay()
    }
    

    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var sliders = [Slider]()
        
        sliders.append(Slider(iMarkColor: self.markColor , iSelectedBarColor: self.selectedBarColor , iUnSelectedBarColor: self.unselectedBarColor , iMarkWidth: self.markWidth , iMarkPositions: self.markPositions ,  iDrawingMode: self.drawingMode , style: SliderStyle.Horizontal,iGradientColors: self.gradientColors))
        
        sliders.append(Slider(iMarkColor: self.markColor , iSelectedBarColor: self.selectedBarColor , iUnSelectedBarColor: self.unselectedBarColor , iMarkWidth: self.markWidth , iMarkPositions: self.markPositions ,  iDrawingMode: self.drawingMode , style: SliderStyle.Vertical,iGradientColors: self.gradientColors))
        
        let horizontalSlider = SliderFactory.getSlider(slider: sliders[0])
        
        let Image = horizontalSlider.getDrawingImage(rect: rect)
        
        setupTrackRange(Image.0, Image.1)
    }
    
    private func setupDefaultValues(){

        self.markColor = UIColor.white
        self.markWidth = 1.0
        self.selectedBarColor = UIColor.white
        self.unselectedBarColor = UIColor.black
        self.markPositions = Array<Float>()
        
        self.drawingMode = DrawingMode.BothSides
    }
    
    private func setupTrackRange(_ selectedStripSide:UIImage , _ unselectedStripSide:UIImage) {
        self.setMinimumTrackImage(selectedStripSide, for: UIControl.State.normal)
        self.setMaximumTrackImage(unselectedStripSide, for: UIControl.State.normal)
    }
    
}
