//
//  AForecast.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct AForecast: Decodable, Equatable{
    public let city: City
    public let forecastList: [ADailyForecast]
    
    public init(city: City, forecastList: [ADailyForecast]){
        self.city = city
        self.forecastList = forecastList
    }
}
