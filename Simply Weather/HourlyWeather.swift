//
//  HourlyWeather.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 26.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import Foundation

struct HourlyWeather {
    let temperature: Int?
    let time: Double?
    var smallIcon: UIImage? = UIImage(named: "default_small")
    let precipProbability: Int?
    var needOfPercepPercent: Bool?
    /* let apparentTemperature: Int?
    let humidity: Int?
    let precipType: String?
    let precipProbability: Int?
    let windSpeed: Double?
    let offset: Int?
    let summary: String?
    var icon = UIImage(named: "default") */
    
    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temperature"] as? Int
        
        if let currentTime = weatherDictionary["time"] as? Double {
            time = currentTime
        } else {
            time = nil
        }
        
        if let weatherIcon = weatherDictionary["icon"] as? String{
            smallIcon = UIImage(named: "\(weatherIcon)_hour")
            if weatherIcon == "snow" || weatherIcon == "rain" || weatherIcon == "sleet" {
                needOfPercepPercent = true
            } else {
                needOfPercepPercent = false
            }

        }
        if let precipProbabilityDouble = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipProbabilityDouble * 100)
        } else {
            precipProbability = nil
        }
        
       /* if let appTemp = weatherDictionary["apparentTemperature"] as? Double {
            apparentTemperature = Int(appTemp)
        } else {
            apparentTemperature = nil
        }
        
        
        
        if let humidityDouble = weatherDictionary["humidity"] as? Double {
            humidity = Int(humidityDouble * 100)
        } else {
            humidity = nil
        }
        
        if let precipitationType = weatherDictionary["precipType"] as? String,
            let type : PrecipType = PrecipType(rawValue: precipitationType) {
                precipType = type.makeRightPrecipType()
        } else {
            precipType = ""
        }
        
        if let precipProbabilityDouble = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipProbabilityDouble * 100)
        } else {
            precipProbability = nil
        }
        
        if let windSpeedDouble = weatherDictionary["windSpeed"] as? Double {
            windSpeed = windSpeedDouble
        } else {
            windSpeed = nil
        }
        
        if let weatherOffset = weatherDictionary["offset"] as? Int {
            offset = weatherOffset
        } else {
            offset = nil
        }
        
        summary = weatherDictionary["summary"] as? String
        
        if let weatherIcon = weatherDictionary["icon"] as? String{
            icon = UIImage(named: "\(weatherIcon)")
        } */
    }
}