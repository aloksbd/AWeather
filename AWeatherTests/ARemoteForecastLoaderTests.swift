//
//  ARemoteForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 19/12/2020.
//

import XCTest
@testable import AWeather

class ARemoteForecastLoader{
    private var httpClient: HTTPClientSpy
    
    init(httpClient: HTTPClientSpy){
        self.httpClient = httpClient
    }
    
    func load(){
        httpClient.requestedUrls.append(URL(string: "https://url.com")!)
    }
}

class HTTPClientSpy{
    var requestedUrls = [URL]()
}

class ARemoteForecastLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromUrl(){
        let httpClient = HTTPClientSpy()
        _ = ARemoteForecastLoader(httpClient: httpClient)
        
        XCTAssertTrue(httpClient.requestedUrls.isEmpty)
    }
    
    func test_load_requestDataFromUrl(){
        let client = HTTPClientSpy()
        let sut = ARemoteForecastLoader(httpClient: client)
        
        sut.load()
        XCTAssertNotNil(client.requestedUrls)
    }
}
