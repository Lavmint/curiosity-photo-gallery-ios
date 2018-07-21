//
//  RoverPhotoStorage.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import CoreData
import NasaService

class RoverPhotoWorker {
    
    lazy var nasaService: NasaService = {
       return NasaService()
    }()
    
    var persistentContainer: NSPersistentContainer?
    
    init(with persistentContainer: NSPersistentContainer?) {
        self.persistentContainer = persistentContainer
    }
    
    func photos(from rover: MarsPhotosAPIGroup.Rover, completion: @escaping ([UIImage], Error?) -> Void) {
        nasaService.marsPhotosAPIGroup.latestPhotos(rover: rover, page: 1) { (result) in
            switch result {
            case .success(let obj):
                let imageURLs = obj?.latestPhotos?.compactMap({ $0.imgSrc }) ?? []
                var images: [UIImage] = []
                for url in imageURLs {
                    guard let data = try? Data.init(contentsOf: url) else { continue }
                    guard let img = UIImage(data: data) else { continue }
                    images.append(img)
                }
                completion(images, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
}
