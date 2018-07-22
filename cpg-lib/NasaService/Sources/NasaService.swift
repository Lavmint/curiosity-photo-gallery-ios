//
//  NasaService.swift
//  NasaService
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

public class NasaService {
    
    public let isSecure: Bool
    public let host: String
    public let baseURL: URL
    public let apiKey: String
    
    public init(isSecure: Bool = true, host: String = "api.nasa.gov", apiKey: String = "DEMO_KEY") {
        self.isSecure = isSecure
        self.host = host
        self.baseURL = URL(string: "\(isSecure ? "https" : "http")://\(host)")!
        self.apiKey = apiKey
    }
    
    internal lazy var requestBuilder: NasaRequestBuilder = {
        return NasaRequestBuilder(baseURL: baseURL, apiKey: apiKey)
    }()
    
    public lazy var marsPhotosAPIGroup: MarsPhotosAPIGroup = {
        return MarsPhotosAPIGroup(service: self)
    }()
    
    internal func perform<Result>(request: URLRequest, completion: @escaping (NasaResult<Result>) -> Void) {
        dprint(request)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(NasaResult<Result>.json(data: data, response: response, error: error))
        }
        dataTask.resume()
    }
}
