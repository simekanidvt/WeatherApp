//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import Foundation
import CoreLocation

class WeatherForcastViewModel {
    var  location: CLLocation?
    
    func setLocation(location: CLLocation) {
        self.location = location
    }
}
