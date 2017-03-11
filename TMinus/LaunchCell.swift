//
//  LaunchCell.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

struct Launch {
    let name: String
    
    init?(dict: [String: Any]) {
        guard let name = dict["name"] as? String else { return nil }
        self.name = name
    }
}

class LaunchCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    static var reuseID: String {
        return "LaunchCell"
    }
    
    func configure(with launch: Launch) {
        nameLabel.text = launch.name
    }
}
