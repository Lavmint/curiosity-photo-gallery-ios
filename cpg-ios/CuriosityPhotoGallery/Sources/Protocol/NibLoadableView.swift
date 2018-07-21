//
//  NibLoadableView.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

public protocol NibLoadableView {
    
}

public extension NibLoadableView where Self: UIView {
    
    public static func loadFromNib(bundle: Bundle = Bundle.main) -> Self! {
        let nibName = "\(self)".components(separatedBy: ".").last!
        return bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? Self
    }
}

