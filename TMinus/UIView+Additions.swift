//
//  UIView+Additions.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/13/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

extension UIView { // Constraints
    
    func constrainEdgesToSuperview() {
        constrainEdgesToSuperview(with: .zero)
    }
    
    func constrainEdgesToSuperview(with inset: UIEdgeInsets) {
        guard let superview=superview else { assertionFailure("must have a superview"); return }
        
        translatesAutoresizingMaskIntoConstraints = false
        superview.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left).isActive = true
        superview.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
        superview.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right).isActive = true
        superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom).isActive = true
    }
}

extension UIView { // Actions
    
    class func performWithoutActions(block: () -> ()) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.commit()
    }
}
