//
//  CacheStoreSpy.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import AWeather
import Foundation

class CacheStoreSpy: CacheStore{
    
    var deleteCacheCallCount = 0
    var insertCallCount = 0
    var retrieveCallCount = 0
    
    private var deletionCompletions = [CacheStore.DeletionCompletion]()
    private var insertionCompletions = [CacheStore.InsertionCompletion]()
    private var retrievalCompletions = [(CacheStore.RetrievalResult) -> ()]()
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion){
        deleteCacheCallCount += 1
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: NSError,at index: Int = 0){
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0){
        deletionCompletions[index](nil)
    }
    
    func insert(_ item: AForecast, completion: @escaping InsertionCompletion){
        insertCallCount += 1
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(with error: NSError, at index: Int = 0){
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0){
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping (CacheStore.RetrievalResult) -> ()) {
        retrieveCallCount += 1
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0){
        retrievalCompletions[index](.failure(error))
    }

    func completeRetrievalWithEmptyCache(at index: Int = 0){
        retrievalCompletions[index](.success(nil))
    }

    func completeRetrieval(with item: AForecast, at index: Int = 0){
        retrievalCompletions[index](.success(item))
    }
}
