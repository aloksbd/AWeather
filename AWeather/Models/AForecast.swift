//
//  AForecast.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

struct AForecast: Decodable, Equatable{
    private let city: City
    let forecastList: [ADailyForecast]
}
