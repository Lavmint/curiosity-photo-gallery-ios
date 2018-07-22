//
//  RoverPhotoStorage.swift
//  CuriosityPhotoGallery
//
//  Created by Alexey Averkin on 22/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import CoreData

class CDRoverPhotoStorage {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func markDelete(id: Int) {
        guard let photo = find(id: id) else { return }
        photo.image = nil
        photo.imageURL = nil
        photo.rover = nil
        photo.isDropped = true
        do {
            try context.save()
        } catch {
            dprint(error)
        }
    }
    
    func isExists(id: Int) -> Bool {
        guard let found = find(id: id) else { return false }
        return !found.isDropped
    }
    
    func findOrCreate(id: Int) -> CDRoverPhoto {
        if let found = find(id: id) {
            return found
        }
        let photo = CDRoverPhoto(context: context)
        photo.id = Int32(id)
        photo.isDropped = false
        return photo
    }
    
    func find(id: Int) -> CDRoverPhoto? {
        let request = NSFetchRequest<CDRoverPhoto>()
        request.entity = CDRoverPhoto.entity()
        request.predicate = NSPredicate(format: "id = %d", id)
        do {
            let results = try context.fetch(request)
            if results.count > 1 {
                assertionFailure()
            }
            return results.first
        } catch {
            dprint(error)
        }
        return nil
    }
    
    func fetch(isDeleted: Bool = false) -> [CDRoverPhoto] {
        let request = NSFetchRequest<CDRoverPhoto>()
        request.entity = CDRoverPhoto.entity()
        request.predicate = NSPredicate(format: "isDropped = %@", NSNumber(value: isDeleted))
        var photos: [CDRoverPhoto] = []
        do {
            photos = try context.fetch(request)
        } catch {
            dprint(error)
        }
        return photos
    }
}
