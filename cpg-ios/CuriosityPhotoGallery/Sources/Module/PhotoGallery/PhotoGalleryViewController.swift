//
//  PhotoGalleryController.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit
import RxCocoa
import NasaService

class PhotoGalleryViewController: UIViewController, GenericView {

    typealias View = PhotoGalleryView
    
    lazy var viewModel: PhotoGalleryViewModel = {
        return PhotoGalleryViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Curiosity Photo Gallery"
        
        _ = viewModel.images.bind(to: genericView.collectionView.rx
            .items(
                cellIdentifier: ThumbnailCollectionViewCell.identifier,
                cellType: ThumbnailCollectionViewCell.self
            )) { item, data, cell in
                cell.delegate = self
                cell.imageView.image = data
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.fetchImages { (error) in
            guard let err = error else { return }
            self.present(Alert.ok(message: err.localizedDescription), animated: true, completion: nil)
        }
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    
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
        print("deleting...")
    }
}
