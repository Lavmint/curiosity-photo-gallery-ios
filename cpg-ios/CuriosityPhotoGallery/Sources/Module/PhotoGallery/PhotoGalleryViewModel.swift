//
//  PhotoGalleryViewModel.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import CoreData
import UIKit
import RxSwift
import RxCocoa
import NasaService

class PhotoGalleryViewModel: Assemblable {
    
    var assembly: Assembly!
    lazy var photoWorker: RoverPhotoWorker = {
        return RoverPhotoWorker(nasaService: assembly.nasaService, with: assembly.cpgPersistentContainer)
    }()
    
    private(set) var photos = BehaviorRelay(value: [RoverPhotoProtocol]())
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()
    
    func fetchImages(completion: @escaping (Error?) -> Void) {
        photoWorker.photos(from: .curiosity) { (photos, error) in
            self.photos.accept(photos)
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func delete(itemAtIndex index: Int) {
        
        var value = photos.value
        let itemToDelete = value[index]
        
        dprint("Deleting item with id: \(itemToDelete.id)")
        value.remove(at: index)
        photos.accept(value)
        photoWorker.delete(photoId: itemToDelete.id)
    }
}
