//
//  AForecastItemMaker.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 20/12/2020.
//

import Foundation
import AWeather

func makeItem() -> (item: AForecast, json: [String : Any]){
    let weather = Weather(main: "sunny")
    let weatherJSON = [
        "main": weather.main
    ]
    
    let temperature = Temperature(
        min: "12",
        max: "12",
        day: "12",
        night: "12",
        morn: "12",
        eve: "12")
    let temperatureJSON = [
        "min": temperature.min,
        "max": temperature.max,
        "day": temperature.day,
        "night": temperature.night,
        "morn": temperature.morn,
        "eve": temperature.eve
    ]
    
    let dailyForecast = ADailyForecast(
        dt: "1234543",
        sunrise: "1235543",
        sunset: "1234123",
        humidity: "123",
        speed: "12",
        pop: "12%",
        snow: "32",
        weather: weather,
        temperature: temperature
    )
    let dailyForecastJSON = [
        "dt": dailyForecast.dt,
        "sunrise": dailyForecast.sunrise,
        "sunset": dailyForecast.sunset,
        "humidity": dailyForecast.humidity ?? "",
        "speed": dailyForecast.speed ?? "",
        "pop": dailyForecast.pop ?? "",
        "snow": dailyForecast.snow ?? "",
        "weather": weatherJSON,
        "temperature": temperatureJSON
    ] as [String : Any]
    
    let city = City(name: "Ktm")
    let cityJSON = ["name": city.name]
    
    let forecastItem = AForecast(city: city, list: [dailyForecast])
    let forecastItemJSON = [
        "city": cityJSON,
        "list": [dailyForecastJSON]
    ] as [String : Any]
    
    return(forecastItem, forecastItemJSON)
}

