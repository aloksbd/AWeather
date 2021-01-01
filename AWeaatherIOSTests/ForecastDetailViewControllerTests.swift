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
        let (item, _) = makeItem()
        let forecast = item.list[0]
        sut.forecast = forecast
        sut.loadView()
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.dateLabel.text, forecast.day())
        XCTAssertEqual(sut.temperatureLabel.text, "\(forecast.temp.day)°")
        XCTAssertEqual(sut.sunriseLabel.text, forecast.sunriseTime())
        XCTAssertEqual(sut.sunsetLabel.text, forecast.sunsetTime())
        XCTAssertEqual(sut.dayTemeratureLabel.text, "\(forecast.temp.day)°")
        XCTAssertEqual(sut.morningTemperatureLabel.text, "\(forecast.temp.morn)°")
        XCTAssertEqual(sut.eveningTemperatureLabel.text, "\(forecast.temp.eve)°")
        XCTAssertEqual(sut.nightTemperatureLabel.text, "\(forecast.temp.night)°")
        XCTAssertEqual(sut.minTemperatureLabel.text, "\(forecast.temp.min)°")
        XCTAssertEqual(sut.maxTemperatureLabel.text, "\(forecast.temp.max)°")
        XCTAssertEqual(sut.humidityLabel.text, "\(forecast.humidity)")
        XCTAssertEqual(sut.rainLabel.text, "\(forecast.pop)")
        XCTAssertEqual(sut.windLabel.text, "\(forecast.speed)")
    }
    
    private func makeSut() -> ForecastDetailViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "forecastDetailViewController") as! ForecastDetailViewController
        
        return viewController
    }
}
