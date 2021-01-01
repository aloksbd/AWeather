//
//  ForecastRepositoryTests.swift
//  AWeaatherIOSTests
//
//  Created by Alok Subedi on 01/01/2021.
//

import XCTest
@testable import AWeaatherIOS
import AWeather

class ForecastRepositoryTests: XCTestCase {
    func test_init_doesNotAskToLoadForecastFromAForecastLoader(){
        let (_,loader) = makeSut()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_asksToLoadForecastFromAForecastLoader(){
        let (sut,loader) = makeSut()
        sut.load {_ in}
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_load_returnsForecastRootOnLoadSuccessful(){
        
        let (sut, loader) = makeSut()
        
        let (item, list) = makeItem()
        let exp = expectation(description: "wait for load")
        
        sut.load{result in
            switch result{
            case let .success(root):
                XCTAssertEqual(root?.city.name, item.city.name)
                XCTAssertEqual(root?.list, list)
            default:
                XCTFail("should give item")
            }
            exp.fulfill()
        }
        
        loader.completeLoading(with: item)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_returnsErrorOnFailure(){
        let (sut, loader) = makeSut()
        let expectedError = anyNSError()
        
        let exp = expectation(description: "wait for load")
        
        sut.load{result in
            switch result{
            case let .failure(error):
                XCTAssertEqual(error as NSError, expectedError)
            default:
                XCTFail("should give error")
            }
            exp.fulfill()
        }
        
        loader.completeLoadingWithFailure(expectedError)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: Helpers
    private func makeSut() -> (sut: ForecastRepository, loader: ForecastLoaderSpy){
        let loader = ForecastLoaderSpy()
        let sut = ForecastRepository(loader: loader)
        
        return(sut,loader)
    }
    
    private func anyNSError() -> NSError{
        return NSError(domain: "any error", code: 0)
    }
    
    class ForecastLoaderSpy: AForecastLoader{
        var loadCallCount = 0
        var completion: ((Result<AForecast?, Error>) -> ())?
        
        func load(completion: @escaping (Result<AForecast?, Error>) -> ()) {
            loadCallCount += 1
            self.completion = completion
        }
        
        func completeLoading(with item: AForecast){
            completion?(.success(item))
        }
        
        func completeLoadingWithFailure(_ error: NSError){
            completion?(.failure(error))
        }
    }
}
