//
//  ViewController.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/21.
//

import UIKit
import CoreLocation

class WeatherForcastViewController: UIViewController {
    
    @IBOutlet weak var largeCurrentTempLabel: UILabel!
    @IBOutlet weak var smallCurrentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var futureForcastTableView: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!

    @IBOutlet weak var toggleThemButton: UIButton!
    let manager  = CLLocationManager()
    
    lazy var viewModel = WeatherForcastViewModel(repository: WeatherForcastRepository(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        futureForcastTableView.dataSource = self
        futureForcastTableView.register( WeatherInfoTableViewCell.nib(),
                                         forCellReuseIdentifier: WeatherInfoTableViewCell.identifier)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.view.backgroundColor = Theme.currentTheme.sunnyColour
        self.image.image = Theme.currentTheme.sunnyImage

    }
  
    @IBAction func tapped(_ sender: UISwitch) {
        
        if (sender.isOn){
            Theme.currentTheme = ForestTheme()
            self.view.backgroundColor = Theme.currentTheme.sunnyColour
            self.image.image = Theme.currentTheme.sunnyImage
        }
        
        else {
            Theme.currentTheme = SeaTheme()
            self.view.backgroundColor = Theme.currentTheme.sunnyColour
            self.image.image = Theme.currentTheme.sunnyImage
        }
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
            image.image = Theme.currentTheme.sunnyImage
            
        }
    }
}

extension WeatherForcastViewController: WeatherForcastDelegate {
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
        
        DispatchQueue.main.async {
            self.largeCurrentTempLabel.text = self.viewModel.convertKalvinToCelcics(temperature: temp)
            self.minTempLabel.text = self.viewModel.convertKalvinToCelcics(temperature: minTemp)
            self.maxTempLabel.text = self.viewModel.convertKalvinToCelcics(temperature: maxTemp)
            self.weatherDescriptionLabel.text = description
        }
    }
}
