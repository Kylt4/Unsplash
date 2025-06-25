//
//  SendableProxy.swift
//  UnsplashApp
//
//  Created by Christophe Bugnon on 25/06/2025.
//

import Foundation

final class SendableProxy {
    private init() {}
    
    static func makeSendable<Input, Output>(_ closure: @escaping (Input) -> Output) -> @Sendable (Input) -> Output {
        return { value in
            closure(value)
        }
    }

    static func makeSendable<Input, Output>(_ closure: @escaping (Input) -> Output) -> @Sendable (Input) async -> Output {
        return { value in
            closure(value)
        }
    }
}

