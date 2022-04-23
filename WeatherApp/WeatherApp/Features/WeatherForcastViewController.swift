//
//  ViewController.swift
//  WeatherApp
//
//  Created by Simekani Mabambi on 2022/04/21.
//

import UIKit

class WeatherForcastViewController: UIViewController {

    @IBOutlet weak var futureForcastTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        futureForcastTableView.dataSource = self
        futureForcastTableView.register( WeatherInfoTableViewCell.nib(),
                                         forCellReuseIdentifier: WeatherInfoTableViewCell.identifier)
    }
    
}

extension WeatherForcastViewController : UITableViewDataSource{
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

