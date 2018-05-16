//
//  Spec+Mapping.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import Foundation

extension Spec {
    mutating func map(fromDict dict: NSDictionary) {
        self.name = dict["NamePlural"] as? String
        self.id = dict["Id"] as? String
    }
}
