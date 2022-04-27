//
//  ForcastModel.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/27.
//

import Foundation
import UIKit

struct FocastModel{
    let temperature: String
    let icon: UIImage
    let dayOfWeek: String
    
    init(temp:String, icon:UIImage, dayOfWeek:String){
        self.temperature = temp
        self.icon = icon
        self.dayOfWeek = dayOfWeek
    }
}
