//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import Foundation

// MARK: - CurrentWeatherModel
struct CurrentWeatherModel :Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let dt: Int
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Coord
struct Coord : Codable{
    let lon, lat: Int
}

// MARK: - Main
struct Main : Codable{
    let temp, tempMin, tempMax: Double
}


// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String
}


