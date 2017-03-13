//
//  Launch.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/12/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Launch {
    let name: String
    
    init?(json: JSON) {
        guard let name = json["name"].string else { return nil }
        self.name = name
    }
}
