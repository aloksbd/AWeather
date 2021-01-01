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
        let (forecast,_) = makeItem()
        
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
        let (forecast,_) = makeItem()
        
        sut.loadViewIfNeeded()
        
        loader.completeLoading(with: forecast)
        
        XCTAssertEqual(forecast.list.count-1, sut.forecastsCount)
        
        let cell = sut.getCell(at: 0)
        let firstForecastInTable = forecast.list[1]
        XCTAssertEqual(cell.dayLabel.text, firstForecastInTable.day())
        XCTAssertEqual(cell.weatherLabel.text, firstForecastInTable.weather[0].main)
        XCTAssertEqual(cell.maxTemperatureLabel.text,  "max:\( firstForecastInTable.temp.max)°")
        XCTAssertEqual(cell.minTemperatureLabel.text, "min:\( firstForecastInTable.temp.min)°")
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

private extension DailyForecastViewController{
    
    var forecastsCount: Int{
        return forecastTableView.numberOfRows(inSection: 0)
    }
    
    func getCell(at row: Int) -> ForecastTableViewCell{
        let cell = forecastTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ForecastTableViewCell
        return cell
    }
}
