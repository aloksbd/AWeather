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
    public let pop: Double
    public let weather: [Weather]
    public let temp: Temperature
    
    public init(dt: Int, sunrise: Int, sunset: Int, humidity: Int, speed: Double, pop: Double, weather: [Weather], temperature: Temperature){
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.humidity = humidity
        self.speed = speed
        self.pop = pop
        self.weather = weather
        self.temp = temperature
    }
}
