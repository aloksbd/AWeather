//
//  ForecastLoader.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 01/01/2021.
//

typealias ForecastRoot = (city: City, list: [Forecast])

protocol ForecastLoader{
    typealias Result = Swift.Result<ForecastRoot?, Error>
    
    func load(completion: @escaping (Result) -> ())
}
