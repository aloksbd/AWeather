//
//  ForecastDetailViewController.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 22/12/2020.
//

import UIKit
import AWeather

class ForecastDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var dayTemeratureLabel: UILabel!
    @IBOutlet weak var nightTemperatureLabel: UILabel!
    @IBOutlet weak var morningTemperatureLabel: UILabel!
    @IBOutlet weak var eveningTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    var forecast: ADailyForecast!
    
    override func viewDidLoad() {
        dateLabel.text = forecast.day()
        temperatureLabel.text = "\(forecast.temp.day)°"
        weatherImageView.image = UIImage(named: forecast.weather[0].main)
        sunriseLabel.text = forecast.sunriseTime()
        sunsetLabel.text = forecast.sunsetTime()
        dayTemeratureLabel.text = "\(forecast.temp.day)°"
        morningTemperatureLabel.text = "\(forecast.temp.morn)°"
        eveningTemperatureLabel.text = "\(forecast.temp.eve)°"
        nightTemperatureLabel.text = "\(forecast.temp.night)°"
        minTemperatureLabel.text = "\(forecast.temp.min)°"
        maxTemperatureLabel.text = "\(forecast.temp.max)°"
        humidityLabel.text = "\(forecast.humidity)"
        rainLabel.text = "\(forecast.pop)"
        windLabel.text = "\(forecast.speed)"
    }
}
