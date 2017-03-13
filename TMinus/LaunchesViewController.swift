//
//  LaunchesViewController.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON

struct LaunchPageResults {
    private(set) var launches = [Launch]()
    private(set) var launchTotal = 0
    private(set) var pagesFetched = 0
    
    var canFetchMoreLaunches: Bool {
        return launchTotal > launches.count
    }
    
    mutating func appendPage(with launches: [Launch], total: Int) {
        self.launches.append(contentsOf: launches)
        launchTotal = total
        pagesFetched += 1
    }
}

struct LaunchResponseError: Swift.Error {}

class LaunchesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let provider = RxMoyaProvider<API>()
    private let disposeBag = DisposeBag()
    
    fileprivate var launchResults = LaunchPageResults()
    private var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        fetchNextPage()
    }
    
    //MARK: Private
    
    fileprivate func fetchNextPage() {
        guard !isFetching else { return }
        
        isFetching = true
        provider.request(.showLaunches(page: launchResults.pagesFetched))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .map { (response) -> (launches: [Launch], total: Int) in
                let json = JSON(response)
                guard let launchJSON = json["launches"].array,
                    let total = json["total"].int else {
                    throw LaunchResponseError()
                }
                let launches = launchJSON.flatMap({ Launch(json: $0) })
                return (launches, total)
            }
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let launches, let total):
                    self?.handleFetchComplete(with: launches, total: total)
                case .error(let error):
                    self?.handleError(error)
                case .completed:
                    self?.isFetching = false
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func handleFetchComplete(with launches: [Launch], total: Int) {
        launchResults.appendPage(with: launches, total: total)
        tableView.reloadData()
    }
    
    private func handleError(_ error: Swift.Error) {
        let alert = UIAlertController(title: "Oops", message: "Something went wrong. Try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LaunchesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return launchResults.launches.count
        } else if launchResults.launches.count < launchResults.launchTotal {
            // show the page cell
            return 1
        } else {
            // hide the page cell
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LaunchCell.reuseID, for: indexPath) as! LaunchCell
            cell.configure(with: launchResults.launches[indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: PageLoadingCell.reuseID, for: indexPath)
        }
    }
}

extension LaunchesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard launchResults.canFetchMoreLaunches else { return }
        let bottomOffset = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y > bottomOffset - 60.0 {
            // 60 points from the bottom of the list
            fetchNextPage()
        }
    }
}
