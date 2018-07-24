//
//  Location+Pad.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/19/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import CoreLocation

struct Location: Codable {
    let id: Int
    let name: String
    let countryCode: String
    let pads: [Pad]
}

struct Pad: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
        case infoURLString = "infoURL"
        case wikiURLString = "wikiURL"
        case mapURLString = "mapURL"
        case agencies
    }
    
    let id: Int
    let name: String
    let agencies: [Agency]
    
    fileprivate let infoURLString: String?
    fileprivate let wikiURLString: String?
    fileprivate let mapURLString: String?
    fileprivate let latitude: Double
    fileprivate let longitude: Double
}

extension Pad {
    var infoURL: URL? {
        return infoURLString.flatMap(URL.init)
    }
    var wikiURL: URL? {
        return wikiURLString.flatMap(URL.init)
    }
    var mapURL: URL? {
        return mapURLString.flatMap(URL.init)
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
