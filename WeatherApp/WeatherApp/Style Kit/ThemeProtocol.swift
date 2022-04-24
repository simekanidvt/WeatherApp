//
//  Theme.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/24.
//

import Foundation
import UIKit

class Theme {
    static var currentTheme:ThemeProtocol = SeaTheme()
}

protocol ThemeProtocol {
    var sunnyImage : UIImage { get }
    var sunnyColour: UIColor { get }
}

class ForestTheme : ThemeProtocol {
    var sunnyImage: UIImage
    var sunnyColour: UIColor
    
    init () {
        sunnyImage = UIImage(named: "forest_sunny") ?? UIImage()
        sunnyColour = UIColor(named: "forest") ?? UIColor()
    }
}

class SeaTheme: ThemeProtocol {
    var sunnyImage: UIImage
    var sunnyColour: UIColor
    init() {
        sunnyImage = UIImage(named: "sea_sunny") ?? UIImage()
        sunnyColour = UIColor(named: "sea") ?? UIColor()
    }
}
