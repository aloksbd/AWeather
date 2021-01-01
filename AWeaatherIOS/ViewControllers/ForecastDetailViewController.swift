//
//  ForecastDetailViewController.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 22/12/2020.
//

import UIKit

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
    
    var forecast: Forecast!
    
    override func viewDidLoad() {
        dateLabel.text = forecast.day
        temperatureLabel.text = "\(forecast.dayTemperature)°"
        weatherImageView.image = UIImage(named: forecast.weather)
        sunriseLabel.text = forecast.sunriseTime
        sunsetLabel.text = forecast.sunsetTime
        dayTemeratureLabel.text = "\(forecast.dayTemperature)°"
        morningTemperatureLabel.text = "\(forecast.morningTemperature)°"
        eveningTemperatureLabel.text = "\(forecast.eveningTemperature)°"
        nightTemperatureLabel.text = "\(forecast.nightTemperature)°"
        minTemperatureLabel.text = "\(forecast.minTemperature)°"
        maxTemperatureLabel.text = "\(forecast.maxTemperature)°"
        humidityLabel.text = "\(forecast.humidity)"
        rainLabel.text = "\(forecast.rainChance)"
        windLabel.text = "\(forecast.windSpeed)"
    }
}
