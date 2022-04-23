//
//  ViewController.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/21.
//

import UIKit
import CoreLocation

class WeatherForcastViewController: UIViewController {

    @IBOutlet weak var futureForcastTableView: UITableView!
    let manager  = CLLocationManager()
    
    let viewModel = WeatherForcastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        futureForcastTableView.dataSource = self
        futureForcastTableView.register( WeatherInfoTableViewCell.nib(),
                                         forCellReuseIdentifier: WeatherInfoTableViewCell.identifier)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
}

extension WeatherForcastViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.identifier)  as? WeatherInfoTableViewCell else {
           return UITableViewCell()
        }
        
        return cell
    }
}

extension WeatherForcastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.startUpdatingLocation()
            viewModel.setLocation(location: location)
        }
    }
}
