//
//  SavedWeatherViewController.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/28.
//

import Foundation
import UIKit

class SavedWeatherViewController: UIViewController {
    
    @IBOutlet private weak var savedWeatherTableview: UITableView!
    
    private lazy var viewModel = SavedWeatherViewModel(repository: SavedWeatherRepository(), delegate: self )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedWeatherTableview.dataSource = self
        savedWeatherTableview.register(SavedWeatherTableViewCell.nib(), forCellReuseIdentifier: SavedWeatherTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchSavedLocations()
    }
}

extension SavedWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.fetchSavedLocations()
        return viewModel.savedLocationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedWeatherTableViewCell.identifier,
                                                        for: indexPath)  as? SavedWeatherTableViewCell else { return UITableViewCell() }
        guard let location = viewModel.savedLocation(atIndex: indexPath.item),
              let locationName = location.locationName ,
              let locationTemperature = location.temprature else {
            return UITableViewCell()
        }
        cell.setProperties(locationName: locationName,
                           temperature: locationTemperature)
        return cell
    }
}

extension SavedWeatherViewController: SavedWeatherDeleage {
    func reloadTableView() {
        savedWeatherTableview.reloadData()
    }
}
