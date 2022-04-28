//
//  SavedWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/28.
//

import UIKit

class SavedWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    static let identifier = "SavedWeatherTableViewCell"
    

    static func nib() -> UINib {
         return UINib( nibName:"SavedWeatherTableViewCell", bundle: nil)
     }
    
    func setProperties(locationName: String, temperature: String){
        self.locationName.text = locationName
        self.temperature.text = temperature
    }
}
