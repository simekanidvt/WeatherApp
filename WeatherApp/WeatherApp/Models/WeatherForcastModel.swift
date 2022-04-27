//
//  WeatherForcastModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import Foundation
struct WeatherForcastModel: Codable {
    var cod: String?
    var message, cnt: Int?
    var list: [List]?

}

// MARK: - Coord
struct ForcastCoord: Codable {
    var lat, lon: Int?
}

// MARK: - List
struct List : Codable {
    var dt: Int?
    var main: ForcastMain?
    var weather: [ForcastWeather]?
}


// MARK: - Main
struct ForcastMain: Codable {
    var temp_max : Double?
}

// MARK: - Weather
struct ForcastWeather: Codable {
    var id: Int?
    var main, icon: String?
}
