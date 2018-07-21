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
    
    lazy var viewModel: PhotoGalleryViewModel = {
        return PhotoGalleryViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Curiosity Photo Gallery"
        viewModel.fetchImages { (error) in
            DispatchQueue.main.async {
                self.genericView.collectionView.reloadData()
            }
        }
    }
}

extension PhotoGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ThumbnailCollectionViewCell.identifier,
            for: indexPath
        )
        if let thumbnailCell = cell as? ThumbnailCollectionViewCell {
            thumbnailCell.delegate = self
            thumbnailCell.imageView.image = viewModel.images[indexPath.item]
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
