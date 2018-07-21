//
//  PhotoGalleryController.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit
import NasaService

class PhotoGalleryViewController: UIViewController, GenericView {

    typealias View = PhotoGalleryView
    
    var service: NasaService!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Curiosity Photo Gallery"
        service = NasaService()
        service.marsPhotosAPIGroup.latestPhotos(rover: .curiosity, page: 1) { (result) in
            switch result {
            case .success(let obj):
                let imageURLs = obj?.latestPhotos?.compactMap({ $0.imgSrc }) ?? []
                var images: [UIImage] = []
                for url in imageURLs {
                    guard let data = try? Data.init(contentsOf: url) else { continue }
                    guard let img = UIImage(data: data) else { continue }
                    images.append(img)
                }
                self.images = images
                DispatchQueue.main.async {
                    self.genericView.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PhotoGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ThumbnailCollectionViewCell.identifier,
            for: indexPath
        )
        if let thumbnailCell = cell as? ThumbnailCollectionViewCell {
            thumbnailCell.delegate = self
            thumbnailCell.imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let divisionSide = genericView.collectionView.frame.width
        let spacing = genericView.collectionViewFlowLayout.minimumInteritemSpacing
        let isProtrait = UIDevice.current.orientation.isPortrait
        let itemsPerRow = isProtrait ? 3 : 5
        
        let width = Int((divisionSide - spacing * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow))
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension PhotoGalleryViewController: ThumbnailCollectionViewCellDelegate {
    
    func onTapped(sender: ThumbnailCollectionViewCell) {
        let controller = PhotoViewController()
        controller.genericView.imageView?.image = sender.imageView.image
        self.present(controller, animated: true, completion: nil)
    }
    
    func onLongPress(sender: ThumbnailCollectionViewCell) {
        print("long press")
    }
}
