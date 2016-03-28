//
//  BGView.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 23.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class LogoBackgroundView: UIView {
    

    override func drawRect(rect: CGRect) {
        // Background View
        let bounds = UIScreen.mainScreen().bounds
        let bgLabelheight = bounds.size.height - 42
        let bgLabel = UILabel(frame: CGRectMake(0, bgLabelheight, bounds.size.width, 21))
        bgLabel.textAlignment = NSTextAlignment.Center
        bgLabel.textColor = UIColor.whiteColor()
        bgLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        bgLabel.text = NSLocalizedString("Have a Nice Day!", comment: "Have a Nice Day!")
        addSubview(bgLabel)
        
        let bgImage = UIImageView(image: UIImage(named: "bottom"))
        bgImage.frame = CGRect(x: bounds.size.width / 2 - 25, y: bgLabelheight - 50, width: 50, height: 50)
        addSubview(bgImage)

        
        
        
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
