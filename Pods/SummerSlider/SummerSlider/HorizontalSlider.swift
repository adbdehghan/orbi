//
//  Sliders.swift
//  SummerSlider
//
//  Created by derrick on 26/09/2017.
//  Copyright © 2017 SuperbDerrick. All rights reserved.
//

import Foundation


struct HorizontalSlider: SliderDrawingProtocol , DrawAPIProtocol{

	var slider: Slider
    
	init(slider: Slider){
		self.slider = slider
	}
	
	func getDrawingImage(rect : CGRect) -> (UIImage,UIImage) {
		
		// Basic Setup to make a Inner Rect.
		let innerRect = rect.insetBy(dx: Constants.INNER_RECT.X, dy: Constants.INNER_RECT.Y)
		UIGraphicsBeginImageContextWithOptions(innerRect.size ,false , 0)
		let context = UIGraphicsGetCurrentContext()!
		
        
		// Draw Selection Rect.
		drawRect(context,  innerRect , slider.iSelectedBarColor.cgColor)
		
		// Make Selection Image.
		let selectedSide = UIGraphicsGetImageFromCurrentImageContext()
		selectedSide!.resizableImage(withCapInsets: UIEdgeInsets.zero)
		
		// Draw UNSelection Rect.
		drawRect(context,  innerRect , slider.iUnSelectedBarColor.cgColor)
		
		// Make UNSelection Image.
		let unSelectedSide = UIGraphicsGetImageFromCurrentImageContext()
		unSelectedSide!.resizableImage(withCapInsets: UIEdgeInsets.zero)
		
		// Draw Selection Image.
		selectedSide!.draw(at: CGPoint(x:0,y:0))
		
		
		// Draw Selection Marks. slider.iMarkColor.cgColor, slider.iMarkPositions, slider.iMarkWidth
//		drawMarks(context, innerRect, slider.iMarkColor.cgColor , slider.iMarkPositions , slider.iMarkWidth )
		
		
//		let selectedStripSide = UIGraphicsGetImageFromCurrentImageContext()!.resizableImage(withCapInsets: UIEdgeInsets.zero)
		
		// Draw UNSelection Image.
		unSelectedSide!.draw(at: CGPoint(x:0,y:0))
		
//		drawMarks(context, innerRect, slider.iMarkColor.cgColor, slider.iMarkPositions, slider.iMarkWidth)
        
        let selectedStripSide = gradientImage(size: innerRect.size, colorSet: slider.iGradientColors)
        let unselectedStripSide = gradientImage(size: innerRect.size, colorSet: [#colorLiteral(red: 0.231372549, green: 0.2156862745, blue: 0.4666666667, alpha: 1),#colorLiteral(red: 0.231372549, green: 0.2156862745, blue: 0.4666666667, alpha: 1)])
		
//		let unselectedStripSide = UIGraphicsGetImageFromCurrentImageContext()!.resizableImage(withCapInsets: UIEdgeInsets.zero)

		UIGraphicsEndImageContext()
        
        return (selectedStripSide!,unselectedStripSide!)
	}
	
	func drawMarks(_ context: CGContext, _ innerRect: CGRect, _ markColor: CGColor, _ marks: Array<Float>!, _ markWidth: Float) {
		
		for mark in marks {
			context.setLineWidth(CGFloat(markWidth))
			let markWidth = CGFloat(mark)
			let postion:CGFloat! =  CGFloat((innerRect.width  * markWidth ) / Constants.SLIDER.WHOLE_PERCENT)
			context.move(to: CGPoint(x: postion, y: innerRect.height / 2 - 16))
			context.addLine(to: CGPoint(x: postion, y: innerRect.height / 2 + 16))
			context.setStrokeColor(markColor)
			context.strokePath()
			}
		
	}
	
    
    func gradientImage(size: CGSize, colorSet: [CGColor]) -> UIImage! {
        let tgl = CAGradientLayer()
        tgl.frame = CGRect.init(x:0, y:0, width:size.width, height: size.height)
        tgl.cornerRadius = tgl.frame.height / 2
        tgl.masksToBounds = false
        tgl.colors = colorSet
        tgl.startPoint = CGPoint.init(x:0.0, y:1)
        tgl.endPoint = CGPoint.init(x:1.0, y:1)
        
        UIGraphicsBeginImageContextWithOptions(size, tgl.isOpaque, 0.0);
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        tgl.render(in: context)
         drawMarks(context, CGRect.init(x:0, y:0, width:size.width, height: size.height), slider.iMarkColor.cgColor , slider.iMarkPositions , slider.iMarkWidth )
        let image =
            
            UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets:
                UIEdgeInsets.init(top: 0, left: size.height, bottom: 0, right: size.height))
        UIGraphicsEndImageContext()
        return image!
    }

    
	func drawRect(_ context:CGContext ,_ innerRect : CGRect , _ rectColr:CGColor)->Void {
		context.setLineCap(CGLineCap.round);
		context.setLineWidth(26.0)
		context.move(to: CGPoint(x: 6, y: innerRect.height / 2))
		context.addLine(to: CGPoint(x: innerRect.width - 10, y: innerRect.height / 2))
		context.setStrokeColor(rectColr)
		context.strokePath()
	}
	
}



