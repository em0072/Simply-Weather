//
//  BackgroundView.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 19.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Background View
        
        //// Color Declarations
        let lightBlue: UIColor = UIColor(red: 29/255, green: 157/255, blue: 191/255, alpha: 1.000)
        let darkBlue: UIColor = UIColor(red: 145/255.0, green: 215/255.0, blue: 235/255.0, alpha: 1.000)
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        let blueGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightBlue.CGColor, darkBlue.CGColor], [0, 1])
        //let violetGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightBlue.CGColor, darkBlue.CGColor], [0, 1])
        
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        CGContextSaveGState(context)
        backgroundPath.addClip()
        
        // Changing background depending on time of the day
        // Need to implement
        CGContextDrawLinearGradient(context, blueGradient,
            CGPointMake(160, 0),
            CGPointMake(160, 550),
            [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        
        CGContextRestoreGState(context)
    }


}
