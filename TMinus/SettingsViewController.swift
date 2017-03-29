//
//  SettingsViewController.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/28/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(_ viewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    @IBOutlet var fetchesLabel: UILabel!
    
    //MARK: Superclass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKey.backgroundFetchCount)
        fetchesLabel.text = "Background Fetches: \(count)"
    }
    
    //MARK: Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        delegate?.settingsViewControllerFinished(self)
    }
}
