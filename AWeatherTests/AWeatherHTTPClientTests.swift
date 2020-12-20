//
//  AWeatherHTTPClientTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 20/12/2020.
//

import XCTest

class AWeatherHTTPClient{
    private let session: URLSession
    
    init(session: URLSession){
        self.session = session
    }
    
    func get(from url: URL){
        session.dataTask(with: url){_,_,_ in}
    }
}

class AWeatherHTTPClientTests: XCTestCase {
    func test_getFromURL_createsDataTaskWithURL(){
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = AWeatherHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.recievedURLs, [url])
    }
    
    // MARK: Helper
    
    private class URLSessionSpy: URLSession{
        var recievedURLs = [URL]()
        
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            recievedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask{}
}
