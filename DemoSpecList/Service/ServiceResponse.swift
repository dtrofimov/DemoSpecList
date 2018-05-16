//
//  ServiceResponse.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import Result

enum ServiceError: Error {
    case cannotLoad
    case invalidResponse
    case internalError(comment: String)
}

typealias ServiceCompletionHandler<Value> = (Result<Value, ServiceError>, HTTPURLResponse?) -> ()
