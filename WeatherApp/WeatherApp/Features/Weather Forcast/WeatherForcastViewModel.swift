//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherForcastDelegate : AnyObject {
    func reloadTableview()
    func showError()
    func populateCurrentWeather()
    func populateWeatherForcast()
    func sunnyTheme()
    func rainyTheme()
    func cloudyTheme()
}

class WeatherForcastViewModel {
    
    let daysOfTheWeek = ["Monday",  "Tuesday",
                         "Wednesday", "Thursday",
                         "Friday", "Saturday", "Sunday"]
    
    private var  location: CLLocation?
    private var currentWeather: CurrentWeatherModel?
    private var repository: WeatherForcastReposirotyType
    private weak var delegate:WeatherForcastDelegate?
    private var weatherForcast: WeatherForcastModel?
    private var savedWeatherRepository: SavedWeatherRepository?
    
    init(repository: WeatherForcastReposirotyType, delegate: WeatherForcastDelegate) {
        self.repository = repository
        self.delegate = delegate
        self.savedWeatherRepository = SavedWeatherRepository()
    }
    
    func setLocation(location: CLLocation) {
        self.location = location
    }
    
    func toggleTheme(isForest:Bool) {
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
            delegate?.cloudyTheme()
            
        case "Clear":
            delegate?.sunnyTheme()
            
        case "Rain":
            delegate?.rainyTheme()
            
        default:
            delegate?.sunnyTheme()
        }
    }
    
    func retrieveCurrentWeatherFromAPI() {
        guard let location =  self.location else {
            delegate?.showError()
            return
        }
        
        let longitude = String(Int(location.coordinate.longitude))
        let latitude = String(Int(location.coordinate.latitude))
        
        repository.fetchCurrentWeather(longitude: longitude, latitude: latitude, completion: { [weak self] result in
            switch result {
            case .success(let currentWeather) :
                self?.currentWeather = currentWeather
                self?.delegate?.populateCurrentWeather()
            case .failure(let error):
                self?.delegate?.showError()
            }
        })
    }
    
    func retrieveWeatherForcastFromAPI() {
        guard let location =  self.location else {
            delegate?.showError()
            return
        }
        
        let longitude = String(Int(location.coordinate.longitude))
        let latitude = String(Int(location.coordinate.latitude))
        
        repository.fetchWeatherForcast(longitude: longitude, latitude: latitude, completion: { [weak self] result in
            switch result {
            case .success(let weatherForcastData) :
                self?.weatherForcast = weatherForcastData
                self?.delegate?.populateWeatherForcast()
                self?.delegate?.reloadTableview()
            case .failure(let error):
                self?.delegate?.showError()
            }
        })
    }
    
    func saveCurrentWeatherToFavorites() {
        guard let currentWeather = currentWeather,
              let temprature = currentWeather.main?.temp,
              let longitude = currentWeather.coord?.lon,
              let latitude = currentWeather.coord?.lat,
              let name = currentWeather.name
        else { return }
        
        
        savedWeatherRepository?.saveLocationWeather(temperature: convertKalvinToCelsius(temperature: temprature) ,
                                                    name: name,
                                                    longitude: String(longitude),
                                                    latitude: String(latitude),
                                                    completion: {[weak self] result in
            
            switch(result) {
            case .success(let savedWeather):
                self?.delegate?.showError()
            case .failure(let error):
                self?.delegate?.showError()
            }
        })
    }
    
    func fetchCurrentWeatherToFavorites() {
        
        savedWeatherRepository?.fetchSavedWeather(completion: {[weak self] result in
            switch(result) {
            case .success(let savedWeather):
                print(savedWeather)
                
            case .failure(let error):
                self?.delegate?.showError()
            }
        })
    }
    
    func currentWeatherData () -> CurrentWeatherModel? {
        return self.currentWeather
    }
    
    func weatherForcastData (tableviewCellIndex:Int) -> FocastModel {
        
        guard let temperature = weatherForcast?.list?[tableviewCellIndex].main?.temp,
              let index = dayOfTheWeekIndex(tableviewCellIndex: tableviewCellIndex) else {
                  return FocastModel(temp: "", icon: UIImage() , dayOfWeek: "")
              }
        
        let image = weatherIcon(weather: weatherForcast?.list?[tableviewCellIndex].weather?[0].main ?? "clear")
        
        return FocastModel(temp: convertKalvinToCelsius(temperature: temperature),
                           icon: image,
                           dayOfWeek: daysOfTheWeek[index])
    }
    
    func convertKalvinToCelsius(temperature:Double) -> String {
        String(format: "%.0f", temperature - 273.15)+"°"
    }
    
    func weatherIcon(weather: String) -> UIImage {
        switch(weather) {
        case "Clouds":
            return UIImage(named: "partlysunny") ?? UIImage()
            
        case "Clear":
            return UIImage(named: "clear") ?? UIImage()
            
        case "Rain":
            return UIImage(named: "rain") ?? UIImage()
            
        default:
            return UIImage(named: "clear") ?? UIImage()
        }
    }
    
    private func dayOfTheWeekIndex(tableviewCellIndex: Int) -> Int? {
        let day = Date().dayOfWeek()
        var currentDayIndex = daysOfTheWeek.firstIndex(where: {$0 == day})
        guard let startDayIndex = currentDayIndex else {
            return nil
        }
        let dayOfWeekIndex = startDayIndex+tableviewCellIndex+1
        
        let wrappedDayOfWeekIndex  = (dayOfWeekIndex % 7 + 7 ) % 7
        
        return wrappedDayOfWeekIndex
    }
}
