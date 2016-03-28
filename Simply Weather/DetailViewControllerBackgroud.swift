//
//  ViewControllerBackgroud.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 20.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class DetailViewControllerBackgroud: UIView {

    
    override func drawRect(rect: CGRect) {
        // Background View
        
        //// Color Declarations
        let lightBlue: UIColor = UIColor(red: 134/255.0, green: 199/255.0, blue: 217/255.0, alpha: 1.000)
        let darkBlue: UIColor = UIColor(red: 29/255, green: 157/255, blue: 191/255, alpha: 1.000)
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        let blueGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightBlue.CGColor, darkBlue.CGColor], [0, 1])
        
        
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        CGContextSaveGState(context)
        backgroundPath.addClip()
        
        // Changing background depending on time of the day
        // Need to implement
        CGContextDrawLinearGradient(context, blueGradient,
            CGPointMake(160, 00),
            CGPointMake(160, 550),
            [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        
        CGContextRestoreGState(context)

        //// Sun Path
        
        let circleOrigin = CGPointMake(0, 0.9 * self.frame.height)
        let circleSize = CGSizeMake(self.frame.width, 0.3 * self.frame.height)
        
        let pathStrokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.80)
        let pathFillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.500)
        
        
        //// Sun Drawing
        let sunPath = UIBezierPath(ovalInRect: CGRectMake(circleOrigin.x, circleOrigin.y, circleSize.width, circleSize.height))
        pathFillColor.setFill()
        sunPath.fill()
        pathStrokeColor.setStroke()
        sunPath.lineWidth = 1
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [2, 2], 2)
        sunPath.stroke()
        CGContextRestoreGState(context)
    
        // Sun icon
        let sunriseIcon = UIImageView(image: UIImage(named: "sunrise"))
        let sunsetIcon = UIImageView(image: UIImage(named: "sunset"))
        let bounds = UIScreen.mainScreen().bounds
        let screenHeight = bounds.size.height
        let screenWidth = bounds.size.width

        sunriseIcon.frame = CGRect(x:(0.025 * screenWidth), y: screenHeight - 85, width: 45, height: 45)
        sunsetIcon.frame = CGRect(x: ((0.975 * screenWidth) - 45), y: screenHeight - 85, width: 45, height: 45)
        
        addSubview(sunriseIcon)
        addSubview(sunsetIcon)
        
    }
    

}
