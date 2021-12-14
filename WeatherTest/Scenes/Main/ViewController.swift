//
//  ViewController.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import UIKit
import CoreLocation
import SwiftyJSON
import RxSwift
import RxCocoa
import SDWebImage
import ActivityIndicatorManager

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureUnitLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var unit: String = "metric"
    var isSearchForCityName: Bool = false
    var cityName: String = ""
    
    private let forecastViewModel = ForecastViewModel()
    private let disposeBag = DisposeBag()
    
    lazy var locationManager: CLLocationManager = {
        let location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyKilometer
        location.requestWhenInUseAuthorization()
        return location
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeViewModel()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            isSearchForCityName = true
            cityName = city
            loadData()
        }
    }
    
    @IBAction func segmentedControlUnitAction(_ sender: UISegmentedControl) {
        AIMActivityIndicatorManager.sharedInstance.shouldShowIndicator()
        if sender.selectedSegmentIndex == 0 {
            unit = "metric"
        }else {
            unit = "imperial"
        }
        loadData()
    }
    
    @IBAction func fiveDaysAction(_ sender: UIBarButtonItem) {
        forecastViewModel.fetchForecast5(cityName: cityName, unit: unit)
    }
}

// MARK: - SubscribeViewModel
extension ViewController {
    func subscribeViewModel() {
        // MARK: - CurrentWeatherSubject
        self.forecastViewModel.CurrentWeatherSubject.subscribe(
            onNext: { response in
                AIMActivityIndicatorManager.sharedInstance.forceHideIndicator()
                self.cityName = self.forecastViewModel.currentWeather?.name ?? ""
                self.cityLabel.text = self.forecastViewModel.currentWeather?.name
                self.temperatureLabel.text = self.forecastViewModel.currentWeather?.main?.temperatureString
                self.humidityLabel.text = self.forecastViewModel.currentWeather?.main?.humidityString
                self.temperatureUnitLabel.text = (self.unit == "metric") ? "°C":"°F"
                 let img = self.forecastViewModel.currentWeather?.weather.first?.urlIconNameString
                 self.weatherIconImageView.sd_setImage(with: URL(string: img!), placeholderImage: nil, options: .allowInvalidSSLCertificates)
            }).disposed(by: disposeBag)
        
        
        // MARK: - Forecast5Subject
        self.forecastViewModel.Forecast5Subject.subscribe(
            onNext: { response in
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.dataFor5Days = self.forecastViewModel.dataFor5Days
                vc.cityName = self.cityName
                vc.unit = self.unit
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func loadData() {
        if isSearchForCityName {
            forecastViewModel.fetchCurrentWeather(type: .cityName(city: cityName, unit: unit))
        }else{
            forecastViewModel.fetchCurrentWeather(type: .coordinate(latitude: latitude,
                                                                    longitude: longitude,
                                                                    unit: unit))
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            print("Location permission denied")
        case .restricted:
            print("Location permission restricted")
        case .notDetermined:
            print("Location permission notDetermined")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        loadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - SearchAlertController
extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { (tf) in
            tf.placeholder = "Enter city Name"
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
