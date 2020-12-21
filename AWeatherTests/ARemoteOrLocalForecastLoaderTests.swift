//
//  ARemoteOrLocalForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest
import AWeather

class ARemoteOrLocalForecastLoader{
    private var remoteLoader: AForecastLoader
    private var localLoader: AForecastLoader
    
    init (remoteLoader: AForecastLoader, localLoader: AForecastLoader){
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
    }
    
    func load(completion: @escaping (Result<AForecast?, Error>) -> ()) {
        remoteLoader.load{_ in}
    }
}

class ARemoteForecastLoaderSpy: AForecastLoader{
    var loadCallCount = 0
    
    func load(completion: @escaping (Result<AForecast?, Error>) -> ()) {
        loadCallCount += 1
    }
}

class ALocalForecastLoaderSpy: AForecastLoader{
    
    var loadCallCount = 0
    
    func load(completion: @escaping (Result<AForecast?, Error>) -> ()) {
        
    }
    
    
}



class ARemoteOrLocalForecastLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromLocalOrRemote(){
        let (_, localLoader,remoteLoader)  = makeSUT()
        
        XCTAssertEqual(remoteLoader.loadCallCount, 0)
        XCTAssertEqual(localLoader.loadCallCount, 0)
    }
    
    func test_load_callLoadOnRemoteOnce(){
        let (sut, localLoader,remoteLoader)  = makeSUT()
        
        sut.load{_ in}
        
        XCTAssertEqual(remoteLoader.loadCallCount, 1)
        XCTAssertEqual(localLoader.loadCallCount, 0)
        
    }
    
    //MARK: helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ARemoteOrLocalForecastLoader, localLoader: ALocalForecastLoaderSpy, remoteLoader: ARemoteForecastLoaderSpy){
        
        let localLoader = ALocalForecastLoaderSpy()
        let remoteLoader = ARemoteForecastLoaderSpy()
        let sut = ARemoteOrLocalForecastLoader(remoteLoader: remoteLoader, localLoader: localLoader)
        
        trackForMemoryLeak(localLoader, file: file, line: line)
        trackForMemoryLeak(remoteLoader, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, localLoader, remoteLoader)
    }
}
