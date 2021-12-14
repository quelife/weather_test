//
//  CurrentWeather.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import SwiftyJSON
import CoreLocation

enum RequestCurrentWeatherType {
    case cityName(city: String, unit: String)
    case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees, unit: String)
}

class CurrentWeather: NSObject {

    var name: String = ""
    var main: Main?
    var weather: [Weather] = []
    
    init(withJSON json: JSON) {
        super.init()
        parseData(withJSON: json)
    }
    
    func parseData(withJSON json: JSON) {
        name = json["name"].stringValue
        let mainData = json["main"]
        if !mainData.isEmpty{
            main = Main(fromJson: mainData)
        }
        weather = json["weather"].arrayValue.compactMap { Weather(fromJson: $0) }
    }
}

class Main: NSObject {
    var temp: Double = 0.0
    var humidity: Double = 0.0
    
    var temperatureString: String {
        return String(format: "%.0f", temp)
    }
    
    var humidityString: String {
        return "\(String(format: "%.0f", humidity))%"
    }
    
    init(fromJson json: JSON!){
        if json.isEmpty{ return }
        temp = json["temp"].doubleValue
        humidity = json["humidity"].doubleValue
    }
}

class Weather: NSObject {
    var id: Int = 0    
    var icon: String = "01d"
    var des: String = ""
    var urlIconNameString: String {
        return "http://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        icon = json["icon"].stringValue
        des = json["main"].stringValue
    }
}
