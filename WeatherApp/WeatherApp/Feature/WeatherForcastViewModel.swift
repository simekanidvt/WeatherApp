//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import Foundation
import CoreLocation

protocol WeatherForcastDelegate {
    func reloadTableview()
    func showError()
    func populateCurrentWeather()
    func populateWeatherForcast()
    func sunnyTheme()
    func rainyTheme()
    func cloudyTheme()
}

class WeatherForcastViewModel {
    
    private var  location: CLLocation?
    private var currentWeather: CurrentWeatherModel?
    private let repository: WeatherForcastRepository
    private let delegate:WeatherForcastDelegate
    private var weatherForcast: WeatherForcastModel?
    
    init(repository: WeatherForcastRepository, delegate: WeatherForcastDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
    func setLocation(location: CLLocation) {
        self.location = location
    }
    
    func toggleTheme(isForest:Bool){
        if (isForest) {
            Theme.currentTheme = ForestTheme()
        } else {
            Theme.currentTheme = SeaTheme()
        }
        applyTheme(weatherDescription: currentWeather?.weather?[0].main ?? "Clear")
    }
    
    func applyTheme(weatherDescription:String) {
        switch(weatherDescription) {
        case "Clouds":
            delegate.cloudyTheme()

        case "Clear":
            delegate.sunnyTheme()
            
        case "Rain":
            delegate.rainyTheme()
            
        default:
            delegate.sunnyTheme()
        }
    }
    
    func retrieveCurrentWeatherFromAPI() {
        guard let location =  self.location else {
            delegate.showError()
            return
        }
        
        let longitude = String(Int(location.coordinate.longitude))
        let latitude = String(Int(location.coordinate.latitude))
        
        repository.fetchCurrentWeather(longitude: longitude, latitude: latitude, completion: { [weak self] result in
            switch result {
            case .success(let currentWeather) :
                self?.currentWeather = currentWeather
                self?.delegate.populateCurrentWeather()
            case .failure(let error):
                self?.delegate.showError()
            }
        })
    }
    
    func retrieveWeatherForcastFromAPI() {
        guard let location =  self.location else {
            delegate.showError()
            return
        }
        
        let longitude = String(Int(location.coordinate.longitude))
        let latitude = String(Int(location.coordinate.latitude))
        
        repository.fetchWeatherForcast(longitude: longitude, latitude: latitude, completion: { [weak self] result in
            switch result {
            case .success(let weatherForcastData) :
                self?.weatherForcast = weatherForcastData
                self?.delegate.populateWeatherForcast()
            case .failure(let error):
                self?.delegate.showError()
            }
        })
    }
    
    func currentWeatherData () -> CurrentWeatherModel? {
        return self.currentWeather
    }
    
    func convertKalvinToCelcics(temperature:Double) -> String {
        String(format: "%.0f", temperature - 273.15)+"°"
    }
}


