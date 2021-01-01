//
//  DailyForecastViewControllerTests.swift
//  AWeaatherIOSTests
//
//  Created by Alok Subedi on 31/12/2020.
//

import XCTest
@testable import AWeaatherIOS

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
        let (aForecast, forecastList) = makeItem()
        let forecast = forecastList[0]
        let city = City(name: aForecast.city.name)
        
        sut.loadViewIfNeeded()
        
        loader.completeLoading(with: (city, forecastList))
        
        XCTAssertEqual(sut.cityLabel.text, city.name)
        XCTAssertEqual(sut.todaysDateLabel.text, forecast.date)
        XCTAssertEqual(sut.todaysMinTemperatureLabel.text, "min: \(forecast.minTemperature)°")
        XCTAssertEqual(sut.todaysMaxTemperatureLabel.text, "max: \(forecast.maxTemperature)°")
        XCTAssertEqual(sut.currentTemperatureLabel.text, "\(forecast.dayTemperature)°")
    }
    
    func test_loadCompletion_onSuccessRendersTableViewCellWithForecasts(){
        let (sut, loader) = makeSut()
        let (aForecast, forecastList) = makeItem()
        let firstForecastInTable = forecastList[1]
        let city = City(name: aForecast.city.name)
        
        sut.loadViewIfNeeded()
        
        loader.completeLoading(with: (city, forecastList))
        
        XCTAssertEqual(forecastList.count-1, sut.forecastsCount)
        
        let cell = sut.getCell(at: 0)
        
        XCTAssertEqual(cell.dayLabel.text, firstForecastInTable.day)
        XCTAssertEqual(cell.weatherLabel.text, firstForecastInTable.weather)
        XCTAssertEqual(cell.maxTemperatureLabel.text,  "max:\( firstForecastInTable.maxTemperature)°")
        XCTAssertEqual(cell.minTemperatureLabel.text, "min:\( firstForecastInTable.minTemperature)°")
    }
    
    func test_loadCompletion_onFailureTableViewRemainsSame(){
        let (sut, loader) = makeSut()
        
        sut.loadViewIfNeeded()
        
        loader.completeLoadingWithFailure()
        
        XCTAssertEqual(sut.forecastsCount, 0)
    }
    
    
    private func makeSut() -> (sut: DailyForecastViewController, loader: ForecastLoaderSpy){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "dailyForecastViewController") as! DailyForecastViewController
        
        let loader = ForecastLoaderSpy()
        viewController.forecastLoader = loader
        
        return (viewController, loader)
    }
    
    class ForecastLoaderSpy: ForecastLoader{
        var loadCallCount = 0
        var completion: ((ForecastLoader.Result) -> ())?
    
        func load(completion: @escaping (ForecastLoader.Result) -> ()) {
            loadCallCount += 1
            self.completion = completion
        }
        
        func completeLoading(with item: ForecastRoot){
            completion?(.success(item))
        }
        
        func completeLoadingWithFailure(){
            completion?(.failure(NSError()))
        }
    }
}

private extension DailyForecastViewController{
    
    var forecastsCount: Int{
        return forecastTableView.numberOfRows(inSection: 0)
    }
    
    func getCell(at row: Int) -> ForecastTableViewCell{
        let cell = forecastTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ForecastTableViewCell
        return cell
    }
}
