//
//  ColorApplyButton.swift
//  Counter
//
//  Created by Irina Vaara on 27.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

public class ColorApplyButton: UIButton
{
    public var borderWidth: CGFloat = 0
    
    public var color: UIColor? = nil {
     
        didSet {
            setNeedsDisplay()
        }
    }

    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if let color = color
        {
            var pathRect = rect
            let withBorder = borderWidth > 0
            
            if withBorder {
                pathRect = pathRect.insetBy(dx: borderWidth, dy: borderWidth)
            }

            let path = UIBezierPath(ovalIn: pathRect)
            
            color.setFill()
            path.fill()

            if withBorder
            {
                path.lineWidth = borderWidth * 1.3
                let borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                borderColor.setStroke()
                path.stroke()
            }
            
            path.close()
        }
    }
}
