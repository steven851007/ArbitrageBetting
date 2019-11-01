//
//  Event+CoreDataProperties.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 30.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }
    
    @NSManaged public var awayTeam: String
    @NSManaged public var date: Date
    @NSManaged public var eventId: UUID
    @NSManaged public var homeTeam: String
    @NSManaged public var combinedMarketMargin: Float
    @NSManaged public var homeOdds: NSOrderedSet?
    @NSManaged public var awayOdds: NSOrderedSet?
    @NSManaged public var drawOdds: NSOrderedSet?
    
}


// MARK: Generated accessors for homeOdds
extension Event {

    @objc(insertObject:inHomeOddsAtIndex:)
    @NSManaged public func insertIntoHomeOdds(_ value: Odds, at idx: Int)

    @objc(removeObjectFromHomeOddsAtIndex:)
    @NSManaged public func removeFromHomeOdds(at idx: Int)

    @objc(insertHomeOdds:atIndexes:)
    @NSManaged public func insertIntoHomeOdds(_ values: [Odds], at indexes: NSIndexSet)

    @objc(removeHomeOddsAtIndexes:)
    @NSManaged public func removeFromHomeOdds(at indexes: NSIndexSet)

    @objc(replaceObjectInHomeOddsAtIndex:withObject:)
    @NSManaged public func replaceHomeOdds(at idx: Int, with value: Odds)

    @objc(replaceHomeOddsAtIndexes:withHomeOdds:)
    @NSManaged public func replaceHomeOdds(at indexes: NSIndexSet, with values: [Odds])

    @objc(addHomeOddsObject:)
    @NSManaged public func addToHomeOdds(_ value: Odds)

    @objc(removeHomeOddsObject:)
    @NSManaged public func removeFromHomeOdds(_ value: Odds)

    @objc(addHomeOdds:)
    @NSManaged public func addToHomeOdds(_ values: NSOrderedSet)

    @objc(removeHomeOdds:)
    @NSManaged public func removeFromHomeOdds(_ values: NSOrderedSet)

}

// MARK: Generated accessors for awayOdds
extension Event {

    @objc(insertObject:inAwayOddsAtIndex:)
    @NSManaged public func insertIntoAwayOdds(_ value: Odds, at idx: Int)

    @objc(removeObjectFromAwayOddsAtIndex:)
    @NSManaged public func removeFromAwayOdds(at idx: Int)

    @objc(insertAwayOdds:atIndexes:)
    @NSManaged public func insertIntoAwayOdds(_ values: [Odds], at indexes: NSIndexSet)

    @objc(removeAwayOddsAtIndexes:)
    @NSManaged public func removeFromAwayOdds(at indexes: NSIndexSet)

    @objc(replaceObjectInAwayOddsAtIndex:withObject:)
    @NSManaged public func replaceAwayOdds(at idx: Int, with value: Odds)

    @objc(replaceAwayOddsAtIndexes:withAwayOdds:)
    @NSManaged public func replaceAwayOdds(at indexes: NSIndexSet, with values: [Odds])

    @objc(addAwayOddsObject:)
    @NSManaged public func addToAwayOdds(_ value: Odds)

    @objc(removeAwayOddsObject:)
    @NSManaged public func removeFromAwayOdds(_ value: Odds)

    @objc(addAwayOdds:)
    @NSManaged public func addToAwayOdds(_ values: NSOrderedSet)

    @objc(removeAwayOdds:)
    @NSManaged public func removeFromAwayOdds(_ values: NSOrderedSet)

}

// MARK: Generated accessors for drawOdds
extension Event {

    @objc(insertObject:inDrawOddsAtIndex:)
    @NSManaged public func insertIntoDrawOdds(_ value: Odds, at idx: Int)

    @objc(removeObjectFromDrawOddsAtIndex:)
    @NSManaged public func removeFromDrawOdds(at idx: Int)

    @objc(insertDrawOdds:atIndexes:)
    @NSManaged public func insertIntoDrawOdds(_ values: [Odds], at indexes: NSIndexSet)

    @objc(removeDrawOddsAtIndexes:)
    @NSManaged public func removeFromDrawOdds(at indexes: NSIndexSet)

    @objc(replaceObjectInDrawOddsAtIndex:withObject:)
    @NSManaged public func replaceDrawOdds(at idx: Int, with value: Odds)

    @objc(replaceDrawOddsAtIndexes:withDrawOdds:)
    @NSManaged public func replaceDrawOdds(at indexes: NSIndexSet, with values: [Odds])

    @objc(addDrawOddsObject:)
    @NSManaged public func addToDrawOdds(_ value: Odds)

    @objc(removeDrawOddsObject:)
    @NSManaged public func removeFromDrawOdds(_ value: Odds)

    @objc(addDrawOdds:)
    @NSManaged public func addToDrawOdds(_ values: NSOrderedSet)

    @objc(removeDrawOdds:)
    @NSManaged public func removeFromDrawOdds(_ values: NSOrderedSet)

}
