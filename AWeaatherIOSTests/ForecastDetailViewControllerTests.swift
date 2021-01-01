//
//  ForecastDetailViewControllerTests.swift
//  AWeaatherIOSTests
//
//  Created by Alok Subedi on 21/12/2020.
//

import XCTest
@testable import AWeaatherIOS

class ForecastDetailViewControllerTests: XCTestCase {
    func test_viewDidLoad_rendersAllLabelsWithCorrectFormattedText(){
        let sut = makeSut()
        let (_, forecasts) = makeItem()
        let forecast = forecasts[0]
        sut.forecast = forecast
        sut.loadView()
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.dateLabel.text, forecast.day)
        XCTAssertEqual(sut.temperatureLabel.text, "\(forecast.dayTemperature)°")
        XCTAssertEqual(sut.sunriseLabel.text, forecast.sunriseTime)
        XCTAssertEqual(sut.sunsetLabel.text, forecast.sunsetTime)
        XCTAssertEqual(sut.dayTemeratureLabel.text, "\(forecast.dayTemperature)°")
        XCTAssertEqual(sut.morningTemperatureLabel.text, "\(forecast.morningTemperature)°")
        XCTAssertEqual(sut.eveningTemperatureLabel.text, "\(forecast.eveningTemperature)°")
        XCTAssertEqual(sut.nightTemperatureLabel.text, "\(forecast.nightTemperature)°")
        XCTAssertEqual(sut.minTemperatureLabel.text, "\(forecast.minTemperature)°")
        XCTAssertEqual(sut.maxTemperatureLabel.text, "\(forecast.maxTemperature)°")
        XCTAssertEqual(sut.humidityLabel.text, "\(forecast.humidity)")
        XCTAssertEqual(sut.rainLabel.text, "\(forecast.rainChance)")
        XCTAssertEqual(sut.windLabel.text, "\(forecast.windSpeed)")
    }
    
    private func makeSut() -> ForecastDetailViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "forecastDetailViewController") as! ForecastDetailViewController
        
        return viewController
    }
}
