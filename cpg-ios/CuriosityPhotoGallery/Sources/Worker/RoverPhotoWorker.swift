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
    var id: Int { get }
    var image: UIImage? { get }
    var imageURL: URL? { get }
}

class RoverPhotoWorker {
    
    let nasaService: NasaService
    let persistentContainer: NSPersistentContainer
    let queue: DispatchQueue
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    init(nasaService: NasaService, with persistentContainer: NSPersistentContainer) {
        self.nasaService = nasaService
        self.persistentContainer = persistentContainer
        self.queue = DispatchQueue(label: "RoverPhotoWorker", qos: .userInitiated)
    }
    
    func photos(from rover: MarsPhotosAPIGroup.Rover, completion: @escaping ([RoverPhotoProtocol], Error?) -> Void) {
        let storage = CDRoverPhotoStorage(context: self.backgroundContext)
        let ignoredIds = storage.fetch(isDeleted: true).map({ Int($0.id) })
        nasaService.marsPhotosAPIGroup.lastest25Photos(rover: rover, ignoreIds: ignoredIds) { (result) in
            switch result {
            case .success(let obj):
                let photos = obj?.photos ?? []
                let group = DispatchGroup()
                for photo in photos {
                    guard !storage.isExists(id: photo.id) else { continue }
                    group.enter()
                    let task = URLSession.shared.downloadTask(with: photo.imgSrc, completionHandler: { (url, response, error) in
                        defer{
                            group.leave()
                        }
                        guard let u = url, let data = try? Data(contentsOf: u) else { return}
                        let cdphoto = storage.findOrCreate(id: photo.id)
                        cdphoto.imageURL = photo.imgSrc
                        cdphoto.rover = rover.rawValue
                        cdphoto.image = data
                    })
                    task.resume()
                }
                group.notify(queue: self.queue, execute: {
                    do {
                        try storage.context.save()
                    } catch {
                        dprint(error)
                    }
                    completion(storage.fetch().map({ CDRoverPhotoAdapter(photo: $0) }), nil)
                })
            case .failure(let error):
                completion(storage.fetch().map({ CDRoverPhotoAdapter(photo: $0) }), error)
            }
        }
    }
    
    func delete(photoId id: Int) {
        let viewContext = persistentContainer.viewContext
        let storage = CDRoverPhotoStorage(context: viewContext)
        storage.markDelete(id: id)
    }
}

private class CDRoverPhotoAdapter: RoverPhotoProtocol {
    
    let photo: CDRoverPhoto
    
    var image: UIImage? {
        guard let d = photo.image else { return nil }
        return UIImage(data: d)
    }
    
    var imageURL: URL? {
        return photo.imageURL
    }
    
    var id: Int {
        return Int(photo.id)
    }
    
    init(photo: CDRoverPhoto) {
        dprint("adapt photo id: \(photo.id)")
        self.photo = photo
    }
}

private class RoverPhotoAdapter: RoverPhotoProtocol {
    
    let photo: RoverPhoto
    var image: UIImage?
    
    var imageURL: URL? {
        return photo.imgSrc
    }
    
    var id: Int {
        return photo.id
    }
    
    init(photo: RoverPhoto, image: UIImage) {
        self.photo = photo
        self.image = image
    }
}
