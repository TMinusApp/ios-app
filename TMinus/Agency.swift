//
//  Agency.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/19/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import SwiftyJSON

enum AgencyType: Int {
    case unknown
    case government
    case multinational
    case commercial
    case educational
    case `private`
    
    init(_ rawValue: Int) {
        self = AgencyType(rawValue: rawValue) ?? .unknown
    }
}

struct Agency: JSONModel {
    let id: Int
    let name: String
    let abbreviation: String
    let countryCode: String
    let type: AgencyType
    let infoURL: URL?
    let wikiURL: URL?
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string,
            let type = json["type"].int.flatMap({ AgencyType($0) }),
            let abbreviation = json["abbrev"].string,
            let countryCode = json["countryCode"].string else { assertionFailure(); return nil }
        
        self.id = id
        self.name = name
        self.type = type
        self.abbreviation = abbreviation
        self.countryCode = countryCode
        self.infoURL = json["infoURL"].string.flatMap({ URL(string: $0) })
        self.wikiURL = json["wikiURL"].string.flatMap({ URL(string: $0) })
    }
}
