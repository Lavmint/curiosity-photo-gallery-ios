//
//  NasaRequest.swift
//  NasaService
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import Foundation

class NasaRequestBuilder {
    
    enum Method: String {
        case get
    }
    
    let baseURL: URL
    let apiKey: String
    
    init(baseURL: URL, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
        
    func jsonRequest(method: Method, url: URL, parameters: [String: Any]) -> URLRequest? {
        
        var mutableParameters = parameters
        mutableParameters.updateValue(apiKey, forKey: "api_key")
        
        switch method {
        case .get:
            guard let url = appendGetParameters(url: url, query: createGetQuery(mutableParameters)) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return request
        }
    }
    
    private func appendGetParameters(url: URL, query: String) -> URL? {
        var mutablePath = url.absoluteString
        mutablePath += query.count > 0 ? "?" + query : ""
        guard let url = URL(string: mutablePath) else { return nil }
        return url
    }
    
    private func createGetQuery(_ parameters: [String: Any]) -> String {
        var urlParameters = ""
        for (idx, parameter) in parameters.enumerated() {
            urlParameters += "\(parameter.key)=\(parameter.value)"
            if idx < parameters.count - 1 {
                urlParameters += "&"
            }
        }
        return urlParameters
    }
}
