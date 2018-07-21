//
//  ViewController.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import UIKit
import NasaService

class ViewController: UIViewController {

    var service: NasaService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        service = NasaService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onFetchMarsPhotos(_ sender: UIButton) {
        service.marsPhotosAPIGroup.latestPhotos(rover: .curiosity, page: 1) { (result) in
            switch result {
            case .success(let obj):
                print(obj ?? "nil")
            case .failure(let error):
                print(error)
            }
        }
    }
}

