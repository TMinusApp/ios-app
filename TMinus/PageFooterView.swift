//
//  PageFooterView.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/12/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class PageFooterView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //MARK: Private
    
    private func setupUI() {
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
