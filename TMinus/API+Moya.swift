//
//  API+Moya.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Moya

extension API: TargetType {
    var headers: [String: String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: "https://launchlibrary.net/1.2")!
    }
    
    var path: String {
        switch self {
        case .showLaunches:
            return "/launch"
        case .showRockets:
            return "/rocket"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        var parameters: [String: Any] = [
            "mode": "verbose",
            "limit": pageSize
        ]
        switch self {
        case .showLaunches(let page):
            let dateString = DateFormatter.apiFormatter.string(from: Date())
            parameters["startdate"] = dateString
            parameters["offset"] = page * pageSize
        case .showRockets(let page):
            parameters["offset"] = page * pageSize
        }
        return parameters
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        // how is this used? why is it required?
        return Data()
    }
    
    var task: Task {
        // TODO: Use Encodable
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
    }
}
