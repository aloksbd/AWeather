//
//  AWeatherHTTPClientTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 20/12/2020.
//

import XCTest
import AWeather

class AWeatherHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_performsGetRequestWithURL(){
        let url = anyURL()
        let exp = expectation(description: "Wait for block")
        
        URLProtocolStub.observeRequest{ request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in}

        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError(){
        let requestError = anyNSError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
        XCTAssertNotNil(receivedError)
    }
    
    func test_getFromURL_failsOnAllInvalidCases(){
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData(){
        let data = anyData()
        let response = anyHTTPURLResponse()
        let receivedValue = resultValuesFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(receivedValue?.data, data)
        XCTAssertEqual(receivedValue?.response.statusCode, response.statusCode)
        XCTAssertEqual(receivedValue?.response.url, response.url)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData(){
        let response = anyHTTPURLResponse()
        let receivedValue = resultValuesFor(data: nil, response: response, error: nil)
        
        let emptyData = Data()
        XCTAssertEqual(receivedValue?.data, emptyData)
        XCTAssertEqual(receivedValue?.response.statusCode, response.statusCode)
        XCTAssertEqual(receivedValue?.response.url, response.url)
    }
    
    // MARK: Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient{
        let sut = AWeatherHTTPClient()
        trackForMemoryLeak(sut,file: file, line: line)
        return sut
    }
    
    private func anyData() -> Data{
        return Data("any data".utf8)
    }
    
    private func nonHTTPURLResponse() -> URLResponse{
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse{
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error?{
        let result = resultFor(data: data, response: response, error: error, file:file, line: line)
        
        switch result{
        case let .failure(error):
             return error
        default:
            XCTFail("expected failure, got \(result)",file: file, line: line)
            return nil
        }
    }
    
    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)?{
        let result = resultFor(data: data, response: response, error: error, file:file, line: line)
        
        switch result{
        case let .success((receivedData, receivedResponse)):
             return(receivedData,receivedResponse)
        default:
            XCTFail("expected success, got \(result)",file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClient.Result{
        URLProtocolStub.stub( data: data, response: response, error: error)
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClient.Result!
        sut.get(from: anyURL()){ result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }

    func anyURL() -> URL{
        return URL(string: "https://any-url.com")!
    }
    
    private class URLProtocolStub: URLProtocol{
        static private var stub: Stub?
        private static var requestObserver: ((URLRequest) -> ())?
        private struct Stub{
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub( data: Data?, response: URLResponse?, error: Error?){
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequest (_ observer: @escaping (URLRequest) -> ()){
            requestObserver = observer
        }
        
        static func startInterceptingRequests(){
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests(){
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver{
                client?.urlProtocolDidFinishLoading(self)
                requestObserver(request)
            }
            if let data = URLProtocolStub.stub?.data{
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response{
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error{
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}

