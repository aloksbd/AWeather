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
    var deletCacheCallCount = 0
    
    func deleteCacheFeed(){
        deletCacheCallCount += 1
    }
}

class ALocalForecastLoaderTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation(){
        let store = CacheStore()
        _ = ALocalForecastLoader(store: store)
        
        XCTAssertEqual(store.deletCacheCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion(){
        let store = CacheStore()
        let sut = ALocalForecastLoader(store: store)
        let item = forecastItem()
        sut.save(item)
        XCTAssertEqual(store.deletCacheCallCount, 1)
    }
    
    //MARK: helpers
    
    func forecastItem() -> AForecast{
        return makeItem().item
    }
}
