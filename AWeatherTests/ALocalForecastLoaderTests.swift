//
//  ALocalForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest


class ALocalForecastLoader{
    init(store: LocalStore){
        
    }
}

class LocalStore{
    var deletCacheFeedCallCount = 0
}

class ALocalForecastLoaderTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation(){
        let store = LocalStore()
        _ = ALocalForecastLoader(store: store)
        
        XCTAssertEqual(store.deletCacheFeedCallCount, 0)
    }
}
