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
            reloadTheme()
            
        }
    }
}

extension WeatherForcastViewController: WeatherForcastDelegate {
    
     func reloadTheme() {
        
        let weather = weatherDescriptionLabel.text
        
        switch(weather) {
        case "Clouds":
            self.view.backgroundColor = Theme.currentTheme.cloudyColour
            self.image.image = Theme.currentTheme.cloudyImage
            
        case "Clear":
            self.view.backgroundColor = Theme.currentTheme.sunnyColour
            self.image.image = Theme.currentTheme.sunnyImage
            
        case "Rain":
            self.view.backgroundColor = Theme.currentTheme.rainyColour
            self.image.image = Theme.currentTheme.rainyImage
        case .none:
            self.view.backgroundColor = Theme.currentTheme.cloudyColour
            self.image.image = Theme.currentTheme.cloudyImage
        case .some(_):
            self.view.backgroundColor = Theme.currentTheme.cloudyColour
            self.image.image = Theme.currentTheme.cloudyImage
        }
    }
    func populateWeatherForcast() {
        //
    }
    
    func reloadTableview() {
        // NOthing for now
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
        
        self.largeCurrentTempLabel.text = self.viewModel.convertKalvinToCelcics(temperature: temp)
        self.minTempLabel.text = self.viewModel.convertKalvinToCelcics(temperature: minTemp)
        self.maxTempLabel.text = self.viewModel.convertKalvinToCelcics(temperature: maxTemp)
        self.weatherDescriptionLabel.text = description
        self.reloadTheme()
        
    }
}
