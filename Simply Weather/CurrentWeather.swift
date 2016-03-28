//
//  СгккутеЦуферук.swift
//  Simply Weather
//
//  Created by Митько Евгений on 15.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import Foundation
import UIKit

enum PrecipType: String {
    case Snow = "snow"
    case Rain = "rain"
    case Sleet = "sleet"
    case Hail = "hail"
    
    func makeRightPrecipType() -> String {
        var precipTypeString: String
    
        switch self {
        case .Rain:
            precipTypeString = NSLocalizedString("Rain", comment: "Дождь")
        case .Snow:
            precipTypeString = NSLocalizedString("Snow", comment: "Снег")
        case .Hail:
            precipTypeString = NSLocalizedString("Hail", comment: "Град")
        case .Sleet:
            precipTypeString = NSLocalizedString("Sleet", comment: "Дождь со Снегом")
        }
        return precipTypeString
    }
}


struct CurrentWeather {
    let temperature: Int?
    let apparentTemperature: Int?
    let humidity: Int?
    let precipType: String?
    let precipProbability: Int?
    let windSpeed: Double?
    let offset: Int?
    let summary: String?
    var icon = UIImage(named: "default")
    
    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temperature"] as? Int
        
        if let appTemp = weatherDictionary["apparentTemperature"] as? Double {
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
        }
    }
}