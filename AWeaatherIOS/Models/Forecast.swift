//
//  Forecast.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 01/01/2021.
//

import Foundation

struct Forecast: Equatable{
    let dateTimeStamp: Int
    let sunriseTimeStamp: Int
    let sunsetTimeStamp: Int
    let humidity: Int
    let windSpeed: Double
    let rainChance: Double
    let weather: String
    let minTemperature: Double
    let maxTemperature: Double
    let dayTemperature: Double
    let eveningTemperature: Double
    let nightTemperature: Double
    let morningTemperature: Double
    
    var date: String{
        get{
            return DateToString.dateString( dateTimeStamp, to: "MMMM dd, yyyy")
        }
    }
    
    var day: String{
        get{
            return DateToString.dateString( dateTimeStamp, to: "EEEE")
        }
    }
    
    var sunriseTime: String{
        get{
            return DateToString.dateString(sunriseTimeStamp, to: "h:mm a")
        }
    }
    
    var sunsetTime: String{
        get{
            return DateToString.dateString(sunsetTimeStamp, to: "h:mm a")
        }
    }
}

private class DateToString{
    static func dateString(_ date: Int,to format: String) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
