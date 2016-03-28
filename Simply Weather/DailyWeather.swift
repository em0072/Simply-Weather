//
//  DailyWeather.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 19.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather {
    let pressure: Int?
    let cloudCover: Int?
    var day: String?
    var date: String?
    var minTempTime: Double?
    var maxTempTime: Double?
    let windSpeed: Double?
    let summary:  String?
    var icon: UIImage? = UIImage(named: "default")
    var smallIcon: UIImage? = UIImage(named: "default_small")
    var needOfPercepPercent: Bool?
    var sunriseTime: Double?
    var sunsetTime: Double?
    // let moonPhase: 0.34
    // let precipIntensity: 0.0088
    // let precipIntensityMax: 0.0189
    // let precipIntensityMaxTime: 1453183200
    let precipType: String?
    let maxPrecip: Double?
    let precipProbability: Int?
    // let precipAccumulation: 3.984
    let minTemp: Int?
    // let temperatureMinTime: 1453161600
    let maxTemp: Int?
    // let temperatureMaxTime: 1453208400
    // let apparentTemperatureMin: -4.3
    // let apparentTemperatureMinTime: 1453172400
    // let apparentTemperatureMax: 3.06
    // let apparentTemperatureMaxTime: 1453208400
    // let dewPoint: 11.71
    let humidity: Int?
    
    // let windBearing: 19
    // let cloudCover: 0.9
    // let pressure: 1009.8
    // let ozone: 367.87
    let dateFormatter = NSDateFormatter()
    
    init(weatherDictionary: [String: AnyObject]) {
        summary = weatherDictionary["summary"] as? String
        
        if let maximumPercipitation = weatherDictionary["precipIntensityMaxTime"] as? Double {
            maxPrecip = maximumPercipitation
        } else {
            maxPrecip = nil
        }
        
        if let minimunTempTime = weatherDictionary["temperatureMinTime"] as? Double {
            minTempTime = minimunTempTime
        }
        
        if let maximumTempTime = weatherDictionary["temperatureMaxTime"] as? Double {
            maxTempTime = maximumTempTime
        }
        if let cloudCoverDouble = weatherDictionary["cloudCover"] as? Double {
            cloudCover = Int(cloudCoverDouble * 100)
        } else {
            cloudCover = nil
        }
        
        
        
        if let weatherIcon = weatherDictionary["icon"] as? String{
            icon = UIImage(named: "\(weatherIcon)")
        }
        
        
        if let weatherIcon = weatherDictionary["icon"] as? String{
            smallIcon = UIImage(named: "\(weatherIcon)_small")
            if weatherIcon == "snow" || weatherIcon == "rain" || weatherIcon == "sleet" {
                needOfPercepPercent = true
            } else {
                needOfPercepPercent = false
            }
        }
        
        if let precipitationType = weatherDictionary["precipType"] as? String,
            let type : PrecipType = PrecipType(rawValue: precipitationType) {
                precipType = type.makeRightPrecipType()
        } else {
            precipType = nil
        }
        
        if let currentPressure = weatherDictionary["pressure"] as? Double {
            pressure = Int(currentPressure)
        } else {
            pressure = nil
        }
        
        if let precipProbabilityDouble = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipProbabilityDouble * 100)
        } else {
            precipProbability = nil
        }
        
        if let maximumTemp = weatherDictionary["temperatureMax"] as? Double {
            maxTemp = Int(maximumTemp)
        } else {
            maxTemp = nil
        }
        
        if let minimumTemp = weatherDictionary["temperatureMin"] as? Double {
            minTemp = Int(minimumTemp)
        } else {
            minTemp = nil
        }

        if let humidityDouble = weatherDictionary["humidity"] as? Double {
            humidity = Int(humidityDouble * 100)
        } else {
            humidity = nil
        }
        if let windSpeedDouble = weatherDictionary["windSpeed"] as? Double {
            windSpeed = windSpeedDouble
        } else {
            windSpeed = nil
        }
        
        if let sunrise = weatherDictionary["sunriseTime"] as? Double {
            sunriseTime = sunrise
            
        }
        if let sunset = weatherDictionary["sunsetTime"] as? Double {
            sunsetTime = sunset
            
        }
        if let time = weatherDictionary["time"] as? Double {
            day = dayStringFromUNIXTime(time)
        }
        
        if let  time = weatherDictionary["time"] as? Double {
            date = dateStringFromUNIXTime(time)
        }

    }
        
    
    
    func dayStringFromUNIXTime(UNIXTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: UNIXTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "eeee"
        return dateFormatter.stringFromDate(date).capitalizedString
    }
    
    func dateStringFromUNIXTime(UNIXTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: UNIXTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.stringFromDate(date)
    }

    
}
























