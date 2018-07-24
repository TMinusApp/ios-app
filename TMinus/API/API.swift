//
//  API.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

enum API {
    case showLaunches(page: Int)
    case showRockets(page: Int)
    
    var pageSize: Int {
        return 20
    }
}
