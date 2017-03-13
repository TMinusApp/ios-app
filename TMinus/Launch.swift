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
    let rocketName: String
    let missionName: String?
    let startDate: Date
    let probability: Double // percentage between 0.0 - 1.0
    
    init?(json: JSON) {
        guard let rocketName = json["rocket"]["name"].string,
            let startDate = json["isostart"].string.flatMap(Date.fromAPIISODateString),
            let probability = json["probability"].double.flatMap({ $0/100.0 }) else { return nil }
        
        self.rocketName = rocketName
        self.missionName = json["missions"][0]["name"].string
        self.startDate = startDate
        self.probability = probability
    }
    
    //MARK: Private
}

extension Date {
    static func fromAPIISODateString(_ dateString: String) -> Date? {
        return DateFormatter.apiISOFormatter.date(from: dateString)
    }
}
