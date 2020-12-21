//
//  ALocalForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest
import AWeather

class ALocalForecastLoader{
    private let store: CacheStore
    init(store: CacheStore){
        self.store = store
    }
    
    func save(_ items: AForecast){
        store.deleteCacheFeed{ [unowned self ] error in
            if error == nil{
                self.store.insert(items)
            }
        }
    }
}

class CacheStore{
    typealias DeletionCompletion = (Error?) -> Void
    var deleteCacheCallCount = 0
    var insertCallCount = 0
    
    private var deletionCompletions = [DeletionCompletion]()
    
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
    
    func insert(_ items: AForecast){
        insertCallCount += 1
    }
}

class ALocalForecastLoaderTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation(){
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCacheCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion(){
        let (sut, store) = makeSUT()
        let item = forecastItem()
        sut.save(item)
        XCTAssertEqual(store.deleteCacheCallCount, 1)
    }
    
    func test_save_doesNotRequestsCacheInsertionOnDeletionError(){
        let (sut, store) = makeSUT()
        let item = forecastItem()
        let deletionError = anyNSError()
        
        sut.save(item)
        store.completeDeletion(with: deletionError)
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    func test_save_requestsCacheInsertionOnDeletionSuccess(){
        let (sut, store) = makeSUT()
        let item = forecastItem()
        
        sut.save(item)
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.insertCallCount, 1 )
    }
    
    //MARK: helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut:ALocalForecastLoader, store: CacheStore){
        let store = CacheStore()
        let sut = ALocalForecastLoader(store: store)
        
        trackForMemoryLeak(store,file: file, line: line)
        trackForMemoryLeak(sut,file: file, line: line)
        
        return (sut,store)
    }
    
    func forecastItem() -> AForecast{
        return makeItem().item
    }
    
    func anyNSError() -> NSError{
        return NSError(domain: "any error", code: 0)
    }
}
