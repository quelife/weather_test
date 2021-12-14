//
//  DetailViewController.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    var dataFor5Days = [[List]]()
    var cityName: String = ""
    var unit: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityLabel.text = "CityName: \(cityName)"
     
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataFor5Days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFor5Days[section].count
    }
    
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataFor5Days[section].first?.date
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell")
        let day = dataFor5Days[indexPath.section][indexPath.row]
        
        cell?.textLabel?.text = day.time
        cell?.imageView?.image = UIImage(named: day.weather.first?.icon ?? "01d")
        let des = day.weather.first?.des
        let temp = day.main?.temperatureString
        let unit = (unit == "metric" ? "°C" : "°F")
        cell?.detailTextLabel?.text = "\(des ?? ""), \(temp ?? "0") \(unit)"
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
