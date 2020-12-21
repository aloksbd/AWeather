//
//  AWeatherCacheStoreTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest
import AWeather

class AWeatherCacheStoreTests: XCTestCase {

    func test_retrieve_deliversNilOnEmptyCache(){
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for retrieval block")
        
        sut.retrieve { result in
            switch result{
            case .failure(_):
                XCTFail("expected nil")
            case let .success(forecast):
                XCTAssertNil(forecast)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValue(){
        let sut = makeSUT()
        let item = forecastItem()

        let exp = expectation(description: "wait for retrieval block")

        sut.insert(item) { insertionError in
            XCTAssertNil(insertionError, "expected item to be inserted successfully")
            sut.retrieve { retrieveResult in
                switch (retrieveResult){
                case let .success(forecast):
                    XCTAssertEqual(forecast, item)
                default:
                    XCTFail("expected success with \(item)")
                }
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_deliversSameForecastTwiceOnNonEmptyCache(){
        let sut = makeSUT()
        let item = forecastItem()
        
        let exp = expectation(description: "wait for retrieval block")
        
        sut.insert(item) { insertionError in
            XCTAssertNil(insertionError, "expected item to be inserted successfully")
            sut.retrieve { firstRetrieveResult in
                sut.retrieve { secondRetrieveResult in
                    switch (firstRetrieveResult, secondRetrieveResult){
                    case let (.success(firstForecast), .success(secondForecast)):
                        XCTAssertEqual(firstForecast, item)
                        XCTAssertEqual(firstForecast, secondForecast)
                    default:
                        XCTFail("expected success with \(item)")
                    }
                    exp.fulfill()
                }
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_deliversErrorOnRetrievalError(){
        let userDefault = UserDefaultsSpy()
        let sut = AWeatherCacheStore(userDefaults: userDefault)
        
        userDefault.setValue(Data("data".utf8), forKey: "cache")
        
        let exp = expectation(description: "wait for retrieval block")
        
        sut.retrieve { retrieveResult in
            switch (retrieveResult){
            case let .failure(error):
                XCTAssertNotNil(error)
            default:
                XCTFail("expected failure")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_delete_doesNothingOnEmptyCache(){
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for deletion block")
        
        sut.deleteCacheFeed{ deletionError in
            XCTAssertNil(deletionError, "expected item to be deleted successfully")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func test_delete_emptiesPreviouslyInsertedCache(){
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for deletion block")
        
        sut.insert(forecastItem()){ insertionError in
            XCTAssertNil(insertionError, "expected item to be inserted successfully")
            sut.deleteCacheFeed{
                deletionError in
                XCTAssertNil(deletionError, "expected item to be deleted successfully")
                sut.retrieve{retrievalResult in
                    switch retrievalResult{
                    case let .success(forecast):
                        XCTAssertNil(forecast)
                    default:
                        XCTFail("expected nil forecast")
                    }
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    //MARK: Helpers
    
    private func makeSUT() -> AWeatherCacheStore{
        let sut = AWeatherCacheStore(userDefaults: UserDefaultsSpy())
        trackForMemoryLeak(sut)
        return sut
    }
    
    class UserDefaultsSpy : UserDefaults {
        
        private var savedData: Any?
        
        convenience init() {
            self.init(suiteName: "spyUserDefaults")!
        }
        
        override init?(suiteName suitename: String?) {
            UserDefaults().removePersistentDomain(forName: suitename!)
            super.init(suiteName: suitename)
        }
        
        override func setValue(_ value: Any?, forKey key: String) {
            savedData = value
        }
        
        override func data(forKey defaultName: String) -> Data? {
            return savedData as? Data
        }
        
        override func removeObject(forKey defaultName: String) {
            savedData = nil
        }
    }
    
}
