//
//  PhotoGalleryViewModel.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import CoreData
import UIKit

class PhotoGalleryViewModel {
    
    lazy var photoWorker: RoverPhotoWorker = {
        return RoverPhotoWorker(with: NSPersistentContainer.curiosityPhotoGalleryPersistentContainer)
    }()
    
    var images: [UIImage] = []
    
    func fetchImages(completion: @escaping (Error?) -> Void) {
        photoWorker.photos(from: .curiosity) { (images, error) in
            self.images = images
            completion(error)
        }
    }
}
