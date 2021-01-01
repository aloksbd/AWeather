//
//  DailyForecastViewController.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 21/12/2020.
//

import UIKit

class DailyForecastViewController: UIViewController {
    let cellId = "forecastCell"
    var forecastLoader: ForecastLoader!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var todaysMinTemperatureLabel: UILabel!
    @IBOutlet weak var todaysMaxTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var todaysWeatherImageView: UIImageView!
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    var forecasts = [Forecast]()
    var city = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastLoader.load{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case let .success(root):
                if let root = root{
                    self.addForecast( root)
                }
            case .failure(_):
                break
            }
        }
    }
    
    fileprivate func addForecast( _ forecast: ForecastRoot) {
        self.forecasts = forecast.list
        runOnMainThread { [weak self] in
            guard let self = self else {return}
            self.setupTodaysForecast(forecast: forecast.list[0], city: forecast.city.name)
            self.forecastTableView.reloadData()
        }
    }
    
    func setupTodaysForecast(forecast: Forecast, city: String){
        cityLabel.text = city
        todaysDateLabel.text = "\(forecast.date)"
        todaysMinTemperatureLabel.text = "min: \(forecast.minTemperature)°"
        todaysMaxTemperatureLabel.text = "max: \(forecast.maxTemperature)°"
        currentTemperatureLabel.text = "\(forecast.dayTemperature)°"
        todaysWeatherImageView.image = UIImage(named: forecast.weather)
    }
    
    @IBAction func todaysForecastViewTapped(_ sender: Any) {
        let selectedForecast = forecasts[0]
        performSegue(withIdentifier: "showDetail", sender: selectedForecast)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ForecastDetailViewController{
            detailVC.forecast = sender as? Forecast
        }
    }
}

extension DailyForecastViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedForecast = forecasts[indexPath.row + 1]
        performSegue(withIdentifier: "showDetail", sender: selectedForecast)
    }
}

extension DailyForecastViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ForecastTableViewCell
        let forecast = forecasts[indexPath.row + 1]
        cell.setup(day: "\(forecast.day)", weather: forecast.weather, maxTemp: "\(forecast.maxTemperature)", minTemp: "\(forecast.minTemperature)")
        return cell
    }
}

