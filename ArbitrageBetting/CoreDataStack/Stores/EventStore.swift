//
//  EventStore.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation
import CoreData

public struct EventObjectsDidChangeNotification {

    init(note: Notification) {
        assert(note.name == .NSManagedObjectContextObjectsDidChange)
        notification = note
    }

    public var insertedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInsertedObjectsKey).filter { $0.isKind(of: Event.self) }
    }

    public var updatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSUpdatedObjectsKey).filter { $0.isKind(of: Event.self) }
    }

    public var deletedObjects: Set<NSManagedObject> {
        return objects(forKey: NSDeletedObjectsKey).filter { $0.isKind(of: Event.self) }
    }

    public var refreshedObjects: Set<NSManagedObject> {
        return objects(forKey: NSRefreshedObjectsKey).filter { $0.isKind(of: Event.self) }
    }

    public var invalidatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInvalidatedObjectsKey).filter { $0.isKind(of: Event.self) }
    }

    public var invalidatedAllObjects: Bool {
        return (notification as Notification).userInfo?[NSInvalidatedAllObjectsKey] != nil
    }

    public var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }


    // MARK: Private
    fileprivate let notification: Notification

    fileprivate func objects(forKey key: String) -> Set<NSManagedObject> {
        return ((notification as Notification).userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }

}

extension Notification.Name {
    static let EventStoreObjectsDidChange = Notification.Name("EventStoreObjectsDidChange")

}

class EventStore: BaseStore<Event> {
    
    let notificationCenter: NotificationCenter
    
    init(context: NSManagedObjectContext, notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
        super.init(context: context)
        self.notificationCenter.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc
    func contextObjectsDidChange(_ notification: Notification) {
        let objectsDidChangeNotification = EventObjectsDidChangeNotification(note: notification)
        var changedIDs = objectsDidChangeNotification.insertedObjects.map { $0.objectID }
        changedIDs.append(contentsOf: objectsDidChangeNotification.updatedObjects.map {  $0.objectID })
        guard !changedIDs.isEmpty else { return }
        print(objectsDidChangeNotification.updatedObjects)
        DispatchQueue.main.async {
            self.notificationCenter.post(name: Notification.Name.EventStoreObjectsDidChange, object: self, userInfo: [Notification.Name.EventStoreObjectsDidChange: changedIDs])
        }
    }
    
    func fcr() -> EventFetchedResulsController {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortDate", ascending: true), NSSortDescriptor(key: "combinedMarketMargin", ascending: true)]
        let fcr = EventFetchedResulsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: "sectionName", cacheName: "Root")
        return fcr
    }
    
    func eventFor(homeTeam: String, awayTeam: String) -> Event? {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(homeTeam == %@) AND (awayTeam == %@)", homeTeam, awayTeam)
        do {
            let events = try self.context.fetch(fetchRequest)
            return events.first
           } catch {
              print("Could not fetch \(error)")
        }
        
        return nil
    }
    
    func sortOdds(oddsArray: [Odds]) -> [Odds] {
        return oddsArray.sorted {
            if $0.isActive == $1.isActive {
                return $0.odds > $1.odds
            } else if $0.isActive {
                return true
            }
            return false
        }
    }

    func recalculateCombinedMarketMargins() {
        for event in self.allObjects() {
            var homeOddsArray = event.homeOdds?.array as? [Odds] ?? []
            homeOddsArray = self.sortOdds(oddsArray: homeOddsArray)
            event.homeOdds = NSOrderedSet(array: homeOddsArray)
            
            var awayOddsArray = event.awayOdds?.array as? [Odds] ?? []
            awayOddsArray = self.sortOdds(oddsArray: awayOddsArray)
            event.awayOdds = NSOrderedSet(array: awayOddsArray)
            
            var drawOddsArray = event.drawOdds?.array as? [Odds] ?? []
            drawOddsArray = self.sortOdds(oddsArray: drawOddsArray)
            event.drawOdds = NSOrderedSet(array: drawOddsArray)
            
            guard let highestHomeOdd = homeOddsArray.first?.odds,
                let highestAwayOdd = awayOddsArray.first?.odds,
                let highestDrawOdd = drawOddsArray.first?.odds else {
                    event.combinedMarketMargin = .greatestFiniteMagnitude
                    return
            }
            event.combinedMarketMargin = 1/highestHomeOdd + 1/highestAwayOdd + 1/highestDrawOdd
        }
    }
    
    func deleteAllEventsBeforeDay(_ date: Date) {
        guard let dayDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date)) else {
            fatalError("Failed to strip time from Date object")
        }
        
        let fetchRequest = self.fetchRequestResult()
        fetchRequest.predicate = NSPredicate(format: "sortDate < %@", dayDate as NSDate)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        self.deleteObjectsWithRequest(deleteRequest)
    }
}
