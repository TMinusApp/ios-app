//
//  BackgroundNotificationRegistrar.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/18/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxSwiftExt

/// Used to register local notifications for launches during background fetch
struct BackgroundNotificationRegistrar {

    private let provider = RxMoyaProvider<API>()
    private let notificationManager = NotificationManager<Launch>()
    private let disposeBag = DisposeBag()
    
    /// Fetches the first page of launches and registers notifications
    ///
    /// - Parameter completion: the block passed by the system to the background fetch method of the app delegate
    func register(with completion: @escaping (UIBackgroundFetchResult) -> Void) {
        let launches = provider.request(.showLaunches(page: 0))
        let authorize = notificationManager.authorize()
        
        Observable.combineLatest(launches, authorize) { launchResponse, authStatus in
            return authStatus == .granted ? launchResponse : nil
            }
            .unwrap()
            .do(onNext: { _ in
                self.notificationManager.removePendingNotifications()
            })
            .mapModel(model: Launch.self) { $0["launches"] }
            .bindTo(BlockObserver(notificationManager) { error in
                completion(error == nil ? .newData : .failed)
            })
            .disposed(by: disposeBag)
    }
}
