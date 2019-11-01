//
//  Odds+CoreDataProperties.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//
//

import Foundation
import CoreData


@objc(Odds)
public class Odds: NSManagedObject {

}

extension Odds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Odds> {
        return NSFetchRequest<Odds>(entityName: "Odds")
    }

    @NSManaged public var bookmakerName: String
    @NSManaged public var odds: Float
    @NSManaged public var isActive: Bool

}

