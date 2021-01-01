//
//  ForecastRepository.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 01/01/2021.
//

import Foundation
import AWeather

typealias ForecastRoot = (city: City, list: [Forecast])

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
        loader.load{[weak self] result in
            guard self != nil else {return}
            switch result{
            case let .success(forecast):
                if let forecast = forecast{
                    completion(.success(Mapper.map(forecast)))
                }else{
                    completion(.success(nil))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private class Mapper{
    static func map(_ forecast: AForecast) -> ForecastRoot{
        let city = City(name: forecast.city.name)
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
        return (city, forecastList)
    }
}
