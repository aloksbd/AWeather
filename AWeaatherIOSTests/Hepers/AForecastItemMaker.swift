//
//  AForecastItemMaker.swift
//  AWeaatherIOSTests
//
//  Created by Alok Subedi on 31/12/2020.
//

import Foundation
import AWeather
@testable import AWeaatherIOS

func makeItem() -> (item: AForecast, list: [Forecast]){
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
    
    let city = AWeather.City(name: "Ktm")
    
    let forecastItem = AForecast(city: city, list: [dailyForecast,dailyForecast])
    
    
    
    return (forecastItem, makeList(forecastItem))
}

private func makeList(_ forecast: AForecast) -> [Forecast]{
    var forecastList = [Forecast]()
    for item in forecast.list{
        forecastList.append(Forecast(dateTimeStamp: item.dt,
                                     sunriseTimeStamp: item.sunrise,
                                     sunsetTimeStamp: item.sunset,
                                     humidity: item.humidity,
                                     windSpeed: item.speed,
                                     rainChance: item.pop,
                                     weather: item.weather[0].main,
                                     minTemperature: item.temp.min,
                                     maxTemperature: item.temp.max,
                                     dayTemperature: item.temp.day,
                                     eveningTemperature: item.temp.eve,
                                     nightTemperature: item.temp.night,
                                     morningTemperature: item.temp.morn
                            )
        )
    }
    return forecastList
}

