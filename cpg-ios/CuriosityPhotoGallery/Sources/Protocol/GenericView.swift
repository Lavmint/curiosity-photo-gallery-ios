//
//  GenericView.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

public protocol GenericView {
    associatedtype View: UIView
}

public extension GenericView where Self: UIViewController {
    
    var genericView: View! {
        return self.view as? View
    }
}
