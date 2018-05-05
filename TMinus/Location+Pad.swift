//
//  Location+Pad.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/19/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable {
    let id: Int
    let name: String
    let countryCode: String
    let pads: [Pad]
}

struct Pad: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let infoURL: URL?
    let wikiURL: URL?
    let mapURL: URL?
    let agencies: [Agency]

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
