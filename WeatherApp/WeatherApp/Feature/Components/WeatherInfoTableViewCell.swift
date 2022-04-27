//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import UIKit

class WeatherInfoTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherInfoTableViewCell"
    
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
   static func nib() -> UINib {
        return UINib( nibName:"WeatherInfoTableViewCell", bundle: nil)
    }

    func setCellProperties(dayOfWeekLabel: String, weatherImage:UIImage, temprature: String) {
        self.dayOfWeekLabel.text = dayOfWeekLabel
        self.temperatureLabel.text = temprature
        self.weatherImage.image = weatherImage
    }
    
}
