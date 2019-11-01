//
//  BaseStore.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation
import CoreData

class BaseStore<T> where T: NSManagedObject {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchRequest() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: T.self))
    }
    
    func allObjects() -> [T] {
        let fetchRequest = self.fetchRequest()
        do {
            return try self.context.fetch(fetchRequest)
           } catch {
              print("Could not fetch \(error)")
        }
        return []
    }
    
    func newObject() -> T {
        return T(context: self.context)
    }
    
    func save () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

class OddsStore: BaseStore<Odds> {
    func applyFilterFor(sites: [String]) {
        for odd in self.allObjects() {
            odd.isActive = sites.isEmpty ? true : sites.contains(odd.bookmakerName)
        }
    }
}

class HomeOddsStore: BaseStore<HomeOdds> {
    
    
}

class AwayOddsStore: BaseStore<AwayOdds> {

}

class DrawOddsStore: BaseStore<DrawOdds> {

}
