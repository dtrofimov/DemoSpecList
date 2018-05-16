//
//  ServiceError+AFWrapping.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import Alamofire

extension ServiceError {
    init(afError: Error) {
        switch afError {
        case let error as AFError:
            switch error {
            case .responseSerializationFailed(reason: _):
                self = .invalidResponse
            default:
                self = .cannotLoad
            }
        default:
            self = .cannotLoad
        }
    }
}
