//
//  LoadingView.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/13/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var spinnerContainer: UIView!
    var spinner: UIActivityIndicatorView!
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    // MARK: Superclass
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinnerContainer.layer.cornerRadius = spinnerContainer.bounds.width / 2.0
    }
    
    // MARK: Public
    
    func showInView(_ view: UIView) {
        if superview != view {
            view.addSubview(self)
        }
        
        // UIView+Additions.swift
        constrainEdgesToSuperview()
        setViewHidden(false, animated: true)
    }
    
    func hide() {
        setViewHidden(true, animated: true)
    }
    
    // MARK: Private
    
    fileprivate func setupView() {
        spinnerContainer = UIView()
        addSubview(spinnerContainer)
        spinnerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        spinnerContainer.widthAnchor.constraint(equalToConstant: 64).isActive = true
        spinnerContainer.heightAnchor.constraint(equalToConstant: 64).isActive = true
        spinnerContainer.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.0).isActive = true
        spinnerContainer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.startAnimating()
        spinnerContainer.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: spinnerContainer.centerXAnchor, constant: 0.0).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinnerContainer.centerYAnchor, constant: 0.0).isActive = true
        
        spinnerContainer.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        spinnerContainer.layer.masksToBounds = true
        alpha = 0.0
    }
    
    fileprivate func setViewHidden(_ hidden: Bool, animated: Bool) {
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        let duration = animated ? 0.4 : 0.0
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.alpha = alpha
        }, completion: { finished in
            if finished && hidden {
                self.removeFromSuperview()
            }
        })
    }
}
