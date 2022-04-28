//
//  SavedWeatherViewModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/28.
//

import Foundation

protocol SavedWeatherDeleage :AnyObject {
    func reloadTableView()
    func showError()
}

class SavedWeatherViewModel {
    private weak var delegate:SavedWeatherDeleage?
    private var repository: SavedWeatherRepository?
    private var savedLocations: [LocationItem]?
    init(repository: SavedWeatherRepository, delegate: SavedWeatherDeleage) {
        self.delegate  = delegate
        self.repository = repository
    }

    func fetchSavedLocations() {
        repository?.fetchSavedWeather(completion: {[weak self] result in
            switch(result) {
            case .success(let savedWeather):
                self?.savedLocations = savedWeather
                self?.delegate?.reloadTableView()
            case .failure(let error):
                self?.delegate?.showError()
            }
        })
    }
    
    var savedLocationsCount:Int {
        return savedLocations?.count ?? 0
    }
    
    func savedLocation(atIndex: Int) -> LocationItem? {
        return self.savedLocations?[atIndex] ?? nil
    }
}
