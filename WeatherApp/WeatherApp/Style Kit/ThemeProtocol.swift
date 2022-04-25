//
//  Theme.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/24.
//

import Foundation
import UIKit

class Theme {
    static var currentTheme:ThemeProtocol = ForestTheme()
}

protocol ThemeProtocol {
    var sunnyImage : UIImage { get }
    var sunnyColour: UIColor { get }
    var rainyImage : UIImage { get }
    var rainyColour: UIColor { get }
    var cloudyImage : UIImage { get }
    var cloudyColour: UIColor { get }
}

class ForestTheme : ThemeProtocol {
    var rainyImage: UIImage
    var rainyColour: UIColor
    
    var cloudyImage: UIImage
    var cloudyColour: UIColor
    
    var sunnyImage: UIImage
    var sunnyColour: UIColor
    
    init () {
        sunnyImage = UIImage(named: "forest_sunny") ?? UIImage()
        sunnyColour = UIColor(named: "forest") ?? UIColor()
        
        cloudyImage = UIImage(named: "forest_cloudy") ?? UIImage()
        cloudyColour = UIColor(named: "cloudy") ?? UIColor()
        
        rainyImage = UIImage(named: "forest_rainy") ?? UIImage()
        rainyColour = UIColor(named: "rainy") ?? UIColor()
    
    }
}

class SeaTheme: ThemeProtocol {
    var rainyImage: UIImage
    
    var rainyColour: UIColor
    
    var cloudyImage: UIImage
    
    var cloudyColour: UIColor
    
    var sunnyImage: UIImage
    var sunnyColour: UIColor
    init() {
        sunnyImage = UIImage(named: "sea_sunny") ?? UIImage()
        sunnyColour = UIColor(named: "sea") ?? UIColor()
        
        cloudyImage = UIImage(named: "sea_cloudy") ?? UIImage()
        cloudyColour = UIColor(named: "cloudy") ?? UIColor()
        
        rainyImage = UIImage(named: "sea_rainy") ?? UIImage()
        rainyColour = UIColor(named: "rainy") ?? UIColor()
    }
}
