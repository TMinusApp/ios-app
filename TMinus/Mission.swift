//
//  Mission.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/19/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import SwiftyJSON

struct Mission: JSONModel {
    let id: Int
    let name: String
    let description: String
    let type: String
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string,
            let description = json["description"].string,
            let type = json["typeName"].string else { assertionFailure(); return nil }
        
        self.id = id
        self.name = name
        self.description = description
        self.type = type
    }
}
