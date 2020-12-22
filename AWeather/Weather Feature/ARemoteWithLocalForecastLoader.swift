//
//  ARemoteWithLocalForecastLoader.swift
//  AWeather
//
//  Created by Alok Subedi on 21/12/2020.
//

import Foundation

public class ARemoteWithLocalForecastLoader: AForecastLoader{
    private var remoteLoader: AForecastLoader
    private var localLoader: AForecastLoader
    private var localSaver: AForcastCacheSaver
    
    public enum Error: Swift.Error{
        case cacheError
    }
    
    public init (remoteLoader: AForecastLoader, localLoader: AForecastLoader, localSaver: AForcastCacheSaver){
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
        self.localSaver = localSaver
    }
    
    public func load(completion: @escaping (Result<AForecast?, Swift.Error>) -> ()) {
        remoteLoader.load{[weak self] result in
            guard  let self = self else{return}
            switch result{
            case .failure(_):
                self.localLoader.load(completion: completion)
            case let .success(forecast):
                if let forecast = forecast{
                    self.localSaver.save(forecast){_ in}
                }
                completion(.success(forecast))
            }
        }
    }
}
