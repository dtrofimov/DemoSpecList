//
//  DocDocApiClient.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import Foundation
import Alamofire

class DocDocApiClient {
    let sessionManager: SessionManager
    
    init() {
        let configuration = URLSessionConfiguration.default
        self.sessionManager = SessionManager(configuration: configuration)
    }
    
    func getJson(path: String, useCache: Bool = true, completionHandler: @escaping (DataResponse<Any>) -> ()) -> DataRequest {
        let url = Constants.DocDocApi.baseUrl.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.user = Constants.DocDocApi.predefinedUsername
        urlComponents.password = Constants.DocDocApi.predefinedPassword
        
        var request = URLRequest(url: urlComponents.url!)
        request.cachePolicy = useCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
        return self.sessionManager.request(request).responseJSON(completionHandler: { (response) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
                completionHandler(response)
            })
        })
    }
}
