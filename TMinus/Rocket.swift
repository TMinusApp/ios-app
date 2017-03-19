//
//  Rocket.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/18/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import SwiftyJSON

struct Rocket: JSONModel {
    let id: Int
    let name: String
    let configuration: String
    let familyName: String
    let agencies: [Agency]
    let wikiURL: URL?
    let imageURL: URL
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string,
            let configuration = json["configuration"].string,
            let familyName = json["familyname"].string,
            let imageURL = json["imageURL"].string.flatMap({ URL(string: $0) }) else { assertionFailure(); return nil }
        
        self.id = id
        self.name = name
        self.configuration = configuration
        self.familyName = familyName
        self.agencies = (json["agencies"].array ?? []).flatMap { Agency(json: $0) }
        self.wikiURL = json["wikiURL"].string.flatMap({ URL(string: $0) })
        self.imageURL = imageURL
    }
}
