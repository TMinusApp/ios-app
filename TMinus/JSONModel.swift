//
//  JSONModel.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/16/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import RxSwift
import Moya

extension ObservableType where E == Response {
    
    /// Map a Moya Response Observable to a model object which implements Decodable
    ///
    /// - Parameter model: The type of model which implements Decodable
    /// - Returns: An Observable<T> which emits the decoded model, then completes
    public func mapModel<T: Decodable>(model: T.Type) -> Observable<T> {
        return filterSuccessfulStatusCodes()
            .map { response -> T in
                return try self.createModel(from: response)
        }
    }
    
    public func mapModel<T: Decodable, U: Decodable & Swift.Error>(model: T.Type, errorModel: U.Type) -> Observable<T> {
        return mapErrorModel(U.self).mapModel(model: T.self)
    }
    
    public func mapErrorModel<T: Decodable & Swift.Error>(_ model: T.Type) -> Observable<Response> {
        return map { response in
            guard !response.isSuccess else { return response }
            let model: T = try self.createModel(from: response)
            throw model
        }
    }
    
    // MARK: Private
    
    private func createModel<T: Decodable>(from response: Response) throws -> T {
        let decoder = JSONDecoder()
        // TODO: handle date decoding
        return try decoder.decode(T.self, from: response.data)
    }
}

extension Response {
    var isSuccess: Bool {
        return (200..<300).contains(statusCode)
    }
}
