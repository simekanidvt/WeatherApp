//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Simekani Mabambi on 2022/04/21.
//

import XCTest
@testable import WeatherApp
import CoreLocation
class WeatherForcastTests: XCTestCase {
    
    private var viewModel: WeatherForcastViewModel!
    private var mockForcastRepository: MockForcastRepository!
    private var mockSavedWeatherRepository: MockSavedWeatherRepository!
    private var mockdelegate: MockWetherForcastDelegate!
    
    override func setUp() {
        mockForcastRepository = MockForcastRepository()
        mockSavedWeatherRepository = MockSavedWeatherRepository()
        mockdelegate = MockWetherForcastDelegate()
        viewModel = WeatherForcastViewModel(repository: self.mockForcastRepository,
                                            delegate: mockdelegate,
                                            savedWeatherRepository: mockSavedWeatherRepository )
    }
    
    func retrieveCurrentWeatherFromAPILocationNotSet() {
        viewModel.retrieveCurrentWeatherFromAPI()
        XCTAssertTrue(mockdelegate.showErrorIsCalled)
    }
    
    func testRetrieveCurrentWeatherFromAPILocationSet() {
        viewModel.setLocation(location: CLLocation())
        viewModel.retrieveCurrentWeatherFromAPI()
        XCTAssertFalse(mockdelegate.showErrorIsCalled)
        XCTAssertTrue(mockdelegate.populateCurrentWeatherIsCalled)
    }
    
    func testRetrieveCurrentWeatherFromAPIFailedToRetrieveData() {
        viewModel.setLocation(location: CLLocation())
        mockForcastRepository.unsuccessfulCall()
        viewModel.retrieveCurrentWeatherFromAPI()
        XCTAssertTrue(mockdelegate.showErrorIsCalled)
        XCTAssertFalse(mockdelegate.populateCurrentWeatherIsCalled)
    }
    
    func testToggleCurrentThemeForestTheme() {
        viewModel.toggleTheme(isForest: true)
        XCTAssertTrue(Theme.currentTheme is ForestTheme)
    }
    
    func testToggleCurrentThemeSeaTheme() {
        viewModel.toggleTheme(isForest: false)
        XCTAssertTrue(Theme.currentTheme is SeaTheme)
    }
    
    func testApplyWeatherCondtionThemeClouds() {
        viewModel.applyTheme(weatherDescription: "Clouds")
        XCTAssertTrue(mockdelegate.cloudyThemeIsCalled)
        XCTAssertFalse(mockdelegate.sunnyThemeIsCalled)
        XCTAssertFalse(mockdelegate.rainyThemeIsCalled)
    }
    func testApplyWeatherCondtionThemeSunny() {
        viewModel.applyTheme(weatherDescription: "Clear")
        XCTAssertTrue(mockdelegate.sunnyThemeIsCalled)
        XCTAssertFalse(mockdelegate.cloudyThemeIsCalled)
        XCTAssertFalse(mockdelegate.rainyThemeIsCalled)
    }
    func testApplyWeatherCondtionThemeRainy() {
        viewModel.applyTheme(weatherDescription: "Rain")
        XCTAssertTrue(mockdelegate.rainyThemeIsCalled)
        XCTAssertFalse(mockdelegate.cloudyThemeIsCalled)
        XCTAssertFalse(mockdelegate.sunnyThemeIsCalled)
    }
    
    func testRetriveWeatherForcastSuccess() {
        viewModel.setLocation(location: CLLocation())
        viewModel.retrieveWeatherForcastFromAPI()
        XCTAssertTrue(mockdelegate.reloadTableViewIsCalled)
    }
    func testRetriveWeatherForcastFailure() {
        viewModel.setLocation(location: CLLocation())
        mockForcastRepository.unsuccessfulCall()
        viewModel.retrieveWeatherForcastFromAPI()
        XCTAssertTrue(mockdelegate.showErrorIsCalled)
    }
    
    func testSaveCurrentWeatherToFavoritesFailed() {
        viewModel.retrieveCurrentWeatherFromAPI()
        viewModel.saveCurrentWeatherToFavorites()
        XCTAssertFalse(mockdelegate.disableSaveButtonIsCalled)
    }
    
