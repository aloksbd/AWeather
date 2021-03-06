//
//  CacheStore.swift
//  AWeather
//
//  Created by Alok Subedi on 21/12/2020.
//

public protocol CacheStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalResult = Swift.Result<AForecast?, Error>
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion)
    func insert(_ item: AForecast, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping (RetrievalResult) -> ())
}
