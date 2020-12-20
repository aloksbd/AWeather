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
    
    enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    
    init(httpClient: HTTPClientSpy, url: URL){
        self.httpClient = httpClient
        self.url = url
    }
    
    func load(completion: @escaping (Error) -> ()){
        httpClient.get(from: url){ error,response  in
            if response != nil{
                completion(.invalidData)
            }else{
                completion(.connectivity)
            }
        }
    }
}

class HTTPClientSpy{
    var requestedUrls = [URL]()
    var completions = [(Error?, HTTPURLResponse?) -> ()]()
    
    func get(from url: URL,completion: @escaping (Error?, HTTPURLResponse?) -> ()) {
        completions.append(completion)
        requestedUrls.append(url)
    }
    
    func complete(with error: Error, at index: Int = 0){
        completions[index](error, nil)
    }
    
    func complete(withStatusCode code: Int, at  index: Int = 0){
        let response = HTTPURLResponse(url: requestedUrls[index], statusCode: code,
            httpVersion: nil,
            headerFields: nil)
        completions[index](nil,response)
    }
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
        
        sut.load{_ in}
        XCTAssertNotNil(client.requestedUrls)
    }
    
    func test_load_requestDataFromUrlTwice(){
        let url = URL(string: "https://url.com")!
        let (sut,client) = makeSUT(url: url)
        
        sut.load{_ in}
        sut.load{_ in}
        XCTAssertEqual(client.requestedUrls, [url,url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut,client) = makeSUT()
        
        var capturedError = [ARemoteForecastLoader.Error]()
        sut.load{ capturedError.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorOnFailure(){
        let (sut,client) = makeSUT()
        
        var capturedError = [ARemoteForecastLoader.Error]()
        sut.load{ capturedError.append($0) }
        
        client.complete(withStatusCode: 400)
        
        XCTAssertEqual(capturedError, [.invalidData])
    }
    
    //MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://url.com")!) -> (sut: ARemoteForecastLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = ARemoteForecastLoader(httpClient: client, url: url)
        return (sut,client)
    }
}
