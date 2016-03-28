//
//  NetworkOperation.swift
//  Simply Weather
//
//  Created by Митько Евгений on 15.01.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    
    typealias JSONDictionaryComplition = ([String: AnyObject]?) -> Void
    
    init (url: NSURL) {
    self.queryURL = url
    }
    
    
    func downloadJSONFromURL (completion: JSONDictionaryComplition) {
        
        let request = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            //1. Check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch(httpResponse.statusCode) {
                    case 200:
                        //2. Create JSON Object with data
                        do {
                        let jsonDictionary =  try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject]
                            completion(jsonDictionary)
                        } catch {
                            print("Error fetching JSON Dictionary \(httpResponse.statusCode)")
                        }
                    
                            default:
                        print("GET request not successful. HTTP status code - \(httpResponse.statusCode)")
                }
                
            } else {
                
                print("Error: Not a valid http response")
            }
        }
        dataTask.resume()
    }
}