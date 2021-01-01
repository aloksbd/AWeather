//
//  ForecastRepository.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 01/01/2021.
//

import Foundation
import AWeather

typealias ForecastRoot = (city: City, list: Forecast)

protocol ForecastLoader{
    typealias Result = Swift.Result<ForecastRoot?, Error>
    
    func load(completion: @escaping (Result) -> ())
}

class ForecastRepository: ForecastLoader{
    
    private var loader: AForecastLoader
    
    init(loader: AForecastLoader){
        self.loader = loader
    }
    
    func load(completion: @escaping (ForecastLoader.Result) -> ()) {
        loader.load{ _ in}
    }
}
