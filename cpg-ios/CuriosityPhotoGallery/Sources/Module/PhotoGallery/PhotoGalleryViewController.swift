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
    
    var assembly: Assembly!
    lazy var viewModel: PhotoGalleryViewModel = {
        let vm = PhotoGalleryViewModel()
        vm.assembly = assembly
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Curiosity Photo Gallery"
        
        viewModel.photos
        .bind(to: genericView.collectionView.rx
        .items(
            cellIdentifier: ThumbnailCollectionViewCell.identifier,
            cellType: ThumbnailCollectionViewCell.self
        )) { item, data, cell in
            cell.delegate = self
            cell.imageView.image = data.image
        }
        .disposed(by: viewModel.disposeBag)
        
        genericView.refreshControl.rx.controlEvent(UIControlEvents.valueChanged).asObservable().subscribe { (event) in
            if self.genericView.refreshControl.isRefreshing {
                self.fetchPhotos()
            }
        }.disposed(by: viewModel.disposeBag)
        
        fetchPhotos()
    }
    
    func fetchPhotos() {
        genericView.collectionView.isUserInteractionEnabled = false
        genericView.refreshControl.beginRefreshing()
        viewModel.fetchImages { (error) in
            self.genericView.collectionView.isUserInteractionEnabled = true
            if let err = error {
                self.present(Alert.ok(message: err.localizedDescription), animated: true, completion: {
                    self.genericView.refreshControl.endRefreshing()
                })
            } else {
                self.genericView.refreshControl.endRefreshing()
            }
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
        guard let indexPath = genericView.collectionView.indexPath(for: sender) else { return }
        let alert = Alert.confirm(
            message: AlertMessage(title: nil, message: "Delete item?"),
            ok: {
                self.viewModel.delete(itemAtIndex: indexPath.item)
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
}
