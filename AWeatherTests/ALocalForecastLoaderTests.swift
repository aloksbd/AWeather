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
    
    func forecastItem() -> AForecast{
        return makeItem().item
    }
    
    func anyNSError() -> NSError{
        return NSError(domain: "any error", code: 0)
    }
    
    
    class CacheStoreSpy: CacheStore{
        
        typealias DeletionCompletion = (Error?) -> Void
        typealias InsertionCompletion = (Error?) -> Void
        
        var deleteCacheCallCount = 0
        var insertCallCount = 0
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        
        func deleteCacheFeed(completion: @escaping DeletionCompletion){
            deleteCacheCallCount += 1
            deletionCompletions.append(completion)
        }
        
        func completeDeletion(with error: NSError,at index: Int = 0){
            deletionCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0){
            deletionCompletions[index](nil)
        }
        
        func insert(_ item: AForecast, completion: @escaping InsertionCompletion){
            insertCallCount += 1
            insertionCompletions.append(completion)
        }
        
        func completeInsertion(with error: NSError, at index: Int = 0){
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0){
            insertionCompletions[index](nil)
        }
    }
}
