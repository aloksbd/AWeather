//
//  ADailyForecast.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

struct ADailyForecast: Decodable, Equatable{
    let dt: String
    let sunrise: String
    let sunset: String
    let humidity: String?
    let speed: String?
    let pop: String?
    let snow: String?
    let weather: Weather
    let temperature: Temperature
}
