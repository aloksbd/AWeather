//
//  ForecastTableViewCell.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 21/12/2020.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    
    func setup(day: String, weather: String, maxTemp: String, minTemp: String){
        dayLabel.text = day
        weatherLabel.text = weather
        maxTemperatureLabel.text = "max:" + maxTemp + "°"
        minTemperatureLabel.text = "min:" + minTemp + "°"
        weatherImageView.image = UIImage(named: weather)
    }
}
