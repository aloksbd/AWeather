//
//  DailyForecastViewControllerTests.swift
//  AWeaatherIOSTests
//
//  Created by Alok Subedi on 31/12/2020.
//

import XCTest
@testable import AWeaatherIOS
import AWeather

class DailyForecastViewControllerTests: XCTestCase {
    func test_init_doesNotAskToLoadForecast(){
        let (_,loader) = makeSut()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_asksToLoadForecast(){
        let (sut,loader) = makeSut()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_loadCompletion_onSuccessRendersTodaysForecast(){
        let (sut, loader) = makeSut()
        let forecast = makeItem()
        
        sut.loadViewIfNeeded()
        
        loader.completeLoading(with: forecast)
        
        XCTAssertEqual(sut.cityLabel.text, forecast.city.name)
        XCTAssertEqual(sut.todaysDateLabel.text, forecast.list[0].date())
        XCTAssertEqual(sut.todaysMinTemperatureLabel.text, "min: \(forecast.list[0].temp.min)°")
        XCTAssertEqual(sut.todaysMaxTemperatureLabel.text, "max: \(forecast.list[0].temp.max)°")
        XCTAssertEqual(sut.currentTemperatureLabel.text, "\(forecast.list[0].temp.day)°")
    }
    
    func test_loadCompletion_onSuccessRendersTableViewCellWithForecasts(){
        let (sut, loader) = makeSut()
        let forecast = makeItem()
        
        sut.loadViewIfNeeded()
        
        loader.completeLoading(with: forecast)
        
        XCTAssertEqual(forecast.list.count, sut.forecastsCount)
    }
    
    private func makeSut() -> (sut: DailyForecastViewController, loader: ForecastLoaderSpy){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "dailyForecastViewController") as! DailyForecastViewController
        
        let loader = ForecastLoaderSpy()
        viewController.forecastLoader = loader
        
        return (viewController, loader)
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
    }
}

private extension DailyForecastViewController{
    private var todaysForecastCount: Int{
        get{
            return 1
        }
    }
    
    var forecastsCount: Int{
        return forecastTableView.numberOfRows(inSection: 0) + todaysForecastCount
    }
}
