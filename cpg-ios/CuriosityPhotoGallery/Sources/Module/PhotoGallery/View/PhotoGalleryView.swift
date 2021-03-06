//
//  PhotoGalleryView.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

class PhotoGalleryView: UIView, NibLoadableView {
    
    @IBOutlet var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: ThumbnailCollectionViewCell.identifier, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.gray
        self.refreshControl = refreshControl
        
        collectionView.addSubview(refreshControl)
    }
}
