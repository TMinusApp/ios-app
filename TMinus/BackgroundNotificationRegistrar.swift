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

struct BackgroundNotificationRegistrar {

    private let provider = RxMoyaProvider<API>()
    private let notificationManager = NotificationManager<Launch>()
    private let disposeBag = DisposeBag()
    
    func register(with completion: @escaping (UIBackgroundFetchResult) -> Void) {
        let launches = provider.request(.showLaunches(page: 0))
        let authorize = notificationManager.authorize()
        
        Observable.combineLatest(launches, authorize) { launchResponse, authStatus in
            return authStatus == .granted ? launchResponse : nil
            }
            .unwrap()
            .mapModel(model: Launch.self) { $0["launches"] }
            .bindTo(BlockObserver(notificationManager) { error in
                completion(error == nil ? .newData : .failed)
            })
            .disposed(by: disposeBag)
    }
}

struct BlockObserver<T: ObserverType, U>: ObserverType where U == T.E {
    typealias E = U
    private let child: T
    private let completion: (Swift.Error?) -> ()
    
    init(_ child: T, completion: @escaping (Swift.Error?) -> ()) {
        self.child = child
        self.completion = completion
    }
    
    func on(_ event: Event<U>) {
        child.on(event)
        switch event {
        case .completed:
            completion(nil)
        case .error(let error):
            completion(error)
        default:
            break
        }
    }
}
