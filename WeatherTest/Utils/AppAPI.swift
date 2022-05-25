//
//  AppAPI.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import Alamofire
import SwiftyJSON
import Foundation

class AppAPI: NSObject {
    @discardableResult class func fetchCurrentWeather(type: RequestCurrentWeatherType, completion: APICompletion? ) -> APIRequest {
        
        var urlString = ""
        switch type {
        case .cityName(let city, let unit):
            urlString = "weather?q=\(city)&appid=\(apiKey)&units=\(unit)".encodeUrl() ?? ""
        case .coordinate(let latitude, let longitude, let unit):
            urlString = "weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(unit)".encodeUrl() ?? ""
        }
        
        let request = APIRequest()
        
        request.url = API_URL(urlString)
        request.method = .get
        request.completion = completion
        
        request.request()
        
        return request
    }
    
    @discardableResult class func fetchForecast5(cityName: String = "", unit: String = "", completion: APICompletion? ) -> APIRequest {
                
        let encodeUrl = "forecast?q=\(cityName)&appid=\(apiKey)&units=\(unit)".encodeUrl()
        let request = APIRequest()
        request.url = API_URL(encodeUrl ?? "")
        request.method = .get
        request.completion = completion
        
        request.request()
        
        return request
    }
}


func API_URL(_ path: String) -> URL {
    let url = "https://api.openweathermap.org/data/2.5/"
    return URL(string: "\(url)\(path)")!
}


extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}
