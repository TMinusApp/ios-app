//
//  Location+Pad.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/19/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import SwiftyJSON
import CoreLocation

struct Location: JSONModel {
    let id: Int
    let name: String
    let countryCode: String
    let pad: Pad
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string,
            let countryCode = json["countryCode"].string,
            let pad = Pad(json: json["pads"][0]) else { assertionFailure(); return nil }
        
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.pad = pad
    }
}

struct Pad: JSONModel {
    let id: Int
    let name: String
    let infoURL: URL?
    let wikiURL: URL?
    let mapURL: URL?
    let coordinate: CLLocationCoordinate2D
    let agencies: [Agency]
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string,
            let latitude = json["latitude"].double,
            let longitude = json["longitude"].double else { assertionFailure(); return nil }
        
        self.id = id
        self.name = name
        self.infoURL = json["infoURL"].string.flatMap({ URL(string: $0) })
        self.wikiURL = json["wikiURL"].string.flatMap({ URL(string: $0) })
        self.mapURL = json["mapURL"].string.flatMap({ URL(string: $0) })
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.agencies = (json["agencies"].array ?? []).flatMap { Agency(json: $0) }
    }
}
