//
//  Day.swift
//  Weath
//
//  Created by Marcus Johnson on 8/15/17.
//  Copyright © 2017 weather. All rights reserved.
//

import UIKit

class Day: NSObject {
    var lowTemp: Double = 0
    var highTemp: Double = 0
    var lowHumidity:Double = 0
    var highHumidity:Double = 0
    var maxWindSpeed: Double = 0
    var maxWindDirection:String = ""
    
    func checkWind(speed:Double,  degree:Double){
        if(maxWindSpeed > speed){
            maxWindSpeed  = speed
            maxWindDirection   = convertDegreesNorthToCardinalDirection(degrees: degree)
        }
    }
    
    func checkTemperature(temp: Double){
        if(temp < lowTemp){
            lowTemp = temp
        }
        if(temp > highTemp){
            highTemp = temp
        }
    }
    func checkHumidity(humidty: Double){
        if(humidty < lowHumidity){
            lowHumidity = humidty
        }
        if(humidty > highHumidity){
            highHumidity = humidty
        }
    }

    func check3HourData(temp: Double, windSpeed: Double, windDegrees:Double, humidity:Double){
        checkTemperature(temp: temp)
        checkWind(speed: windSpeed, degree: windDegrees)
        checkHumidity(humidty: humidity)
    }
    func convertDegreesNorthToCardinalDirection(degrees: Double) -> String {
        
        let cardinals: [String] = [ "North",
                                    "Northeast",
                                    "East",
                                    "Southeast",
                                    "South",
                                    "Southwest",
                                    "West",
                                    "Northwest",
                                    "North" ]
        
        let index = Int(round(degrees.truncatingRemainder(dividingBy: 360) / 45))
        
        return cardinals[index]
    }
}
