//
//  SavedWeatherRepository.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/28.
//

import Foundation
import UIKit

typealias SavedWeatherResult = (Result<[LocationItem] , URLSession.CustomError>) -> Void

protocol SavedWeatherRepositoryType {
    func fetchSavedWeather( completion: @escaping SavedWeatherResult)
    func saveLocationWeather(temperature:String, name: String, longitude:String, latitude:String, completion: @escaping SavedWeatherResult)
}

class SavedWeatherRepository: SavedWeatherRepositoryType {
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
   
    func saveLocationWeather(temperature:String, name: String, longitude:String, latitude:String , completion: @escaping SavedWeatherResult) {
        guard let context = self.context else { return }
                
            let location = LocationItem(context: context)
            location.temprature = temperature
            location.latitude = latitude
            location.longitude = longitude
            location.locationName = name
            
        do {
            try context.save()
            DispatchQueue.main.async {
                completion(Result.success([location]))
            }
        } catch _ as NSError {
            DispatchQueue.main.async {
                completion(Result.failure(.invalidResponse))
            }
        }
    }
        
    func fetchSavedWeather(completion: @escaping SavedWeatherResult) {
        do {
            let locations = try self.context?.fetch(LocationItem.fetchRequest())
            
            guard let locationsData = locations else { return }
            DispatchQueue.main.async {
                completion(Result.success(locationsData))
            }
        } catch _ as NSError {
            DispatchQueue.main.async {
                completion(Result.failure(.invalidResponse))
            }
        }
    }
}
