//
//  PhotoView.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

protocol PhotoViewDelegate: class {
    func onSwipe(sender: PhotoView)
}

class PhotoView: UIView {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
 
    weak var delegate: PhotoViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.maximumZoomScale = 5
        
        let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        swipeGR.direction = [.down, .up]
        self.addGestureRecognizer(swipeGR)
    }
    
    @objc private func onSwipe() {
        delegate?.onSwipe(sender: self)
    }
}
