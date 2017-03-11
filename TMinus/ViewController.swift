//
//  ViewController.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let provider = RxMoyaProvider<API>()
    var disposeBag = DisposeBag()
    fileprivate var launches = [Launch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        provider.request(.showLaunches(page: 0))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .map({ (response) -> [Launch] in
            guard let response = response as? [String: Any],
                let launches = response["launches"] as? [[String:Any]] else { return [] }
            return launches.flatMap { Launch(dict: $0) }
        })
        .bindTo(tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.reuseID) as! LaunchCell
            cell.configure(with: element)
            return cell
        }
        .disposed(by: disposeBag)
    }
}
