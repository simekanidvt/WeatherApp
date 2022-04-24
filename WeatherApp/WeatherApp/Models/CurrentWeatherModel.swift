//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import Foundation

// MARK: - CurrentWeatherModel
struct CurrentWeatherModel : Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var dt: Int?
    var timezone, id: Int?
    var name: String?
    var cod: Int?
}

// MARK: - Coord
struct Coord : Codable {
    var lon, lat: Int?
}

// MARK: - Main
struct Main : Codable {
    var temp, tempMin, tempMax: Double?
}

// MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main, weatherDescription, icon: String?
}
