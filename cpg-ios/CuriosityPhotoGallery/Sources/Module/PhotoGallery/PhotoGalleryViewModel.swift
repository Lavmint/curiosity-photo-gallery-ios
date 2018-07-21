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

class PhotoGalleryViewModel {
    
    lazy var photoWorker: RoverPhotoWorker = {
        return RoverPhotoWorker(with: NSPersistentContainer.curiosityPhotoGalleryPersistentContainer)
    }()
    
    private(set) var images = BehaviorRelay(value: [UIImage]())
    lazy var disposeBag: DisposeBag = {
        DisposeBag()
    }()
    
    func fetchImages(completion: @escaping (Error?) -> Void) {
        photoWorker.photos(from: .curiosity) { (images, error) in
            self.images.accept(images)
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
