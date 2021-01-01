//
//  DailyForecastFactory.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 01/01/2021.
//

import Foundation

class DailyForecastFactory{
    private static let WEATHER_URL_String = "http://api.openweathermap.org/data/2.5/forecast/daily?q=Kathmandu&units=metric&cnt=10&appid=4375694cabc41be5f7ebee4ecbd3fc03"
    
    static func dailyForecastViewController() -> DailyForecastViewController{
        let client = AWeatherHTTPClient()
        let url = URL(string: WEATHER_URL_String)!
        let remoteLoader = ARemoteForecastLoader(httpClient: client, url:url)
        let store = AWeatherCacheStore()
        let localLoader = ALocalForecastLoader(store: store)
        let forecastLoader = ARemoteWithLocalForecastLoader(remoteLoader: remoteLoader, localLoader: localLoader, localSaver: localLoader)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "dailyForecastViewController") as! DailyForecastViewController
        viewController.forecastLoader = forecastLoader
        return viewController
    }
}
