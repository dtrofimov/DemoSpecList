//
//  Constants.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import Foundation

struct Constants {
    struct DocDocApi {
        static let baseUrl = URL(string: "https://api.docdoc.ru/public/rest/1.0.9")!
        static let predefinedUsername = "partner.13703"
        static let predefinedPassword = "ZZdFmtJD"
        static let predefinedCityId = "1"
    }
    struct CannotLoadBanner {
        static let duration = 3.0
    }
}
