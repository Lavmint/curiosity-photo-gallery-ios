//
//  Assembly.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 22/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import CoreData
import NasaService

protocol Assemblable {
    var assembly: Assembly! { get set }
}

class Assembly {
    
    let nasaService: NasaService
    let cpgPersistentContainer: NSPersistentContainer
    
    init(nasaService: NasaService, cpgPersistentContainer: NSPersistentContainer) {
        self.cpgPersistentContainer = cpgPersistentContainer
        self.nasaService = nasaService
    }
}
