//
//  AForecastLoader.swift
//  AWeather
//
//  Created by Alok Subedi on 20/12/2020.
//

public protocol AForecastLoader{
    typealias Result = Swift.Result<AForecast?, Error>
    
    func load(completion: @escaping (AForecastLoader.Result) -> ())
}
