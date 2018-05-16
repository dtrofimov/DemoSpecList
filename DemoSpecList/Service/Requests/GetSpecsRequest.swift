//
//  GetSpecsRequest.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import Result
import Alamofire

class GetSpecsRequest {
    var docDocApiClient: DocDocApiClient!
    var useCache = true
    
    private var afRequest: DataRequest?
    
    func perform(completionHandler: @escaping ServiceCompletionHandler<[Spec]>) {
        self.afRequest = self.docDocApiClient.getJson(path: "/speciality/city/\(Constants.DocDocApi.predefinedCityId)/onlySimple/1", useCache: self.useCache) { (response) in
            completionHandler(Result.init(attempt: { () -> [Spec] in
                guard let resObj = response.result.value else {
                    throw ServiceError(afError: response.result.error!)
                }
                guard let resDict = resObj as? NSDictionary,
                    let specDicts = resDict["SpecList"] as? NSArray else {
                        throw ServiceError.invalidResponse
                }
                return try specDicts.map({ (specDictUnsafe) -> Spec in
                    guard let specDict = specDictUnsafe as? NSDictionary else {
                        throw ServiceError.invalidResponse
                    }
                    var spec: Spec = PlainSpec()
                    spec.map(fromDict: specDict)
                    guard spec.isValid else {
                        throw ServiceError.invalidResponse
                    }
                    return spec
                })
            }), response.response)
        }
    }
    
    func cancel() {
        guard let afRequest = self.afRequest else { return }
        afRequest.cancel()
    }
}
