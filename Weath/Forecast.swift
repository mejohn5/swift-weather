//
//  Forecast.swift
//  Weath
//
//  Created by Marcus Johnson on 8/14/17.
//  Copyright © 2017 weather. All rights reserved.
//

import UIKit

class Forecast: NSObject {
    var fiveDayForecast = [String: Day?]()
    init(json:  [String: Any]) {
        super.init()
        self.parseJson(json: json)
    }
    func parseJson(json:  [String: Any]){
        if let weatherList = json["list"]  as? [[String: Any]]{
            for item in weatherList {
                if let main = item["main"] as? [String: Any],
                    let temp = main["temp"],
                    let humidity = main["humidity"],
                    let wind = item["wind"] as? [String: Any],
                    let speed = wind["speed"],
                    let degrees = wind["deg"],
                    let time = item["dt"]
                    {
                       let dateString = Date().getDateStringFromUnix(unix: time as! Int)
                        if let day = fiveDayForecast[dateString]{
                            day?.check3HourData(temp: temp as! Double, windSpeed: speed as! Double, windDegrees: degrees as! Double, humidity: humidity as! Double)
                            fiveDayForecast[dateString] = day


                        }
                        else{
                            let day = Day()
                            day.check3HourData(temp: temp as! Double, windSpeed: speed as! Double, windDegrees: degrees as! Double, humidity: humidity as! Double)
                            fiveDayForecast[dateString] = day
                        }
                }
            }
        }
        
    }
    
    
    
}
