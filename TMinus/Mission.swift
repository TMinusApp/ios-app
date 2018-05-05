//
//  Mission.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/19/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

struct Mission: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case type = "typeName"
    }
    
    let id: Int
    let name: String
    let description: String
    let type: String
}
