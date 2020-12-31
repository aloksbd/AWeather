//
//  AForecastItemMaker.swift
//  AWeaatherIOSTests
//
//  Created by Alok Subedi on 31/12/2020.
//

import Foundation
import AWeather

func makeItem() -> AForecast{
    let weather = Weather(main: "sunny")
    
    let temperature = Temperature(
        min: 12,
        max: 12,
        day: 12,
        night: 12,
        morn: 12,
        eve: 12)
    
    let dailyForecast = ADailyForecast(
        dt: 1234543,
        sunrise: 1235543,
        sunset: 1234123,
        humidity: 123,
        speed: 12,
        pop: 12,
        weather: [weather],
        temperature: temperature
    )
    
    let city = City(name: "Ktm")
    
    let forecastItem = AForecast(city: city, list: [dailyForecast])
    
    return forecastItem
}

