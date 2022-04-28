//
//  ViewController.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/21.
//

import UIKit
import CoreLocation

class WeatherForcastViewController: UIViewController {
    
    @IBOutlet private weak var largeCurrentTempLabel: UILabel!
    @IBOutlet private weak var smallCurrentTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var futureForcastTableView: UITableView!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var toggleThemButton: UIButton!
    let manager  = CLLocationManager()
    
    lazy var viewModel = WeatherForcastViewModel(repository: WeatherForcastRepository(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetUp()
        locationManagerSetUp()
        viewModel.retrieveCurrentWeatherFromAPI()
        viewModel.retrieveWeatherForcastFromAPI()
        viewModel.applyTheme(weatherDescription: description)
    }
    
    private func tableViewSetUp() {
        futureForcastTableView.dataSource = self
        futureForcastTableView.register( WeatherInfoTableViewCell.nib(),
                                         forCellReuseIdentifier: WeatherInfoTableViewCell.identifier)
    }
    
    private func locationManagerSetUp() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    @IBAction private func saveLocationWeather(_ sender: Any) {
        viewModel.saveCurrentWeatherToFavorites()
    }
    @IBAction private func tapped(_ sender: UISwitch) {
        viewModel.toggleTheme(isForest: sender.isOn)
    }
}

extension WeatherForcastViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.identifier)  as? WeatherInfoTableViewCell else {
            return UITableViewCell()
        }
        
        let forcastData = viewModel.weatherForcastData(tableviewCellIndex: indexPath.item)
        cell.setCellProperties(dayOfWeekLabel: forcastData.dayOfWeek, weatherImage: forcastData.icon, temprature: forcastData.temperature)
        return cell
    }
}

extension WeatherForcastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.startUpdatingLocation()
            viewModel.setLocation(location: location)
            viewModel.retrieveCurrentWeatherFromAPI()
            viewModel.retrieveWeatherForcastFromAPI()
            viewModel.applyTheme(weatherDescription: weatherDescriptionLabel.text ?? "Clear" )
        }
    }
}

extension WeatherForcastViewController: WeatherForcastDelegate {
    func cloudyTheme() {
        self.view.backgroundColor = Theme.currentTheme.cloudyColour
        self.image.image = Theme.currentTheme.cloudyImage
    }
    
    func sunnyTheme() {
        self.view.backgroundColor = Theme.currentTheme.sunnyColour
        self.image.image = Theme.currentTheme.sunnyImage
    }
    
    func rainyTheme() {
        self.view.backgroundColor = Theme.currentTheme.rainyColour
        self.image.image = Theme.currentTheme.rainyImage
    }
    
    func reloadTableview() {
        self.futureForcastTableView.reloadData()
    }
    
    func showError() {
        // Nothing for now
    }
    
    func populateCurrentWeather() {
        let currentWeather = viewModel.currentWeatherData()
        
        guard let temp = currentWeather?.main?.temp,
              let minTemp =  currentWeather?.main?.tempMin ,
              let maxTemp =  currentWeather?.main?.tempMax,
              let description = currentWeather?.weather?[0].main
        else {
            return
        }
        
        self.largeCurrentTempLabel.text = self.viewModel.convertKalvinToCelsius(temperature: temp)
        self.minTempLabel.text = self.viewModel.convertKalvinToCelsius(temperature: minTemp)
        self.maxTempLabel.text = self.viewModel.convertKalvinToCelsius(temperature: maxTemp)
        self.weatherDescriptionLabel.text = description
        viewModel.applyTheme(weatherDescription: description)
    }
}
