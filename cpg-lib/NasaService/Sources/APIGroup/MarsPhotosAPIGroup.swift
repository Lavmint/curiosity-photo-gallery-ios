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
        case curiosity
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
        let url = self.url
            .appendingPathComponent("rovers")
            .appendingPathComponent(Rover.curiosity.rawValue)
            .appendingPathComponent("latest_photos")
        let parameters: [String: Any] = [
            "page": page
        ]
        let request = service.requestBuilder.jsonRequest(method: .get, url: url, parameters: parameters)!
        service.perform(request: request, completion: completion)
    }
    
    public func photos(rover: Rover, earthDate: String, completion: @escaping (NasaResult<PhotosResult>) -> Void) {
        let url = self.url
            .appendingPathComponent("rovers")
            .appendingPathComponent(Rover.curiosity.rawValue)
            .appendingPathComponent("photos")
        
        let parameters: [String: Any] = [
            "earth_date": earthDate
        ]
        
        let request = service.requestBuilder.jsonRequest(method: .get, url: url, parameters: parameters)!
        service.perform(request: request, completion: completion)
    }
    
    public func photos(rover: MarsPhotosAPIGroup.Rover, daysAgo days: Int, completion: @escaping (NasaResult<PhotosResult>) -> Void) {
        
        var date = Date()
        let offset = 24 * 60 * 60 * Double(days)
        date = date.addingTimeInterval(-offset)
        
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "yyyy-MM-dd"
        
        self.photos(rover: rover, earthDate: dateFromatter.string(from: date), completion: completion)
    }
    
    /*
     Метод-помощник.
     Так как апи наса позволяет получить только фотки за текущий sol (latest_photos) или за явно указанный sol (photos)
     то приходится использовать вместо page дни, иначе получится что нужно трекать страницу и день, а это жесть какая-то
     уж лучше пусть траффик гуляет, но работает все как надо
     рекурсивная функция, шатает сервер по дням пока не получит 25 фоток
     */
    public func lastest25Photos(rover: MarsPhotosAPIGroup.Rover, day: Int = 0, photos: [RoverPhoto] = [], ignoreIds: [Int] = [], completion: @escaping (NasaResult<PhotosResult>) -> Void) {
        self.photos(rover: rover, daysAgo: day) { (result) in
            switch result {
            case .success(let r):
                let p = r?.photos ?? []
                var newPhotos: [RoverPhoto] = photos
                for photo in p where !ignoreIds.contains(photo.id) {
                    newPhotos.append(photo)
                }
                if newPhotos.count < 25 {
                    self.lastest25Photos(rover: rover, day: day + 1, photos: newPhotos, ignoreIds: ignoreIds, completion: completion)
                } else {
                    let overridenResult = NasaResult<PhotosResult>.object(
                        result: PhotosResult.init(photos: [RoverPhoto](newPhotos[0..<25]), error: nil),
                        error: nil
                    )
                    completion(overridenResult)
                }
            case .failure:
                completion(result)
            }
        }
    }
}
