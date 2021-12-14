//
//  ForecastViewModel.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import Alamofire

class ForecastViewModel {
    
    private let disposeBag = DisposeBag()
    
    var currentWeather: CurrentWeather?
    var dataFor5Days: [[List]] = [[], [], [], [], [], []]
    
    public let CurrentWeatherSubject : PublishSubject<String?> = PublishSubject()
    public let Forecast5Subject : PublishSubject<String?> = PublishSubject()
        
    public func fetchCurrentWeather(type: RequestCurrentWeatherType = .cityName(city: "", unit: "metric")) {
        AppAPI.fetchCurrentWeather(type: type) { (response) in
            if let json = response.data {
                let data = CurrentWeather(withJSON: json)
                if data.main != nil {
                    self.currentWeather = data
                    self.CurrentWeatherSubject.onNext(nil)
                }
            }else {
                self.CurrentWeatherSubject.onNext(nil)
            }
        }
    }
    
    public func fetchForecast5(cityName: String = "", unit: String = "") {
        AppAPI.fetchForecast5(cityName: cityName, unit: unit) { (response) in
            if let json = response.data {
                let data = Forecast(withJSON: json)
                self.sortWeatherByDays(with: data)
            }else {
                self.Forecast5Subject.onNext(nil)
            }
        }
    }
    
    private func sortWeatherByDays(with forcast: Forecast) {
        dataFor5Days = [[], [], [], [], [], []]
        var i = 0
        guard var prevDate = forcast.list.first?.dt else { return }
        for elem in forcast.list {
            if !elem.dt.hasSame(Calendar.Component.day, as: prevDate) {
                i += 1
                prevDate = elem.dt
            }
            dataFor5Days[i].append(elem)
        }
        self.Forecast5Subject.onNext(nil)
    }
}
