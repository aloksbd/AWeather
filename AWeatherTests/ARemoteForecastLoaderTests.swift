//
//  ARemoteForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 19/12/2020.
//

import XCTest
@testable import AWeather

protocol AForecastLoader{
    typealias Result = Swift.Result<AForecast, Error>

    func load(completion: @escaping (AForecastLoader.Result) -> ())
}

class ARemoteForecastLoader: AForecastLoader{
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
    
    func load(completion: @escaping (AForecastLoader.Result) -> ()){
        httpClient.get(from: url){ result  in
            switch result{
            case let .failure(_):
                completion(.failure(Error.connectivity))
            case  let .success(data):
                if let data = data{
                    if let forecast = try? JSONDecoder().decode(AForecast.self, from: data){
                        completion(.success(forecast))
                    }else{
                        completion(.failure(Error.invalidData))
                    }
                }else{
                    completion(.failure(Error.invalidData))
                }
            }
        }
    }
}

protocol HTTPClient{
    typealias Result = Swift.Result<Data?, Error>
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> ())
}

class HTTPClientSpy: HTTPClient{
    
    var requestedUrls = [URL]()
    var completions = [(HTTPClient.Result) -> ()]()
    
    func get(from url: URL,completion: @escaping (HTTPClient.Result) -> ()) {
        completions.append(completion)
        requestedUrls.append(url)
    }
    
    func complete(with error: Error, at index: Int = 0){
        completions[index](.failure(error))
    }
    
    func complete(withStatusCode code: Int, with data: Data, at  index: Int = 0){
        completions[index](.success(data))
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
        sut.load{ result in
            switch result{
            case let .failure(error as ARemoteForecastLoader.Error):
                capturedError.append(error)
            default:
                
                break
            }
        }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200Response(){
        let (sut,client) = makeSUT()
        
        let codes = [100,199,300,404,500]
        codes.enumerated().forEach { (index, code) in
            var capturedError = [ARemoteForecastLoader.Error]()
            sut.load{ result in
                switch result{
                case let .failure(error as ARemoteForecastLoader.Error):
                    capturedError.append(error)
                default:
                    break
                }
            }
            
            client.complete(withStatusCode: code, with: Data(), at: index)
            XCTAssertEqual(capturedError, [.invalidData])
        }
    }
    
    //MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://url.com")!) -> (sut: ARemoteForecastLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = ARemoteForecastLoader(httpClient: client, url: url)
        return (sut,client)
    }
}
