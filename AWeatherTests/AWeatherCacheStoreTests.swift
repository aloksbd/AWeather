//
//  AWeatherCacheStoreTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest
import AWeather

class AWeatherCacheStore{
    private let CACHE = "cache"
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard){
        self.userDefaults = userDefaults
    }
    
    func retrieve(completion: @escaping (CacheStore.RetrievalResult) -> ()){
        guard let data = userDefaults.data(forKey: CACHE) else {
            return completion(.success(nil))
        }
        let cacheForecast = try! JSONDecoder().decode(AForecast.self, from: data)
        completion(.success(cacheForecast))
        
    }
    
    func insert(_ item: AForecast, completion: @escaping CacheStore.InsertionCompletion){
        guard let data = try? JSONEncoder().encode(item) else {
            return completion(anyNSError())
        }
        userDefaults.setValue(data, forKey: CACHE)
        completion(nil)
    }
}

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
            XCTAssertNil(insertionError, "expected feed to be inserted successfully")
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
            XCTAssertNil(insertionError, "expected feed to be inserted successfully")
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
    }
    
}
