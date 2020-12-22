//
//  ALocalForecastLoader.swift
//  AWeather
//
//  Created by Alok Subedi on 21/12/2020.
//

public class ALocalForecastLoader{
    private let store: CacheStore
    
    public init(store: CacheStore){
        self.store = store
    }
   
    private func cache(item: AForecast, completion: @escaping (Error?) -> ()){
        self.store.insert(item){ [weak self] error in
            guard  self != nil else{return}
            completion(error)
        }
    }
}

extension ALocalForecastLoader: AForcastCacheSaver{
    public func save(_ item: AForecast, completion: @escaping (Error?) -> ()){
        store.deleteCacheFeed{  [weak self ] error in
            guard let self = self else{return}
            if error == nil{
                self.cache(item: item, completion: completion)
            }else{
                completion(error)
            }
        }
    }
}

extension ALocalForecastLoader: AForecastLoader{
    public func load(completion: @escaping (AForecastLoader.Result) -> ()){
        store.retrieve{[weak self] result in
            guard self != nil else {return}
            switch result{
            case let .failure(error):
                completion(.failure(error))
            case let .success(forecast):
                completion(.success(forecast))
            }
       }
   }
}
