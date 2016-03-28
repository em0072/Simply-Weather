//
//  WeatherCell.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 20.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var dayNameLabel: UILabel?
    @IBOutlet weak var dateNameLabel: UILabel?
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var maxTempLabel: UILabel?
    @IBOutlet weak var minTempLabel: UILabel?
    @IBOutlet var percepProbabilityLabel: UILabel?
    let dateFormatter = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(dayNameLabel: String?, dateNameLabel: String?, weatherIcon: UIImage?, maxTempLabel: Int?, minTempLabel: Int?, perceptionProbability: Int?, needOfPercepPercent: Bool?) {
        if let day = dayNameLabel {
            let timeStamp = NSDate().timeIntervalSince1970
            
            if dateStringFromUNIXTime(timeStamp) == dateNameLabel {
                self.dayNameLabel?.text = NSLocalizedString("Today", comment: "The name of the first row representing today weather")
            } else {
            self.dayNameLabel?.text = day
            }
        }
        
        if let date = dateNameLabel {
            self.dateNameLabel?.text = date
        }
        
        
        if let icon = weatherIcon {
            self.weatherIcon?.image = icon
        }
        
        if let maxTemp = maxTempLabel {
            self.maxTempLabel?.text = "↑\(maxTemp)º"
        }
        
        if let minTemp = minTempLabel {
            self.minTempLabel?.text = "↓\(minTemp)º"

        }
        
        if let percepPercent = perceptionProbability {
            if needOfPercepPercent == true {
                self.percepProbabilityLabel?.text = "\(percepPercent)%"
            } else {
                self.percepProbabilityLabel?.text = ""
            }
        }
        
    }
    
    
    func dateStringFromUNIXTime(UNIXTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: UNIXTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.stringFromDate(date)
    }

}
