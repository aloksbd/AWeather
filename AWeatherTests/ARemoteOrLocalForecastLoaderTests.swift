//
//  ARemoteOrLocalForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest
import AWeather

class ARemoteOrLocalForecastLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromLocalOrRemote(){
        let (_, localLoader,remoteLoader)  = makeSUT()
        
        XCTAssertEqual(remoteLoader.loadCallCount, 0)
        XCTAssertEqual(localLoader.loadCallCount, 0)
    }
    
    func test_load_callLoadOnRemoteOnce(){
        let (sut, localLoader,remoteLoader) = makeSUT()
        
        sut.load{_ in}
        
        XCTAssertEqual(remoteLoader.loadCallCount, 1)
        XCTAssertEqual(localLoader.loadCallCount, 0)
        
    }
    
    func test_load_callLoadOnLocalOnceIfRemoteGivesError(){
        let (sut, localLoader,remoteLoader) = makeSUT()
        
        sut.load{_ in}
        
        remoteLoader.completeWithError()
        
        XCTAssertEqual(remoteLoader.loadCallCount, 1)
        XCTAssertEqual(localLoader.loadCallCount, 1)
    }
    
    func test_load_returnsForecastOnRemoteLoadSuccessful(){
        
        let (sut, localLoader,remoteLoader) = makeSUT()
        
        let item = forecastItem()
        let exp = expectation(description: "wait for load")
        
        sut.load{result in
            switch result{
            case let .success(forecast):
                XCTAssertEqual(item, forecast)
            default:
                XCTFail("should give item")
            }
            exp.fulfill()
        }
        remoteLoader.complete(with: item)
        
        XCTAssertEqual(remoteLoader.loadCallCount, 1)
        XCTAssertEqual(localLoader.loadCallCount, 0)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_deliversErrorIfLocalLoaderGivesError(){
        let (sut, localLoader,remoteLoader) = makeSUT()
        
        let exp = expectation(description: "wait for load")
        
        sut.load{result in
            switch result{
            case let .failure(error):
               XCTAssertNotNil(error)
            default:
                XCTFail("should give error")
            }
            exp.fulfill()
        }
        remoteLoader.completeWithError()
        localLoader.completeWithError()
        
        XCTAssertEqual(remoteLoader.loadCallCount, 1)
        XCTAssertEqual(localLoader.loadCallCount, 1)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func returnsForecastOnLocalLoadSuccessful(){
        let (sut, localLoader,remoteLoader) = makeSUT()
        let item = forecastItem()
        
        let exp = expectation(description: "wait for load")
        
        sut.load{result in
            switch result{
            case let .success(forecast):
                XCTAssertEqual(item, forecast)
            default:
                XCTFail("should give item")
            }
            exp.fulfill()
        }
        remoteLoader.completeWithError()
        localLoader.complete(with: item)
        
        XCTAssertEqual(remoteLoader.loadCallCount, 1)
        XCTAssertEqual(localLoader.loadCallCount, 1)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ARemoteWithLocalForecastLoader, localLoader: ALocalForecastLoaderSpy, remoteLoader: ARemoteForecastLoaderSpy){
        
        let localLoader = ALocalForecastLoaderSpy()
        let remoteLoader = ARemoteForecastLoaderSpy()
        let sut = ARemoteWithLocalForecastLoader(remoteLoader: remoteLoader, localLoader: localLoader)
        
        trackForMemoryLeak(localLoader, file: file, line: line)
        trackForMemoryLeak(remoteLoader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, localLoader, remoteLoader)
    }
    
    
    class AforecastLoaderSpy: AForecastLoader{
        var loadCallCount = 0
        var completion: ((AForecastLoader.Result) -> ())? = nil
        
        func load(completion: @escaping (AForecastLoader.Result) -> ()) {
            loadCallCount += 1
            if self.completion == nil{
                self.completion = completion
            }
        }
        
        func completeWithError(){
            if let completion = completion{
                completion(.failure(anyNSError()))
            }
        }
        
        func complete(with item: AForecast){
            if let completion = completion{
                completion(.success(item))
            }
        }
    }

    class ARemoteForecastLoaderSpy: AforecastLoaderSpy{}

    class ALocalForecastLoaderSpy: AforecastLoaderSpy{}
}
