//
//  ViewController.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    let provider = RxMoyaProvider<API>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = provider.request(.showLaunches(page: 0))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .subscribe { (event) in
            switch event {
            case .next(let response):
                print("")
            case .error(let error):
                print("")
            default:
                break
            }
        }
    }
}