    func testSaveCurrentWeatherToFavorites() {
        viewModel.setLocation(location: CLLocation())
        viewModel.retrieveCurrentWeatherFromAPI()
        viewModel.saveCurrentWeatherToFavorites()
        XCTAssertTrue(mockdelegate.disableSaveButtonIsCalled)
    }
    
    func testSaveCurrentWeatherToFavoritesUnsuccessfulFail() {
        viewModel.setLocation(location: CLLocation())
        viewModel.retrieveCurrentWeatherFromAPI()
        mockSavedWeatherRepository.unsuccessfull()
        viewModel.saveCurrentWeatherToFavorites()
        XCTAssertTrue(mockdelegate.showErrorIsCalled)
    }
    
    func testCurrentData() {
        XCTAssertNil(viewModel.currentWeatherData())
    }
    
    func testWeatherDataFail(){
        viewModel.setLocation(location: CLLocation())
        //viewModel.retrieveWeatherForcastFromAPI()
        let forcast = viewModel.weatherForcastData(tableviewCellIndex: 0)
        
        XCTAssertEqual("", forcast.dayOfWeek)
    }
    
    func testWeatherDataPass() {
        viewModel.setLocation(location: CLLocation())
        viewModel.retrieveWeatherForcastFromAPI()
        let forcast = viewModel.weatherForcastData(tableviewCellIndex: 0)
        XCTAssertEqual("-149°", forcast.temperature)
    }
    
    func testWeatherCodeIconPartlyClouds() {
        let image = viewModel.weatherIcon(weather: "Clouds")
        XCTAssertEqual( image , UIImage(named: "partlysunny") )
    }
    
    func testWeatherCodeIconPartlyClear() {
        let image = viewModel.weatherIcon(weather: "Clear")
        XCTAssertEqual( image , UIImage(named: "clear") )
    }
    
    func testWeatherCodeIconPartlyRain() {
        let image = viewModel.weatherIcon(weather: "Rain")
        XCTAssertEqual( image , UIImage(named: "rain") )
    }
    
   
    class MockForcastRepository: WeatherForcastReposirotyType {
        var success = true
        func fetchCurrentWeather(longitude: String, latitude: String, completion: @escaping CurrentWeatherResult) {
            if(success) {
                completion(.success(CurrentWeatherModel(coord: Coord(lon: 145, lat: 345),
                                                        weather: [Weather( main: "Cloudy")],
                                                        main: Main(temp: 234.0, tempMin: 459.0, tempMax: 234.0),
                                                        visibility: 1,name: "JHB")))
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
        
        func unsuccessfulCall() {
            success = false
        }
    }
    
    class MockWetherForcastDelegate : WeatherForcastDelegate {
        
        
        var rainyThemeIsCalled = false
        var cloudyThemeIsCalled = false
        var sunnyThemeIsCalled = false
        var populateCurrentWeatherIsCalled = false
        var reloadTableViewIsCalled = false
        var showErrorIsCalled = false
        var disableSaveButtonIsCalled = false
        
        func reloadTableview() {
            reloadTableViewIsCalled = true
        }
        
        func disableSaveButton() {
            disableSaveButtonIsCalled = true
        }
        
        func showError() {
            showErrorIsCalled = true
        }
        
        func populateCurrentWeather() {
            populateCurrentWeatherIsCalled = true
        }
        
        func populateWeatherForcast() {
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
    
    class MockSavedWeatherRepository: SavedWeatherRepositoryType {
        var success = true
        func fetchSavedWeather(completion: @escaping SavedWeatherResult) {
            if(success) {
                completion(.success([LocationItem(),]))
            }
            else {
                completion(.failure(.invalidData))
            }
        }
        
        func saveLocationWeather(temperature: String, name: String, longitude: String, latitude: String, completion: @escaping SavedWeatherResult) {
            if(success){
                completion(.success([LocationItem(),]))
            }
            else {
                completion(.failure(.invalidData))
            }
        }
        
        func unsuccessfull() {
            success = false
        }
    }
}
