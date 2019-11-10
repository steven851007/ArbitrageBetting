//
//  EventStore.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation
import CoreData

class EventStore: BaseStore<Event> {
    
    func fcr() -> NSFetchedResultsController<Event> {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortDate", ascending: true), NSSortDescriptor(key: "combinedMarketMargin", ascending: true)]
        let fcr = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: "sectionName", cacheName: "Root")
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
