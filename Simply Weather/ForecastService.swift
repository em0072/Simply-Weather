//
//  ForcastService.swift
//  Simply Weather
//
//  Created by Митько Евгений on 15.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import Foundation

struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    init (APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    
    func getForcast (lat: Double, long: Double, completion: (Forcast? -> Void)) {
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forecastBaseURL) {
           _ =  NetworkOperation(url: forecastURL).downloadJSONFromURL({ (JSONDictionary) -> Void in
            let weather = Forcast(weatherDictionary: JSONDictionary!)
            completion(weather)
           })
        } else {
            print("Couldn't construct URL Request")
        }
    }
    
    
    
    
}