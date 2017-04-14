//
//  Optional+Additions.swift
//  TMinus
//
//  Created by Dalton Claybrook on 4/6/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

extension Optional {
    func `do`(block: (Wrapped) -> Void) {
        guard case .some(let unwrapped) = self else { return }
        block(unwrapped)
    }
}
