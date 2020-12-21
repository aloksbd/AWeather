//
//  ADailyForecast.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

import Foundation

public struct ADailyForecast: Codable, Equatable{
    public let dt: Int
    public let sunrise: Int
    public let sunset: Int
    public let humidity: Int
    public let speed: Double
    public let pop: Int
    public let weather: [Weather]
    public let temp: Temperature
    
    public init(dt: Int, sunrise: Int, sunset: Int, humidity: Int, speed: Double, pop: Int, weather: [Weather], temperature: Temperature){
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.humidity = humidity
        self.speed = speed
        self.pop = pop
        self.weather = weather
        self.temp = temperature
    }
    
    public func date() -> String{
        return DateToString.dateString( dt, from: "MMMM dd, yyyy")
    }
    
    public func day() -> String{
        return DateToString.dateString( dt, from: "EEEE")
    }
    
    public func sunriseTime() -> String{
        return DateToString.dateString(sunrise, from: "h:mm a")
    }
    
    public func sunsetTime() -> String{
        return DateToString.dateString(sunset, from: "h:mm a")
    }
}

class DateToString{
    static func dateString(_ date: Int,from format: String) -> String{
                let date = Date(timeIntervalSince1970: TimeInterval(date))
                let dateFormatter = DateFormatter() //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = format //Specify your format that you want
                let strDate = dateFormatter.string(from: date)
                return strDate
    }
}
