//
//  RoverPhotoStorage.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import CoreData
import NasaService

protocol RoverPhotoProtocol {
    var image: UIImage? { get }
    var imageURL: URL? { get }
}

class CDRoverPhotoAdapter: RoverPhotoProtocol {
    
    var image: UIImage? {
        guard let d = photo.image else { return nil }
        return UIImage(data: d)
    }
    var imageURL: URL? {
        return photo.imageURL
    }
    
    let photo: CDRoverPhoto
    
    init(photo: CDRoverPhoto) {
        self.photo = photo
    }
}

class RoverPhotoAdapter: RoverPhotoProtocol {
    
    var image: UIImage?
    var imageURL: URL? {
        return photo.imgSrc
    }
    
    let photo: RoverPhoto
    
    init(photo: RoverPhoto, image: UIImage) {
        self.photo = photo
        self.image = image
    }
}

class RoverPhotoWorker {
    
    lazy var nasaService: NasaService = {
       return NasaService()
    }()
    
    lazy var photoStorage: CDRoverPhotoStorage = {
        return CDRoverPhotoStorage(context: persistentContainer.newBackgroundContext())
    }()
    
    var persistentContainer: NSPersistentContainer
    
    init(with persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func photos(from rover: MarsPhotosAPIGroup.Rover, completion: @escaping ([RoverPhotoProtocol], Error?) -> Void) {
        fetch(from: rover, page: 1) { (error) in
            completion(self.photoStorage.fetch().map({ CDRoverPhotoAdapter(photo: $0) }), error)
        }
    }
    
    private func fetch(from rover: MarsPhotosAPIGroup.Rover, page: Int = 1, completion: @escaping (Error?) -> Void) {
        print("Requesting page: \(page)")
        nasaService.marsPhotosAPIGroup.latestPhotos(rover: rover, page: page) { (result) in
            switch result {
            case .success(let obj):
                let photos = obj?.latestPhotos ?? []
                for photo in photos {
                    guard !self.photoStorage.isExists(id: photo.id) else { continue }
                    let cdphoto = self.photoStorage.findOrCreate(id: photo.id)
                    cdphoto.imageURL = photo.imgSrc
                    cdphoto.rover = rover.rawValue
                    guard let data = try? Data.init(contentsOf: photo.imgSrc) else { continue }
                    cdphoto.image = data
                }
                do {
                    try self.photoStorage.context.save()
                } catch {
                    print(error)
                }
                //fetch while not 25 in BD
                if self.photoStorage.fetch().count < 25 {
                    self.fetch(from: rover, page: page + 1, completion: completion)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
}
