//
//  LaunchesViewModel.swift
//  T-Minus
//
//  Created by Dalton Claybrook on 5/23/18.
//  Copyright © 2018 Claybrook Software. All rights reserved.
//

import RxCocoa
import RxSwift

struct LaunchesViewModel {
    let disposeBag = DisposeBag()
    
    func doStuff() {
        let foo = \LaunchesViewModel.disposeBag
        let viewModel = LaunchesViewModel()
        let bar = viewModel[keyPath: foo]
    }
}
