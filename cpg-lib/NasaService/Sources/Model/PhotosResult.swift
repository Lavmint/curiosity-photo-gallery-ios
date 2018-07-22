//
//  LatestPhotosResult.swift
//  NasaService
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

public struct LatestPhotosResult: Decodable, FailableResult {
    public let latestPhotos: [RoverPhoto]?
    public let error: NasaServiceError?
}

public struct PhotosResult: Decodable, FailableResult {
    public let photos: [RoverPhoto]?
    public let error: NasaServiceError?
    public init(photos: [RoverPhoto], error: NasaServiceError?) {
        self.photos = photos
        self.error = error
    }
}
