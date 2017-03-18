//
//  JSONModel.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/16/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import SwiftyJSON
import RxSwift
import Moya

protocol JSONModel {
    init?(json: JSON)
}

extension ObservableType where E == Response {
    
    /// Map a Moya Response Observable to a model object which implements JSONModel
    ///
    /// - Parameter model: The type of model which implements JSONModel
    /// - Parameter jsonMapper: An optional closure which lets you map the root JSON node to a child node
    /// - Parameter root: The root JSON node, which can be used to drill deeper into the structure
    ///
    /// - Returns: An Observable<T> which emits each instance of your model that could be decoded, then completes
    func mapModel<T: JSONModel>(model: T.Type, jsonMapper: @escaping (_ root: JSON) -> (JSON) = { $0 }) -> Observable<T> {
        return mapJSON().flatMap({ (result) -> Observable<T> in
            return Observable.create({ (observer) -> Disposable in
                
                let mappedJSON = jsonMapper(JSON(result))
                let jsonArray = mappedJSON.array ?? [mappedJSON]
                let models = jsonArray.flatMap { T(json: $0) }
                models.forEach { observer.onNext($0) }
                observer.onCompleted()
                
                return Disposables.create()
            })
        })
    }
}
