//
//  APIRequest.swift
//  WeatherTest
//
//  Created by que on 14/12/2564 BE.
//

import UIKit
import Alamofire
import SwiftyJSON

enum APIResult: Int {
    case success, error
}

class APIResponse: NSObject {
    
    var result: APIResult! = .error
    var data: JSON? = nil
    var error: Error? = nil
    var statusCode: Int = 200
    
    init( withJSON json: JSON, statusCode: Int ) {
        super.init()
        result = .success
        error = nil
        data = json
        self.statusCode = statusCode
    }
    
    init( withError error: Error, statusCode: Int ) {
        super.init()
        result = .error
        data = nil
        self.statusCode = statusCode
        self.error = error
    }
}

typealias APICompletion = (_ response: APIResponse) -> Void

class APIRequest: NSObject {
    
    var url: URL!
    var method:HTTPMethod = HTTPMethod.post
    var data: [String:Any]? = nil
    var headers: HTTPHeaders = []
    var encoding: ParameterEncoding = JSONEncoding.default
    var completion: APICompletion?
    
    func alamofireRequest( request: DataRequest! ) {
        request.responseData { (response) in
            switch response.result {
            case .success(let value):
                let statuscode: Int = response.response?.statusCode ?? -1
                var json: JSON? = try? JSON(data: value)
                if json == nil {
                    json = JSON()
                }
                let apiresponse = APIResponse(withJSON: json!, statusCode: statuscode)
                if let com = self.completion {
                    com(apiresponse)
                }
            case .failure(let error):
                print(error)
                let apiresponse = APIResponse(withError: error, statusCode: -1)
                if let com = self.completion {
                    com(apiresponse)
                }
            }
        }
    }
    
    func request() {
        let request = AF.request(url,
                                 method: method,
                                 parameters: data,
                                 encoding: encoding,
                                 headers: headers)
        alamofireRequest(request: request)
    }
}
