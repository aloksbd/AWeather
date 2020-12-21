//
//  DailyForecastViewController.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 21/12/2020.
//

import UIKit
import AWeather

class DailyForecastViewController: UIViewController {
    let cellId = "forecastCell"
    var loader: AForecastLoader!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var todaysMinTemperatureLabel: UILabel!
    @IBOutlet weak var todaysMaxTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var todaysWeatherImageView: UIImageView!
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    var forecasts = [ADailyForecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let client = AWeatherHTTPClient()
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=Kathmandu&units=metric&cnt=10&appid=4375694cabc41be5f7ebee4ecbd3fc03")!
        let remoteLoader = ARemoteForecastLoader(httpClient: client, url:url)
        let store = AWeatherCacheStore()
        let localLoader = ALocalForecastLoader(store: store)
        loader = ARemoteWithLocalForecastLoader(remoteLoader: remoteLoader, localLoader: localLoader) 
        
        loader.load{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case let .success(forecast):
                if let forecast = forecast{
                    self.forecasts = forecast.list
                    DispatchQueue.main.async{ [weak self] in
                        guard let self = self else {return}
                        self.setupTodaysForecast(forecast: forecast.list[0], city: forecast.city.name)
                        self.forecastTableView.reloadData()
                    }
                }
            case let .failure(error):
                print(error)
            }
            
        }
        
    }
    
    func setupTodaysForecast(forecast: ADailyForecast, city: String){
        cityLabel.text = city
        todaysDateLabel.text = "\(forecast.date())"
        todaysMinTemperatureLabel.text = "min: \(forecast.temp.min)°"
        todaysMaxTemperatureLabel.text = "max: \(forecast.temp.max)°"
        currentTemperatureLabel.text = "\(forecast.temp.day)°"
        todaysWeatherImageView.image = UIImage(named: forecast.weather[0].main)
    }
    
    @IBAction func todaysForecastViewTapped(_ sender: Any) {
        let selectedForecast = forecasts[0]
        performSegue(withIdentifier: "showDetail", sender: selectedForecast)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ForecastDetailViewController{
            detailVC.forecast = sender as! ADailyForecast
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
        cell.setup(day: "\(forecast.day())", weather: forecast.weather[0].main, maxTemp: "\(forecast.temp.max)", minTemp: "\(forecast.temp.min)")
        return cell
    }
}

