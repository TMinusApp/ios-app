//
//  LaunchCell.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class LaunchCell: UITableViewCell {
    static var reuseID: String {
        return "LaunchCell"
    }
    
    @IBOutlet var rocketLabel: UILabel!
    @IBOutlet var missionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var probabilityLabel: UILabel!
    
    func configure(with launch: Launch) {
//        rocketLabel.text = launch.rocketName
//        missionLabel.text = launch.missionName
        
    }
    
    //MARK: Private
    
//    private func
}
