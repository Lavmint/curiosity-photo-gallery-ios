//
//  MarsPhotosAPIGroup.swift
//  NasaService
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import Foundation

public class MarsPhotosAPIGroup {
    
    public enum Rover: String {
        case curiosity = "rovers/curiosity"
    }
    
    weak private(set) var service: NasaService!
    public let version: String
    public let path: String
    
    private var url: URL {
        return service.baseURL.appendingPathComponent(path).appendingPathComponent(version)
    }
    
    internal init(service: NasaService, version: String = "v1", path: String = "mars-photos/api") {
        self.service = service
        self.version = version
        self.path = path
    }
    
    public func latestPhotos(rover: Rover, page: Int, completion: @escaping (NasaResult<LatestPhotosResult>) -> Void) {
        let url = self.url.appendingPathComponent(Rover.curiosity.rawValue).appendingPathComponent("latest_photos")
        let parameters: [String: Any] = [
            "page": page
        ]
        let request = service.requestBuilder.jsonRequest(method: .get, url: url, parameters: parameters)!
        service.perform(request: request, completion: completion)
    }
}
