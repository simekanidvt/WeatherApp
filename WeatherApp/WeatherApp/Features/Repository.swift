//
//  Repository.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import Foundation



typealias CurrentWeatherResult = (Result<CurrentWeatherModel , URLSession.CustomError>) -> Void
typealias WeatherForcastResult = (Result<WeatherForcastModel , URLSession.CustomError>) -> Void

protocol WeatherForcastReposirotyType{
    func fetchCurrentWeather(longitude: String, latitude: String, completion: @escaping CurrentWeatherResult)
    func fetchWeatherForcast(longitude: String, latitude: String,completion: @escaping WeatherForcastResult)
}

class WeatherForcastRepository: WeatherForcastReposirotyType {
    func fetchCurrentWeather(longitude: String, latitude: String, completion: @escaping CurrentWeatherResult){
        let url = Constants.baseURL?
            .appendingPathComponent("/data/2.5/weather?")
            .appendingPathComponent("lat="+latitude)
            .appendingPathComponent("&lon="+longitude)
            .appendingPathComponent("&appid="+Constants.apiKey)
        
        URLSession.shared.makeRequest(url: url,
                                      method: .get,
                                      returnModel: CurrentWeatherModel.self,
                                      completion: completion)

    }
    
    func fetchWeatherForcast(longitude: String, latitude: String,completion: @escaping WeatherForcastResult){
        
    }
}
