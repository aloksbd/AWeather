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
        store.deleteCacheFeed()
    }
}

class CacheStore{
    var deleteCacheCallCount = 0
    var insertCallCount = 0
    
    func deleteCacheFeed(){
        deleteCacheCallCount += 1
    }
    
    func deletion(with error: NSError,at index: Int = 0){
        
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
        store.deletion(with: deletionError)
        XCTAssertEqual(store.insertCallCount, 0)
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
