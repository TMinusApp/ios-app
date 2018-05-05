//
//  Rocket.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/18/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

struct Rocket: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case configuration
        case familyName = "familyname"
        case agencies
        case wikiURL
        case imageURL
    }
    
    let id: Int
    let name: String
    let configuration: String
    let familyName: String
    let agencies: [Agency]
    let wikiURL: URL?
    let imageURL: URL
}
