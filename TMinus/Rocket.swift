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
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string else { return nil }
        
        self.id = id
        self.name = name
    }
}
