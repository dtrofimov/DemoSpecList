//
//  Spec.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import Foundation

protocol Spec {
    var name: String! { get set }
    var id: String! { get set }
}

extension Spec {
    var isValid: Bool {
        return id != nil &&
            !id.isEmpty &&
            name != nil &&
            !name.isEmpty
    }
}

class PlainSpec: Spec {
    var name: String!
    var id: String!
}
