//
//  DebugPrint.swift
//  T-Minus
//
//  Created by Dalton Claybrook on 5/6/18.
//  Copyright © 2018 Claybrook Software. All rights reserved.
//

import Foundation

//swiftlint:disable no_print
func debugPrint(_ string: String) {
#if !RELEASE
    print(string)
#endif
}
