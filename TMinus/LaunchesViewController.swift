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
        let now = Date()
        let toAppend = launches.filter { $0.windowOpenDate > now }
        let missing = launches.count - toAppend.count
        launchTotal = total - missing
        self.launches.append(contentsOf: toAppend)
        pagesFetched += 1
    }
}

struct LaunchResponseError: Swift.Error {}

class LaunchesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let provider = RxMoyaProvider<API>()
    private let notificationManager = NotificationManager<Launch>()
    private let disposeBag = DisposeBag()
    
    fileprivate var launchResults = LaunchPageResults()
    private var isFetching = false
    private var loadingView = LoadingView()
    
    //MARK: Superclass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        loadingView.showInView(view)
        fetchNextPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.indexPathForSelectedRow.do { self.tableView.deselectRow(at: $0, animated: true) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SegueID.settings,
            let navController = segue.destination as? UINavigationController,
            let viewController = navController.topViewController as? SettingsViewController {
            
            viewController.delegate = self
        } else if segue.identifier == SegueID.launchDetail,
            let viewController = segue.destination as? LaunchDetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            
            viewController.launch = launchResults.launches[indexPath.row]
        }
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
                self?.loadingView.hide()
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
    
    private func authorizeAndRegisterNotifications(with launches: [Launch]) {
        notificationManager.authorize()
        .subscribe { [weak self] (event) in
            switch event {
            case .next(let status):
                if status == .granted {
                    self?.registerNotifications(with: launches)
                }
            default:
                break
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func registerNotifications(with launches: [Launch]) {
        notificationManager.removePendingNotifications()
        notificationManager.registerNotifications(for: launches)
    }
    
    private func handleFetchComplete(with launches: [Launch], total: Int) {
        launchResults.appendPage(with: launches, total: total)
        authorizeAndRegisterNotifications(with: launchResults.launches)
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

extension LaunchesViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard launchResults.canFetchMoreLaunches else { return }
        let bottomOffset = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y > bottomOffset - 60.0 {
            // 60 points from the bottom of the list
            fetchNextPage()
        }
    }
}

extension LaunchesViewController: SettingsViewControllerDelegate {
    
    func settingsViewControllerFinished(_ viewController: SettingsViewController) {
        dismiss(animated: true, completion: nil)
    }
}
