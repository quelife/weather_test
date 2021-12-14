//
//  Forecast.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import SwiftyJSON

class Forecast: NSObject {
    
    var list: [List] = []
    
    
    init(withJSON json: JSON) {
        super.init()
        parseData(withJSON: json)
    }
    
    func parseData(withJSON json: JSON) {
        list = json["list"].arrayValue.compactMap { List(fromJson: $0) }
    }

}

class List: NSObject {
    
    var dt = Date()
    var time: String = ""
    var date: String = ""
    var weather: [Weather] = []
    var main: Main?
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let time = json["dt"].intValue
        self.dt = Date(timeIntervalSince1970: Double(time))
        self.time = Double(time).getTime()
        self.date = Double(time).getDate()
        weather = json["weather"].arrayValue.compactMap { Weather(fromJson: $0) }
        let mainData = json["main"]
        if !mainData.isEmpty{
            main = Main(fromJson: mainData)
        }
    }
}
