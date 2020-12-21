//
//  AWeatherCacheStore.swift
//  AWeather
//
//  Created by Alok Subedi on 21/12/2020.
//

import Foundation


public class AWeatherCacheStore: CacheStore{
    private let CACHE = "cache"
    
    private let userDefaults: UserDefaults
    
    public enum Error: Swift.Error{
        case insertionError
        case invalidCache
    }
    
    public init(userDefaults: UserDefaults = UserDefaults.standard){
        self.userDefaults = userDefaults
    }
    
    public func retrieve(completion: @escaping (CacheStore.RetrievalResult) -> ()){
        guard let data = userDefaults.data(forKey: CACHE) else {
            return completion(.success(nil))
        }
        if let cacheForecast = try? JSONDecoder().decode(AForecast.self, from: data){
            completion(.success(cacheForecast))
        }else{
            completion(.failure(Error.invalidCache))
        }
        
    }
    
    public func insert(_ item: AForecast, completion: @escaping CacheStore.InsertionCompletion){
        guard let data = try? JSONEncoder().encode(item) else {
            return completion(Error.insertionError)
        }
        userDefaults.setValue(data, forKey: CACHE)
        completion(nil)
    }
    
    public func deleteCacheFeed(completion: @escaping CacheStore.DeletionCompletion){
        userDefaults.removeObject(forKey: CACHE)
        completion(nil)
    }
        
}
