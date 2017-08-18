//
//  NetworkUtil.swift
//  Weath
//
//  Created by Marcus Johnson on 8/14/17.
//  Copyright © 2017 weather. All rights reserved.
//

import UIKit

class NetworkUtil: NSObject {
    
    static let sharedInstance = NetworkUtil()
    func getFiveDayForecast(lat: Double , lng: Double, isDegrees:Bool, completion:@escaping ( [String: Any]) -> Void )->(){
        let metric = isDegrees ? "imperial" : "metric"
        let url = NSURL(string: NSString.init(format: Constants.URL_FIVE_DAY as NSString, lat, lng, metric) as String )
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as?  [String: Any] {
                completion(jsonObj!)
            }
        }).resume()
        
    }

}
