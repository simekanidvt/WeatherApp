//
//  SavedWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/28.
//

import UIKit

class SavedWeatherTableViewCell: UITableViewCell {

    static let identifier = "SavedWeatherTableViewCell"
    

    static func nib() -> UINib {
         return UINib( nibName:"SavedWeatherTableViewCell", bundle: nil)
     }
    
}
