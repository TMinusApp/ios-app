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

/// Used to register local notifications for launches during background fetch
struct BackgroundNotificationRegistrar {
    enum RegistrarError: Swift.Error {
        case notAuthorized
    }
    
    private let provider = MoyaProvider<API>().rx
    private let notificationManager = NotificationManager<Launch>()
    private let disposeBag = DisposeBag()
    
    /// Fetches the first page of launches and registers notifications
    ///
    /// - Parameter completion: the block passed by the system to the background fetch method of the app delegate
    func register(with completion: @escaping (UIBackgroundFetchResult) -> Void) {
        
        notificationManager
            .checkAuthStatus()
            .flatMap { authStatus -> Observable<Response> in
                if authStatus == .granted {
                    return self
                        .provider
                        .request(.showLaunches(page: 0))
                        .asObservable()
                } else {
                    throw RegistrarError.notAuthorized
                }
            }
            .do(onNext: { _ in
                self.notificationManager.removePendingNotifications()
            })
            .mapModel(model: LaunchResponse.self)
            .map { $0.launches }
            .subscribe(onNext: { _ in
                completion(.newData)
            }, onError: { _ in
                completion(.failed)
            })
            .disposed(by: disposeBag)
    }
}
