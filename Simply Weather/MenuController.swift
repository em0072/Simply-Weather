//
//  MenuController.swift
//  SimplyWeather
//
//  Created by Митько Евгений on 20.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation




class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GooglePlacesAutocompleteDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentLocationTempLabel: UILabel?
    @IBOutlet var settingsButton: UIButton?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet var myLocationButton: UIButton?
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var currentCityNameLabel: UILabel?
    

    private let APIKey = "4c31736a72d1561f61ab14d652e3e7e2"
    var cityList: [(name: String, lat: Double, long: Double)] = [("Cupertino", 37.318955, -122.029277)]
    var MyLocationName = String()
    var myCoord: (lat: Double, long: Double) = (500,500)
    var tempInC = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askForGPSData()
        locationManager.startUpdatingLocation()
        loadCityList()
        print(myCoord)
        
        
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)

        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        // Check GPS Status and place info if needed
        checkLocationSettings()
        
        //tableView.backgroundView = BackgroundView()
        
        //set segment control to right position
        if tempTypeIsC == true {
            self.segmentedControl.selectedSegmentIndex = 0
        } else {
            self.segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        tableView.reloadData()
        locationManager.startUpdatingLocation()
        refreshControl.endRefreshing()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        let footerView = tableView.tableFooterView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.backgroundColor = UIColor(red: 32/255, green: 147/255, blue: 179/255, alpha: 1)
        let height: CGFloat = 100.0  //headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        footerView.frame.size.height = height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }


    
    // MARK: - Setting Up Google AutoComplete
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addLocationButtonPressed(sender: AnyObject) {
        let gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyCAhGRTJrhixbfNwVj0H5nnqIB-7PywgS8",
            placeType: .Cities
        )
        
        gpaViewController.placeDelegate = self
        gpaViewController.navigationBar.barStyle = UIBarStyle.Black
        gpaViewController.navigationBar.translucent = false

        presentViewController(gpaViewController, animated: true, completion: nil)
        gpaViewController.navigationBar.barTintColor = UIColor(red: 29/255, green: 157/255, blue: 191/255, alpha: 1.0)
        gpaViewController.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    

    
    func placeSelected(place: Place) {
        print(place.description)
        print(place.id)
        
        place.getDetails { details in
            print(details)
            print(details.name)
            print(details.longitude)
            print(details.latitude)
            let myStringArr = place.description.componentsSeparatedByString(",")
            
            self.cityList.insert((myStringArr[0], details.latitude, details.longitude), atIndex: self.cityList.count)
            self.saveCityList()
            self.placeViewClosed()
            self.tableView.reloadData()
            //print("this is it \(self.printLoadList())")
            
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - GPS Things
    
    let locationManager = CLLocationManager()
    
    func askForGPSData () {
        //Get Current Location
        locationManager.delegate = self
            // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            switch status {
            case .Denied:
                myCoord.lat = 600
                myCoord.long = 600
                saveCityList()
                checkLocationSettings()
                print("coordinates now are 0, 0")
            default:
                print("didChangeAuthorizationStatus is Default")
            }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        myCoord.lat = locValue.latitude
        myCoord.long = locValue.longitude
       cityNameFromCoordinates(locValue.latitude, long: locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let forcastService = ForecastService(APIKey: APIKey)
        forcastService.getForcast(myCoord.lat, long: myCoord.long) {
            (let weatherDict) in
            if let weather = weatherDict,
                let currentWeather = weather.currentWeather {
                    //Update UI
                    dispatch_async(dispatch_get_main_queue()) {
                        self.checkLocationSettings()
                        // Execute Closure
                            if let temperature = currentWeather.temperature {
                                self.currentLocationTempLabel?.text = "\(self.convertTempToC(temperature))º"
                            } else {
                            self.currentLocationTempLabel?.text = ""
                            }
                        
                        if let icon = currentWeather.icon {
                            self.currentWeatherIcon?.image = icon
                        }
                        
                        self.locationManager.stopUpdatingLocation()
                        print("Weather Refreshed after getting GPS Data")
                    }
            }
        }
    }
    
    
    
    
    // MARK: - Table view data source

    var numberOfColor = 0

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityList.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuCell
        
        
        let color1 = UIColor(red: 32/255, green: 147/255, blue: 179/255, alpha: 1.0)
        let color2 = UIColor(red: 217/255, green: 174/255, blue: 74/255, alpha: 1.0)
        let color3 = UIColor(red: 91/255, green: 105/255, blue: 161/255, alpha: 1.0)
        let color4 = UIColor(red: 77/255, green: 153/255, blue: 99/255, alpha: 1.0)
        
        let colors = [color1, color2, color3, color4]

        if (indexPath.row) % 4 == 3 {
            cell.backgroundColor = colors[0]
        } else if (indexPath.row) % 4 == 0 {
            cell.backgroundColor = colors[1]
        } else if (indexPath.row) % 4 == 1 {
            cell.backgroundColor = colors[2]
        } else if (indexPath.row) % 4 == 2 {
            cell.backgroundColor = colors[3]
        }
        
        
            let forcastService = ForecastService(APIKey: APIKey)
            forcastService.getForcast(cityList[indexPath.row].lat, long: cityList[indexPath.row].long) {
                (let weatherDict) in
                if let weather = weatherDict,
                    let currentWeather = weather.currentWeather {
                        //Update UI
                        dispatch_async(dispatch_get_main_queue()) {
                            // Execute Closure
                        
                            if let temperature = currentWeather.temperature {
                                cell.tempLabel?.text = "\(self.convertTempToC(temperature))º"
                            }
                            cell.cityNameLabel?.text = self.cityList[indexPath.row].name
                            
                            
                            if let icon = currentWeather.icon {
                            cell.weatherIcon?.image = icon
                            }
                        
                            /* // START Getting Coordinate Name and set to label
                            let geoCoder = CLGeocoder()
                            let location = CLLocation(latitude: cityList[indexPath.row].lat, longitude: cityList[indexPath.row].long)
                            geoCoder.reverseGeocodeLocation(location) {(placemarks, error) -> Void in
                                let placeArray = placemarks as [CLPlacemark]!
                                
                                // Place details
                                var placeMark: CLPlacemark!
                                placeMark = placeArray?[0]
                                
                                // City
                                if let city = placeMark.addressDictionary?["City"] as? NSString
                                {
                                    cell.cityNameLabel?.text = city as String
                                }
                            }
                            // END Getting Coordinate Name and set to label */
                            
                            

                            // self.configureView()
                            print("Weather Refreshed")
                        }
                }
            }
        

        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete") { (action , indexPath ) -> Void in
            self.cityList.removeAtIndex(indexPath.row)
            self.saveCityList()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "None") { (action , indexPath) -> Void in
            print("Share button pressed")
        }
        return [shareAction, deleteAction]
    }
    
    


    //MARK: - Navigatin To Weather View
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWeather" {
            if let indexPath =  tableView.indexPathForSelectedRow {
                 print("Segue OK. IndexPath - \(indexPath.row), data - \(cityList[indexPath.row])")
                let navController = segue.destinationViewController as! UINavigationController
                let cvc = navController.childViewControllers.first as! TableViewController
                if cvc.isKindOfClass(TableViewController) {
                    //cvc.tempInC = self.tempInC
                    cvc.isThisCurrentLocation = false
                    cvc.coordinate.lat = cityList[indexPath.row].lat
                    cvc.coordinate.long = cityList[indexPath.row].long
                    cvc.coordinate.name = cityList[indexPath.row].name
                    
                }
            }
        } else if segue.identifier == "showCurrentWeather" {
                print("Segue OK. Current Location - \(myCoord)")
                let navController = segue.destinationViewController as! UINavigationController
                let cvc = navController.childViewControllers.first as! TableViewController
                if cvc.isKindOfClass(TableViewController) {
                    //cvc.tempInC = self.tempInC
                    cvc.isThisCurrentLocation = true
                    cvc.coordinate.lat = myCoord.lat
                    cvc.coordinate.long = myCoord.long
                    cvc.coordinate.name = MyLocationName
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

    // MARK: - Save And Load Functions
    // Serialize Tuple
    
    typealias AccessTuple = [(name: String, lat: Double, long: Double)]
    typealias AccessDictionary = [[String: AnyObject]]
    
    let cityName = "name"
    let lattitude = "lat"
    let longitude = "long"

    
    func serializeTuple(tuple: AccessTuple) -> AccessDictionary {
        var finalDictionary = [[String: AnyObject]]()
        for i in 0..<cityList.count {
            let tempDict = [
                cityName: cityList[i].name,
                lattitude: cityList[i].lat,
                longitude: cityList[i].long
            ]
            finalDictionary.append(tempDict as! [String : AnyObject])
        }
        return  finalDictionary
    }
    
    
    func deserializeDictionary(dictionary: AccessDictionary) -> [(name: String, lat: Double, long: Double)] {
        var a = [(name: String, lat: Double, long: Double)]()
        
        for i in (0..<(dictionary.count)) {
            let name = dictionary[i][cityName] as! String
            let lat = dictionary[i][lattitude] as! Double
            let long = dictionary[i][longitude] as! Double
            let tempTuple = ("\(name)", lat, long)
            a.append(tempTuple)
        }
        return a
    }

    // Encoding / Decoding
    
    
    // Writing to defaults
    func saveCityList() {
        let accessLevelDictionary = self.serializeTuple(self.cityList)
        NSUserDefaults.standardUserDefaults().setObject(accessLevelDictionary, forKey: "cityList")
        NSUserDefaults.standardUserDefaults().setDouble(myCoord.lat, forKey: "myCoord")
        NSUserDefaults.standardUserDefaults().setBool(tempTypeIsC, forKey: "typeOfTemp")

    }
    // Reading from defaults
    func loadCityList() {
        if let accessDic = NSUserDefaults.standardUserDefaults().arrayForKey("cityList") {
            let accessLev = deserializeDictionary(accessDic as! AccessDictionary)
            cityList = accessLev
            }
        if let myCoordDouble = NSUserDefaults.standardUserDefaults().objectForKey("myCoord") {
            myCoord.lat = myCoordDouble as! Double
        }
        if let typeOfTemp = NSUserDefaults.standardUserDefaults().objectForKey("typeOfTemp") {
            tempTypeIsC = typeOfTemp as! Bool
        }
    }
    
    func cityNameFromCoordinates(lat: Double, long: Double) {
        // START Getting Coordinate Name and set to label
        var cityName = String()
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location) {(placemarks, error) -> Void in
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
            // City
            if let city = placeMark.addressDictionary?["City"] as? NSString
            {
                print("This is return of cityNameFromCoordinates\(city)")
                self.MyLocationName = "\(city)"
                self.currentCityNameLabel?.text = "\(city)"
            }
        }
     // END Getting Coordinate Name and set to label
     
    }
    
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        
        let state = longPress.state
        
        let locationInView = longPress.locationInView(tableView)
        
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        if indexPath != nil{
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                print(indexPath)
                print(indexPath!.section)
                print(indexPath!.row)
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshopOfCell(cell)
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell.hidden = true
                        }
                })
                
            } else {
                print("error \(indexPath)")
            }
        case UIGestureRecognizerState.Changed:
            print("Changed Case")
            if let _ = My.cellSnapshot {
             var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                swap(&cityList[indexPath!.row], &cityList[Path.initialIndexPath!.row])
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
                saveCityList()
                }
            }
        default:
            print("Default case")
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
            }
        }
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        print("snapshopOfCell")
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func checkLocationSettings () {
        if self.myCoord.lat == 600 {
            self.currentWeatherIcon?.image = UIImage(named: "noSatellite")
            self.currentLocationTempLabel?.text = NSLocalizedString("Location Services are off", comment: "Location Services are off")
            self.settingsButton?.hidden = false
            self.myLocationButton?.hidden = true
            
        } else {
            self.currentLocationTempLabel?.text = ""
            self.settingsButton?.hidden = true
            self.myLocationButton?.hidden = false
        }
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        let title = NSLocalizedString("Location Services are off", comment: "Location Services are off")
        let message = NSLocalizedString("Location based weather is working only if location services are on. You can enable them in settings", comment: "Location based weather is working only if location services are on. You can enable them in settings")

        let alertController = UIAlertController (title: title, message: message, preferredStyle: .Alert)
        print("settings button pressed")
        
        let settingsButtonTitle = NSLocalizedString("Settings", comment: "Settings")
        let settingsAction = UIAlertAction(title: settingsButtonTitle, style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: -Different functions
    
    //colorWheel
    
    @IBAction func TempInCorF(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            tempTypeIsC = true
        case 1:
            tempTypeIsC = false
        default:
            break;
        }
        saveCityList()
        locationManager.startUpdatingLocation()
        tableView.reloadData()
    }

}
