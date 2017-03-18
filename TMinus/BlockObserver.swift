//
//  BlockObserver.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/18/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import RxSwift

/// An observer which wraps another child observer, and calls a completion block on the completion of a subscription.
struct BlockObserver<T: ObserverType, U>: ObserverType where U == T.E {
    typealias E = U
    private let child: T
    private let completion: (Swift.Error?) -> Void
    
    init(_ child: T, completion: @escaping (Swift.Error?) -> Void) {
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
