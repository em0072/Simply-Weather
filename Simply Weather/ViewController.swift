//
//  ViewController.swift
//  Simply Weather
//
//  Created by Митько Евгений on 15.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var minTempLabel: UILabel?
    @IBOutlet var maxTempLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet var windSpeedLabel: UILabel?

    @IBOutlet var minTempTimeLabel: UILabel?
    @IBOutlet var pressureLabel: UILabel?
    @IBOutlet var maxTempTimeLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet var cloudCoverLabel: UILabel?
    @IBOutlet var percipitationLabel: UILabel?
    
   
    
    @IBOutlet var cityLabel: UILabel?
    
    var animator:UIDynamicAnimator!
    var snapBehaviour:UISnapBehavior!
    

    var weatherOfTheDay: DailyWeather?/* {
        didSet {
            configureView()
        }
    }*/
    var cityName = String?()
    var offset = Int()
    var tempInC = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)

        configureView()
        refreshWeather()
        print(offset)
    }
    
    func configureView () {
       
        createSunriseAndSunsetLabels()
        
        self.currentWeatherIcon?.alpha = 0
        
        
        if let buttonFont = UIFont(name: "HelveticaNeue-Light", size: 20.0) {
            let barButtonAttributesDictionary = [
            NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: buttonFont]
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, forState: .Normal)
            
                       
            
            if let weather = weatherOfTheDay {
                self.title = "\(weather.day!) - \(weather.date!)"
                self.navigationController!.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20.0)!]
                
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
    
    
    func refreshWeather () {
        
            if let thisDayWeather = weatherOfTheDay {
                //Update UI
                if let city = cityName {
                    cityLabel?.text = "\(city)"
                }
                if let icon = thisDayWeather.icon {
                    currentWeatherIcon?.image = icon
                    
                }
                if let minTemperature = thisDayWeather.minTemp,
                    let maxTemperature = thisDayWeather.maxTemp {
                        minTempLabel?.text = "\(convertToCTemp(minTemperature))"
                        maxTempLabel?.text = "\(convertToCTemp(maxTemperature))"
                }
                
                if let minimumTempTime = thisDayWeather.minTempTime,
                    let maximumTempTime = thisDayWeather.maxTempTime {
                       // minTempTimeLabel?.text = "at \(timeStringFromUNIXTime(minimumTempTime))"
                        minTempTimeLabel?.text = String.localizedStringWithFormat(NSLocalizedString("at %@", comment: "at what time?"), timeStringFromUNIXTime(minimumTempTime))
                        //maxTempTimeLabel?.text = "at \(timeStringFromUNIXTime(maximumTempTime))"
                        maxTempTimeLabel?.text = String.localizedStringWithFormat(NSLocalizedString("at %@", comment: "at what time?"), timeStringFromUNIXTime(maximumTempTime))
                }
                
                if let humidity = thisDayWeather.humidity {
                    currentHumidityLabel?.text = "\(humidity)%"
                }
                
                if let windSpeed = thisDayWeather.windSpeed {
                    windSpeedLabel?.text = "\(convertToWindSpeedToMPerSec(windSpeed))"
                }
                
                if let pressure = thisDayWeather.pressure {
                    //pressureLabel?.text = "\(pressure) mB"
                    pressureLabel?.text = String.localizedStringWithFormat(NSLocalizedString("%d mB", comment: "type of pressure (mB or мм рт.ст)"), pressure)
                }
                if let cloudCover = thisDayWeather.cloudCover {
                    cloudCoverLabel?.text = "\(cloudCover)%"
                }
                
                if let percipType = thisDayWeather.precipType,
                let percipPercent = thisDayWeather.precipProbability,
                    let maxPercipIntencity = thisDayWeather.maxPrecip {
                        if percipPercent > 0{
                           let percipPercentString = "\(percipPercent)%"
                        //percipitationLabel?.text = "\(percipPercent)% of \(percipType). Maximum Intencity at \(timeStringFromUNIXTime(maxPercipIntencity))"
                        percipitationLabel?.text = String.localizedStringWithFormat(NSLocalizedString("%@ - %@. Maximum Intencity at %@", comment: "Описание осадков на странице деталей"), percipType, percipPercentString, timeStringFromUNIXTime(maxPercipIntencity))
                        } else {
                            percipitationLabel?.text = ""
                        }
                }
                    // Execute Closure
                    /*if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = self.convertToCTemp(temperature)
                    }
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    if let percipitation = currentWeather.precipProbability {
                        self.currentPercipitationLabel?.text = "\(percipitation)%"
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    if let summary = currentWeather.summary {
                        self.currentlySummaryLabel?.text = "\(summary)"
                    }
                    self.toggleRefreshAnimation(false)

                }*/
                //let positionOfIcon = CGPointMake(UIScreen.mainScreen().bounds.size.width * 0.5, UIScreen.mainScreen().bounds.size.height * 0.28)
                let x = self.cityLabel!.frame.origin.x
                let y = self.cityLabel!.frame.origin.y + CGFloat(self.cityLabel!.frame.size.height * 0.2)
                let positionOfIcon: CGPoint
                let bouncyImage = UIImageView(image: self.currentWeatherIcon?.image)

                if UIScreen.mainScreen().bounds.size.width > 320 {
                 positionOfIcon = CGPointMake(UIScreen.mainScreen().bounds.size.width * 0.5, y)
                    bouncyImage.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.height * 0.31, UIScreen.mainScreen().bounds.size.height * 0.31)
                } else {
                    positionOfIcon = CGPointMake(UIScreen.mainScreen().bounds.size.width * 0.5, (self.cityLabel!.frame.origin.y - CGFloat(self.cityLabel!.frame.size.height * 0.7)))
                    bouncyImage.frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.height * 0.23, UIScreen.mainScreen().bounds.size.height * 0.23)
                }
                
                //print("x - \(positionOfIcon.x), y - \(positionOfIcon.y)")
                
                let xSide = CGFloat(randomWithMinAndMax(0, max: 2))
                let ySide = CGFloat(randomWithMinAndMax(0, max: 2))
                bouncyImage.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width * xSide, UIScreen.mainScreen().bounds.size.height * ySide)
                //bouncyImage.frame.origin = CGPointMake(UIScreen.mainScreen().bounds.size.width , positionOfIcon.y)
                view.addSubview(bouncyImage)
                
                
                
                self.snapBehaviour = UISnapBehavior(item: bouncyImage, snapToPoint: positionOfIcon)
                self.snapBehaviour.damping = 0.2
                
                self.animator.addBehavior(self.snapBehaviour)
                    
        }
    }
    
    func convertToCTemp(fTemperature: Int) -> String{
        if tempTypeIsC == true {
        return "\((fTemperature - 32)*5/9)º"
        } else {
            return "\(fTemperature)º"
        }
    }
    func convertToWindSpeedToMPerSec(mphWindSpeed: Double) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d km/h", comment: "type of wind"), Int(mphWindSpeed * 1.60934))  //"\(Int(mphWindSpeed * 1.60934)) km/h"
    }
    func timeStringFromUNIXTime(UNIXTime: Double) -> String {
        let realTime = UNIXTime + Double((offset - 3) * 60 * 60)
        print("\(realTime) = \(UNIXTime) \(Double(offset * 60 * 60))")
        let date = NSDate(timeIntervalSince1970: realTime)
        //dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    func randomWithMinAndMax (min: Int, max: Int) -> Int {
        return Int(arc4random()) % (max - min) + min
    }
    
    func createSunriseAndSunsetLabels () {
        let bounds = UIScreen.mainScreen().bounds
        let screenHeight = bounds.size.height
        let screenWidth = bounds.size.width
        let sunriseLabel = UILabel(frame: CGRectMake((0.025 * screenWidth), screenHeight - 90 + 40, 45, 18))
        sunriseLabel.textAlignment = NSTextAlignment.Center
        sunriseLabel.textColor = UIColor.whiteColor()
        sunriseLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        if let sunriseTime = weatherOfTheDay?.sunriseTime {
        sunriseLabel.text = "\(timeStringFromUNIXTime(sunriseTime))"
        }
        self.view.addSubview(sunriseLabel)
        
            
        let sunsetLabel = UILabel(frame: CGRectMake(((0.975 * screenWidth) - 45), screenHeight - 90 + 40, 45, 18))
        sunsetLabel.textAlignment = NSTextAlignment.Center
        sunsetLabel.textColor = UIColor.whiteColor()
        sunsetLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        if let sunsetTime = weatherOfTheDay?.sunsetTime {
        sunsetLabel.text = "\(timeStringFromUNIXTime(sunsetTime))"
        }
        
        self.view.addSubview(sunsetLabel)
        
    }
    
    

}

