//
//  LaunchDetailViewController.swift
//  TMinus
//
//  Created by Dalton Claybrook on 4/6/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class LaunchDetailViewController: UIViewController {
    var launch: Launch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let launch = launch {
            configure(withLaunch: launch)
        }
    }
    
    // MARK: Private
    
    private func configure(withLaunch launch: Launch) {
        title = launch.name
    }
}
