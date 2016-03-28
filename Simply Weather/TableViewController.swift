//
//  TableViewController.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 19.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation



public var GPSStatus: CLAuthorizationStatus = .NotDetermined

class TableViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    @IBOutlet weak var updateTimeLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?    
    @IBOutlet var weatherIcon: UIImageView?
    @IBOutlet weak var feelsLikeLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var windLabel: UILabel?
    @IBOutlet weak var precipTypeLabel: UILabel?
    @IBOutlet weak var precipQtLabel: UILabel?
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem?
    @IBOutlet weak var cityNameLabel: UILabel?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var locationImage: UIImageView?
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var HumidityTextLabel: UILabel?
    @IBOutlet var WindTextLabel: UILabel?
    @IBOutlet var currentWheatherTextLabel: UILabel?
    

    
    @IBOutlet var headerView: UITableView!
    
    private let APIKey = "4c31736a72d1561f61ab14d652e3e7e2"
    
    var coordinate: (name: String, lat: Double, long: Double) = ("Cupertino", 37.318955, -122.029277) {
        didSet {
            saveCoordinates()
            //locationManager.stopUpdatingLocation()
            //
        }
    }
    var isThisCurrentLocation = Bool()
    
    var cityName = String()
    
    var weeklyWeather: [DailyWeather] = []
    var hourlyWeather: [HourlyWeather] = []
    var offset = Int()
    var tempInC = true
    

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        if isThisCurrentLocation == true {
        askForGPSData()
        }

        //Making Gif Image alive
        
        
      //  askForGPSData()
        
        
        loadCoordinates()
        configureView()
        //refreshWeather()
        if isThisCurrentLocation == true {
            locationManager.startUpdatingLocation()
           locationImage?.image = UIImage(named: "locationIcon")
            refreshWeather()
        } else if isThisCurrentLocation == false {
            locationImage?.image = nil
            refreshWeather()
        }

       
        
        
        self.revealViewController().rearViewRevealWidth = 0.7 * UIScreen.mainScreen().bounds.size.width
        
        // Setting Up Slide Menu
        if self.revealViewController() != nil {
            menuButton?.target = self.revealViewController()
            menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        tableView.addSubview(refreshControl)
        
        
        // Add tap Gesture to close Slide Menu
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        // Hide Humidity, Wind and current weather Labels
        HumidityTextLabel?.hidden = true
        WindTextLabel?.hidden = true
        currentWheatherTextLabel?.hidden = true
        locationImage?.hidden = true
        
    }

        
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        
    }
    
    
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        if isThisCurrentLocation == true {
            print("isThisCurrentLocation is \(isThisCurrentLocation)")
            locationManager.startUpdatingLocation()
            locationImage?.image = UIImage(named: "locationIcon")
           // refreshWeather()
        } else if isThisCurrentLocation == false {
            locationImage?.image = nil
            refreshWeather()
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

       
       // headerView.layerBlueGradient()
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UI Tweaks
    
    func configureView () {
        tableView.backgroundView = CleanBackgroundView()
        tableView.rowHeight = 64.0
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
       
    
        
        //Position Refresh Control Above BackGround View
        //refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        //refreshControl?.tintColor = UIColor.whiteColor()
        
        // Font And Color Of Navigation Bar
        if let navBarFont = UIFont(name: "HelveticaNeue-Light", size: 20.0) {
            let navBarAttributesDictionary = [
                NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: navBarFont]
            self.navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
            
        }
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryView?.backgroundColor = UIColor.clearColor()
        cell?.contentView.backgroundColor = UIColor(red: 129/255.0, green: 208/255.0, blue: 230/255.0, alpha: 1.000)
        let highlightView = UIView()
        
        highlightView.backgroundColor = UIColor(red: 129/255.0, green: 208/255.0, blue: 230/255.0, alpha: 1.000)
        cell?.selectedBackgroundView = highlightView
                let clearView = UIView()
        clearView.backgroundColor = UIColor.clearColor()
        cell?.selectedBackgroundView = clearView
        
                }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height: CGFloat = UIScreen.mainScreen().bounds.size.height //headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        headerView.backgroundColor = UIColor.clearColor()
        
        tableView.tableHeaderView = headerView
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
    
    }

    let threshold: CGFloat = 100.0
    func scrollViewDidScroll(scrollView: UIScrollView) {
    let contentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - contentOffset <= threshold) && maximumOffset > 100 {
    // Get more data - API call
    tableView.backgroundView = LogoBackgroundView()
    } else if (maximumOffset - contentOffset >= threshold) {
    // Get more data - API call
    tableView.backgroundView = CleanBackgroundView()
    }
    }
    


    //MARK: - GPS Things
    
    let locationManager = CLLocationManager()
    
    func askForGPSData () {
        //Get Current Location
        locationManager.delegate = self
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            switch status {
            case .Denied:
                coordinate = ("GPS Data Denied", 600.0, 600.0)
                print("coordinates now are 500.0, 500.0")
            case .AuthorizedWhenInUse:
                print("AuthorizedWhenInUse")
            default:
                print("didChangeAuthorizationStatus is Default")
            }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        // START Getting Coordinate Name and set to label
        print("try to get location")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location) {(placemarks, error) -> Void in
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            var cName = String()
            // City
            if let city = placeMark.addressDictionary?["City"] as? NSString
            {
                cName = city as String
            }
            print("I get location - \(self.coordinate.name)")
            self.coordinate = (cName, locValue.latitude,locValue.longitude)
            
        }
        // END Getting Coordinate Name and set to label
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationManager.stopUpdatingLocation()
        refreshWeather()
    }
    
    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weeklyWeather.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell") as! WeatherCell
        
        let dailyWeather = weeklyWeather[indexPath.row]
        cell.backgroundColor = UIColor.whiteColor()
        print(dailyWeather.smallIcon)
        cell.setCell(dailyWeather.day, dateNameLabel: dailyWeather.date, weatherIcon: dailyWeather.smallIcon, maxTempLabel: self.convertTempToC(dailyWeather.maxTemp!), minTempLabel: self.convertTempToC(dailyWeather.minTemp!), perceptionProbability: dailyWeather.precipProbability, needOfPercepPercent: dailyWeather.needOfPercepPercent)
        return cell
    }
    
    // MARK: - CollectionView data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (hourlyWeather.count / 2)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let hourWeather = hourlyWeather[indexPath.row]
        if indexPath.row == 0 {
            cell.timeLabel.text = NSLocalizedString("Now", comment: "The name of the first row representing current weather")
        } else {
        cell.timeLabel.text = "\(timeStringFromUNIXTime(hourWeather.time!))"
        }
        
        cell.imageView.image = hourWeather.smallIcon
        
        if hourWeather.needOfPercepPercent == true {
            cell.percipProbability.text = "\(hourWeather.precipProbability!)%"
        } else {
            cell.percipProbability.text = ""
        }
        
        cell.tempLabel.text = "\(convertTempToC(hourWeather.temperature!))º"
       // cell.backgroundColor = UIColor.redColor()
        //cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
        //cell.imageView?.image = UIImage(named: "circle")
        return cell
    }

    
    
    
    
    //MARK: - Navigatin To Detail View
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDailyWeather" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dailyWeather = weeklyWeather[indexPath.row]
                print(" table offset is \(offset)")
                (segue.destinationViewController as! ViewController).cityName = coordinate.name
                (segue.destinationViewController as! ViewController).offset = offset
                (segue.destinationViewController as! ViewController).weatherOfTheDay = dailyWeather
                
            }
        }
    }
    
    
    
    //MARK: - Navigation Bar Controll
    
   /* override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        askForGPSData()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    } */

    //MARK: - Weather Fetching
    
    func refreshWeather () {
        self.weatherIcon?.frame.origin = CGPointMake(-100, -100)
        print(coordinate)
        if self.coordinate.lat == 600 {
            print("GPS DENIED")
            weatherIcon?.image = UIImage(named: "noSatellite")
        } else if self.coordinate.lat == 500 {
            print("GPS PROBLEM")
        } else {
    
        //locationManager.startUpdatingLocation()
        let forcastService = ForecastService(APIKey: APIKey)
       //if coordinate.lat != 500.0 && coordinate.long != 500.0 {
        forcastService.getForcast(coordinate.lat, long: coordinate.long) {
            (let weatherDict) in
            if let weather = weatherDict,
            let currentWeather = weather.currentWeather {
                //Update UI
                dispatch_async(dispatch_get_main_queue()) {
                    if let currOffset = weather.offset {
                        print("refresh func offset = \(currOffset)")
                    self.offset = currOffset
                    }
                    
                    self.weeklyWeather = weather.weeklyWeather
                    self.hourlyWeather = weather.hourlyWeather
                    
                    // Hide Humidity, Wind and current weather Labels
                   self.HumidityTextLabel?.hidden = false
                    self.WindTextLabel?.hidden = false
                    self.currentWheatherTextLabel?.hidden = false
                    self.locationImage?.hidden = false
                    // Execute Closure
                    if let temperature = currentWeather.temperature {
                        self.temperatureLabel?.text = "\(self.convertTempToC(temperature))º"
                    }
                    //if self.isThisCurrentLocation == false {
                    self.cityNameLabel?.text = "\(self.coordinate.name)"
                   /* } else {
                    // START Getting Coordinate Name and set to label
                    let geoCoder = CLGeocoder()
                    let location = CLLocation(latitude: self.coordinate.lat, longitude: self.coordinate.long)
                    geoCoder.reverseGeocodeLocation(location) {(placemarks, error) -> Void in
                        let placeArray = placemarks as [CLPlacemark]!
                        
                        // Place details
                        var placeMark: CLPlacemark!
                        placeMark = placeArray?[0]
                        
                        // City
                        if let city = placeMark.addressDictionary?["City"] as? NSString
                        {
                            self.coordinate.name = city as String
                            self.title = "\(self.coordinate.name)"
                        }
                    }
                    // END Getting Coordinate Name and set to label
                    }*/
                    
                    if let appTemp = currentWeather.apparentTemperature {
                        //self.feelsLikeLabel?.text = "Feels Like \(self.convertTempToC(appTemp))º"
                        self.feelsLikeLabel?.text = String.localizedStringWithFormat(NSLocalizedString("Feels Like %dº", comment: "Описание ощущаемой температуры"), self.convertTempToC(appTemp))
                    }
                    
                    
                    
                    /*
                    if let temperature = currentWeather.temperature {
                        if let windSpeed = currentWeather.windSpeed {
                            self.feelsLikeLabel?.text = "Feels Like \(self.calculateFeelsLikeTemp(temperature, mphWindSpeed: windSpeed))º"
                        } else {
                        self.feelsLikeLabel?.text = "Feels Like \(self.calculateFeelsLikeTemp(temperature, mphWindSpeed: 1.0))º"
                        }
                    }
                    */
                    if let humidity = currentWeather.humidity {
                        self.humidityLabel?.text = "\(humidity)%"
                    }
                    
                    if let percipitation = currentWeather.precipProbability,
                    let precipType = currentWeather.precipType {
                        if percipitation > 25 {
                        self.precipQtLabel?.text = "\(percipitation)%"
                        self.precipTypeLabel?.text = "\(precipType)"
                        } else {
                        self.precipQtLabel?.text = ""
                        self.precipTypeLabel?.text = ""
                        }
                    }
                    
                
                    if let icon = currentWeather.icon {
                        self.weatherIcon?.image = icon
                    }
                    
                    
                    if let windSpeed = currentWeather.windSpeed {
                        self.windLabel?.text = self.convertToWindSpeedToMPerSec(windSpeed)
                    }
                    
                    
                    
                    
                    
                    print(self.locationImage)
                    print(self.isThisCurrentLocation)
                    
                   self.loadingIndicator.hidden = true
                    
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    
                   // self.configureView()
                    print("Weather Refreshed at \(self.coordinate)")
                    
                    

                    
                    

                }
            }
        }
        }
    }

    func convertTempToC(fTemperature: Int) -> Int {
        if tempTypeIsC == true {
        return (fTemperature - 32)*5/9
        } else {
            return fTemperature
        }
    }
    
    func convertToWindSpeedToMPerSec(mphWindSpeed: Double) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d km/h", comment: "type of wind"), Int(mphWindSpeed * 1.60934))
    }
    
    func calculateFeelsLikeTemp (fTemperature: Int, mphWindSpeed: Double) -> Int {
    let feelsLikeTemp = 35.74 + 0.6215 * Double(fTemperature) - 35.75 * (pow(mphWindSpeed,0.16)) + 0.4275 * Double(fTemperature) * (pow(mphWindSpeed,0.16))
        return convertTempToC(Int(feelsLikeTemp))
    }
   
    
    
    
    func saveCoordinates() {
        NSUserDefaults.standardUserDefaults().setObject(coordinate.lat, forKey: "lat")
        NSUserDefaults.standardUserDefaults().setObject(coordinate.long, forKey: "long")
         NSUserDefaults.standardUserDefaults().setObject(coordinate.name, forKey: "name")
        NSUserDefaults.standardUserDefaults().setObject(isThisCurrentLocation, forKey: "current")
         //NSUserDefaults.standardUserDefaults().setBool(tempInC, forKey: "typeOfTemp")
    }
    
    func loadCoordinates() {
        if let lat = NSUserDefaults.standardUserDefaults().objectForKey("lat"),
            let long = NSUserDefaults.standardUserDefaults().objectForKey("long"),
            let name = NSUserDefaults.standardUserDefaults().objectForKey("name"),
        let current = NSUserDefaults.standardUserDefaults().objectForKey("current") {
            coordinate = (name as! String, lat as! Double,long as! Double)
            isThisCurrentLocation = current as! Bool
        }
        if let typeOfTemp = NSUserDefaults.standardUserDefaults().objectForKey("typeOfTemp") {
            tempTypeIsC = typeOfTemp as! Bool
        }    }
    
    func timeStringFromUNIXTime(UNIXTime: Double) -> String {
        let realTime = UNIXTime + Double((offset - 3) * 60 * 60)
        print("\(realTime) = \(UNIXTime) \(Double(offset * 60 * 60))")
        let date = NSDate(timeIntervalSince1970: realTime)
        //dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
}

