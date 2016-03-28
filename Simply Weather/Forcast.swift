//
//  Forcast.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 19.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import Foundation

struct Forcast {
    var offset: Int?
    var currentWeather: CurrentWeather?
    var weeklyWeather: [DailyWeather] = []
    var hourlyWeather: [HourlyWeather] = []
    
    
    init(weatherDictionary: [String: AnyObject]) {
        if let currentJSONDictionary = weatherDictionary["currently"] as? [String: AnyObject] {
            currentWeather = CurrentWeather(weatherDictionary: currentJSONDictionary)
        }
        if let  weeklyWeatherArray = weatherDictionary["daily"]?["data"] as? [[String: AnyObject]] {
            for dailyWeather in weeklyWeatherArray {
                let daily = DailyWeather(weatherDictionary: dailyWeather)
                weeklyWeather.append(daily)
            }
        }
        if let  hourlyWeatherArray = weatherDictionary["hourly"]?["data"] as? [[String: AnyObject]] {
            for hourWeather in hourlyWeatherArray {
                let hourly = HourlyWeather(weatherDictionary: hourWeather)
                hourlyWeather.append(hourly)
            }
        }
        if let currentOffset = weatherDictionary["offset"] as? Int {
            offset = currentOffset
        }
        
    }
}