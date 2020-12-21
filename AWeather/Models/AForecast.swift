//
//  AForecast.swift
//  AWeather
//
//  Created by Alok Subedi on 19/12/2020.
//

public struct AForecast: Codable, Equatable{
    public let city: City
    public let list: [ADailyForecast]
    
    public init(city: City, list: [ADailyForecast]){
        self.city = city
        self.list = list
    }
}
