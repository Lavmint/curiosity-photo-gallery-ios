//
//  IdentifierReferencable.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

public protocol IdentifierReferencable {
    static var identifier: String { get }
}

extension IdentifierReferencable where Self: NSObject {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: IdentifierReferencable { }
