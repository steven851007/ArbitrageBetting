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
    
    func fetchRequestResult() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
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
    
    func deleteObject(_ object: T) {
        self.context.delete(object)
    }
    
    func deleteObjectsWithRequest(_ request: NSBatchDeleteRequest) {
        do {
            try context.execute(request)
        } catch {
            print ("There was an error")
        }
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

class HomeOddsStore: BaseStore<HomeOdds> {
    
    func createOrUpdateIn(_ homeOddsArray: inout [HomeOdds], with oddsAPISite: OddsAPISite) -> HomeOdds? {
        if let homeOdds = oddsAPISite.odds.home {
            if let result = (homeOddsArray.filter { $0.bookmakerName == oddsAPISite.name }).first {
                if result.odds != homeOdds {
                    result.odds = homeOdds
                }
            } else {
                let newHomeOdd = self.newObject()
                newHomeOdd.bookmakerName = oddsAPISite.name
                newHomeOdd.odds = homeOdds
                return newHomeOdd
            }
        }
        return nil
    }
}

class AwayOddsStore: BaseStore<AwayOdds> {

    func createOrUpdateIn(_ awayOddsArray: inout [AwayOdds], with oddsAPISite: OddsAPISite) -> AwayOdds? {
        if let awayOdds = oddsAPISite.odds.away {
            if let result = (awayOddsArray.filter { $0.bookmakerName == oddsAPISite.name }).first {
                if result.odds != awayOdds {
                    result.odds = awayOdds
                }
            } else {
                let newAwayOdd = self.newObject()
                newAwayOdd.bookmakerName = oddsAPISite.name
                newAwayOdd.odds = awayOdds
                return newAwayOdd
            }
        }
        return nil
    }
}

class DrawOddsStore: BaseStore<DrawOdds> {

    func createOrUpdateIn(_ drawOddsArray: inout [DrawOdds], with oddsAPISite: OddsAPISite) -> DrawOdds? {
        if let drawOdds = oddsAPISite.odds.draw {
            if let result = (drawOddsArray.filter { $0.bookmakerName == oddsAPISite.name }).first {
                if result.odds != drawOdds {
                    result.odds = drawOdds
                }
            } else {
                let newDrawOdd = self.newObject()
                newDrawOdd.bookmakerName = oddsAPISite.name
                newDrawOdd.odds = drawOdds
                return newDrawOdd
            }
        }
        return nil
    }
}
