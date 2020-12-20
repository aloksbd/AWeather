//
//  ADailyForecast.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct ADailyForecast: Decodable, Equatable{
    public let dt: String
    public let sunrise: String
    public let sunset: String
    public let humidity: String?
    public let speed: String?
    public let pop: String?
    public let snow: String?
    public let weather: Weather
    public let temperature: Temperature
    
    public init(dt: String, sunrise: String, sunset: String, humidity: String?, speed: String?, pop: String?, snow: String?, weather: Weather, temperature: Temperature){
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.humidity = humidity
        self.speed = speed
        self.pop = pop
        self.snow = snow
        self.weather = weather
        self.temperature = temperature
    }
}
