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
    
    //MARK: Helpers
    private func makeSut() -> (sut: ForecastRepository, loader: ForecastLoaderSpy){
        let loader = ForecastLoaderSpy()
        let sut = ForecastRepository(loader: loader)
        
        return(sut,loader)
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
        
        func completeLoadingWithFailure(){
            completion?(.failure(NSError()))
        }
    }
}
