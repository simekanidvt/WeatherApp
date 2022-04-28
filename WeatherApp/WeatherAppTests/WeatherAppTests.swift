//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Simekani Mabambi on 2022/04/21.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    private var viewModel: WeatherForcastViewModel!
    private var mockForcastRepository: WeatherForcastReposirotyType!
    private var mockSavedWeatherRepository: SavedWeatherRepository!
    private var mockdelegate:MockWetherForcastDelegate!
    
    override func setUp() {
        mockForcastRepository = MockForcastRepository()
        mockSavedWeatherRepository = SavedWeatherRepository()
        mockdelegate = MockWetherForcastDelegate()
        viewModel = WeatherForcastViewModel(repository: self.mockForcastRepository, delegate: mockdelegate)
    }
    
    class MockForcastRepository: WeatherForcastReposirotyType {
        var success = false
        func fetchCurrentWeather(longitude: String, latitude: String, completion: @escaping CurrentWeatherResult) {
            if(success) {
                completion(.success(CurrentWeatherModel(coord: Coord(lon: 145, lat: 345),
                                                        weather: [Weather( main: "Cloudy")],
                                                        main: Main(temp: 234.0, tempMin: 459.0, tempMax: 234.0),
                                                        visibility: <#T##Int?#>,name: "JHB")))
            } else {
                completion(.failure(.invalidData))
            }
        }
        
        func fetchWeatherForcast(longitude: String, latitude: String, completion: @escaping WeatherForcastResult) {
            if(success) {
                completion(.success(WeatherForcastModel( cnt: 5, list: [List( main: ForcastMain(temp: 124))])))
            } else {
                completion(.failure(.invalidData))
            }
        }
        
        func successfulCall() {
            success = true
        }
    }
    
    class MockWetherForcastDelegate : WeatherForcastDelegate {
        var rainyThemeIsCalled = false
        var cloudyThemeIsCalled = false
        var sunnyThemeIsCalled = false
        var populateCurrentWeatherIsCalled = false
        var reloadTableViewIsCalled = false
        var showErrorIsCalled = false
        
        func reloadTableview() {
            reloadTableViewIsCalled = true
        }
        
        func showError() {
            showErrorIsCalled = true
        }
        
        func populateCurrentWeather() {
            populateCurrentWeatherIsCalled = true
        }
        
        func populateWeatherForcast() {
            //
        }
        
        func sunnyTheme() {
            sunnyThemeIsCalled = true
        }
        
        func rainyTheme() {
            rainyThemeIsCalled = true
        }
        
        func cloudyTheme() {
            cloudyThemeIsCalled = true
        }
    }
}
