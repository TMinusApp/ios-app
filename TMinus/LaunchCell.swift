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
    @IBOutlet var missionIconView: UIImageView!
    @IBOutlet var missionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var probabilityLabel: UILabel!
    
    private var timer: Timer?
    private let textProvider = LaunchTextProvider()
    
    func configure(with launch: Launch) {
        rocketLabel.text = launch.rocket.name
        missionLabel.text = launch.missions.first?.name
        probabilityLabel.text = textProvider.probabilityString(from: launch.probability)
        
        let isHidden = (launch.missions.first?.name ?? "").isEmpty
        missionLabel.isHidden = isHidden
        missionIconView.isHidden = isHidden
        
        configureTimeLabel(with: launch)
        scheduleTimerIfNecessary(for: launch)
    }
    
    //MARK: Private
    
    private func scheduleTimerIfNecessary(for launch: Launch) {
        let timeUntil = launch.windowOpenDate.timeIntervalSinceNow
        if timeUntil < .oneDay * 2 {
            timer = Timer(timeInterval: 0.25, repeats: true) { [weak self] timer in
                self?.configureTimeLabel(with: launch)
            }
            RunLoop.current.add(timer!, forMode: .commonModes)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func configureTimeLabel(with launch: Launch) {
        timeLabel.text = textProvider.countdownString(from: launch.windowOpenDate)
    }
}
