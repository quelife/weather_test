//
//  AppAPI.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import Alamofire
import SwiftyJSON

class AppAPI: NSObject {
    @discardableResult class func fetchCurrentWeather(type: RequestCurrentWeatherType, completion: APICompletion? ) -> APIRequest {
        
        var urlString = ""
        switch type {
        case .cityName(let city, let unit):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=\(unit)"
        case .coordinate(let latitude, let longitude, let unit):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(unit)"
        }
        
        let request = APIRequest()
        
        request.url = URL(string: urlString)!
        request.method = .get
        request.completion = completion
        
        request.request()
        
        return request
    }
    
    @discardableResult class func fetchForecast5(cityName: String = "", unit: String = "", completion: APICompletion? ) -> APIRequest {
        
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=\(unit)"
        
        let request = APIRequest()
        
        request.url = URL(string: urlString)!
        request.method = .get
        request.completion = completion
        
        request.request()
        
        return request
    }
}
