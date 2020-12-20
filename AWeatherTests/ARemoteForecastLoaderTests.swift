//
//  ARemoteForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 19/12/2020.
//

import XCTest
@testable import AWeather

class ARemoteForecastLoader{
    private var url: URL
    private var httpClient: HTTPClientSpy
    
    init(httpClient: HTTPClientSpy, url: URL){
        self.httpClient = httpClient
        self.url = url
    }
    
    func load(){
        httpClient.requestedUrls.append(url)
    }
}

class HTTPClientSpy{
    var requestedUrls = [URL]()
}

class ARemoteForecastLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromUrl(){
        let url = URL(string: "https://url.com")!
        let (_,client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedUrls.isEmpty)
    }
    
    func test_load_requestDataFromUrl(){
        let url = URL(string: "https://url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load()
        XCTAssertNotNil(client.requestedUrls)
    }
    
    func test_load_requestDataFromUrlTwice(){
        let url = URL(string: "https://url.com")!
        let (sut,client) = makeSUT(url: url)

        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedUrls, [url,url])
    }
    
    //MARK: Helpers
    
    private func makeSUT(url: URL) -> (sut: ARemoteForecastLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = ARemoteForecastLoader(httpClient: client, url: url)
        return (sut,client)
    }
}
