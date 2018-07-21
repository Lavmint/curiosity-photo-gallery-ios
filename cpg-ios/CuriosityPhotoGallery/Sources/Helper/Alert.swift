//
//  Alert.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit

public struct AlertMessage {
    public var title: String?
    public var message: String?
    public init(title: String?, message: String?) {
        self.title = title
        self.message = message
    }
}

enum Alert {
    
    public static func ok(message: String, action: (() -> Void)? = nil) -> UIAlertController {
        let msg = AlertMessage(title: nil, message: message)
        return Alert.ok(message: msg, action: action)
    }
    
    public static func ok(message: AlertMessage, action: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: message.title, message: message.message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            action?()
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(alertAction)
        return alertController
    }
}
