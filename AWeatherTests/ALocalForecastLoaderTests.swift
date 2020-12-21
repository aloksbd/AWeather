//
//  ALocalForecastLoaderTests.swift
//  AWeatherTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest
import AWeather

class ALocalForecastLoaderTests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation(){
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCacheCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion(){
        let (sut, store) = makeSUT()
        let item = forecastItem()
        sut.save(item){_ in}
        XCTAssertEqual(store.deleteCacheCallCount, 1)
    }
    
    func test_save_doesNotRequestsCacheInsertionOnDeletionError(){
        let (sut, store) = makeSUT()
        let item = forecastItem()
        let deletionError = anyNSError()
        
        sut.save(item){_ in}
        store.completeDeletion(with: deletionError)
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    func test_save_requestsCacheInsertionOnDeletionSuccess(){
        let (sut, store) = makeSUT()
        let item = forecastItem()
        
        sut.save(item){_ in}
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.insertCallCount, 1 )
    }
    
    func test_save_failsOnDeletionError(){
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut: sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError(){
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut: sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succedsOnSuccessfulInsertion(){
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doeesnotDeliverDeletionErrorAfterSUTInstanceIsDeallocated(){
        let store = CacheStoreSpy()
        var sut: ALocalForecastLoader? = ALocalForecastLoader(store: store)
        
        var receivedResults = [Error?]()
        sut?.save(forecastItem()) {receivedResults.append($0)}
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doeesnotDeliverInsertionErrorAfterSUTInstanceIsDeallocated(){
        let store = CacheStoreSpy()
        var sut: ALocalForecastLoader? = ALocalForecastLoader(store: store)
        
        var receivedResults = [Error?]()
        sut?.save(forecastItem()) {receivedResults.append($0)}
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_load_requestCacheRetrieval(){
        let (sut,store) = makeSUT()

        sut.load() {_ in}

        XCTAssertEqual(store.retrieveCallCount, 1)
    }

    func test_load_failsOnRetrievalError(){
        let (sut,store) = makeSUT()
        let retrievalError = anyNSError()
        expect(sut: sut, toCompleteWith: .failure(anyNSError()), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }

    func test_load_deliversNilOnEmptyCache(){
        let (sut,store) = makeSUT()
        expect(sut: sut, toCompleteWith: .success(nil), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }

    func test_load_deliversCachedForecastOnSuccess(){
        let (sut,store) = makeSUT()
        expect(sut: sut, toCompleteWith: .success(forecastItem()), when: {
            store.completeRetrieval(with: forecastItem())
        })
    }
    
    //MARK: helpers
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut:ALocalForecastLoader, store: CacheStoreSpy){
        let store = CacheStoreSpy()
        let sut = ALocalForecastLoader(store: store)
        
        trackForMemoryLeak(store,file: file, line: line)
        trackForMemoryLeak(sut,file: file, line: line)
        
        return (sut,store)
    }
    
    func expect(sut: ALocalForecastLoader, toCompleteWithError expectedError: NSError?, when action: () -> (),file: StaticString = #file, line: UInt = #line){
        let exp = expectation(description: "Wait for the block")
        var receivedError: Error?
        sut.save(forecastItem()) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, expectedError)
    }
    
    func expect(sut: ALocalForecastLoader, toCompleteWith expectedResult: ALocalForecastLoader.Result, when action: () -> (), file: StaticString = #file, line: UInt = #line){
        let exp = expectation(description: "Wait for the block")

        sut.load(){ recievedResult in
            switch (recievedResult, expectedResult){
                case let (.success(recievedImages), .success(expectedImages)):
                    XCTAssertEqual(recievedImages, expectedImages, file: file, line: line)
                case let (.failure(recievedError as NSError?), .failure(expectedError as NSError?)):
                    XCTAssertEqual(recievedError, expectedError, file: file, line: line)
                default:
                    XCTFail("expected \(expectedResult), got \(recievedResult) instead")
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
}


