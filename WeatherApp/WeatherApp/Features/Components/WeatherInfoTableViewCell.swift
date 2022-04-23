//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/23.
//

import UIKit

class WeatherInfoTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherInfoTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   static func nib() ->UINib{
        return UINib( nibName:"WeatherInfoTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
