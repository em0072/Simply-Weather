//
//  CollectionViewCell.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 26.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

    class CollectionViewCell: UICollectionViewCell {
     
        var timeLabel: UILabel!
        var imageView: UIImageView!
        var percipProbability: UILabel!
        var tempLabel: UILabel!
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override init(frame: CGRect) {
            imageView = UIImageView(frame: CGRect(x: 9, y: 18, width: 40, height: 40))
            timeLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: frame.size.width, height: 18))
            percipProbability = UILabel(frame:  CGRect(x: 0, y: 57, width: frame.size.width, height: 15))
            super.init(frame: frame)
            tempLabel = UILabel(frame:  CGRect(x: 0, y: 72, width: frame.size.width, height: 23))
            
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            contentView.addSubview(imageView)
            
            //timeLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height, width: frame.size.width, height: frame.size.height/3))
            timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            timeLabel.textAlignment = .Center
            timeLabel.textColor = UIColor.whiteColor()
            contentView.addSubview(timeLabel)
            
            percipProbability.font = UIFont(name: "HelveticaNeue-Light", size: 12)
            percipProbability.textAlignment = .Center
            percipProbability.textColor = UIColor.whiteColor()
            contentView.addSubview(percipProbability)
            
            tempLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
            tempLabel.textAlignment = .Center
            tempLabel.textColor = UIColor.whiteColor()
            contentView.addSubview(tempLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        
}

