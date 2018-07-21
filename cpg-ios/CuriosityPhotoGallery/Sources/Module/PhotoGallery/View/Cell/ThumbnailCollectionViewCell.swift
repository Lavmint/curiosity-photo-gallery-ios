//
//  ThumbnailCollectionViewCell.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

protocol ThumbnailCollectionViewCellDelegate: class {
    func onTapped(sender: ThumbnailCollectionViewCell)
    func onLongPress(sender: ThumbnailCollectionViewCell)
}

class ThumbnailCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    weak var delegate: ThumbnailCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        self.addGestureRecognizer(longPressGR)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        self.addGestureRecognizer(tapGR)
    }

    @objc private func onTapped(_ sender: UITapGestureRecognizer) {
        delegate?.onTapped(sender: self)
    }
    
    @objc private func onLongPress(_ sender: UILongPressGestureRecognizer) {
        delegate?.onLongPress(sender: self)
    }
    
}
