//
//  SavedWeatherViewController.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/28.
//

import Foundation
import UIKit

class SavedWeatherViewController: UIViewController{
    
    @IBOutlet weak var savedWeatherTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        savedWeatherTableview.dataSource = self
        savedWeatherTableview.register(SavedWeatherTableViewCell.nib(), forCellReuseIdentifier: SavedWeatherTableViewCell.identifier)
        
    }
}

extension SavedWeatherViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedWeatherTableViewCell.identifier, for: indexPath)  as? SavedWeatherTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}
