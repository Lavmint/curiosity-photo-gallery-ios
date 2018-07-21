//
//  PhotoViewController.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, GenericView {
    
    typealias View = PhotoView
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genericView.delegate = self
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return genericView.imageView
    }
}

extension PhotoViewController: PhotoViewDelegate {
    
    func onSwipe(sender: PhotoView) {
        self.dismiss(animated: true, completion: nil)
    }
}
