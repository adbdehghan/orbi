//
//  Slider.swift
//  SummerSlider
//
//  Created by derrick on 26/09/2017.
//  Copyright © 2017 SuperbDerrick. All rights reserved.
//

import Foundation

struct Slider{
	var iMarkColor : UIColor
	var iSelectedBarColor : UIColor
	var iUnSelectedBarColor : UIColor
	var iMarkWidth : Float
	var iMarkPositions : Array<Float>
	var iDrawingMode : DrawingMode
	var style: SliderStyle
    public var iGradientColors: [CGColor] = [#colorLiteral(red: 0.2666666667, green: 0.1803921569, blue: 0.8470588235, alpha: 1).cgColor, #colorLiteral(red: 0.8392156863, green: 0.2588235294, blue: 0.5333333333, alpha: 1).cgColor, #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor, #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1).cgColor]     
}

