//
//  AwayOdds+CoreDataProperties.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AwayOdds)
public class AwayOdds: Odds {

}


extension AwayOdds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AwayOdds> {
        return NSFetchRequest<AwayOdds>(entityName: "AwayOdds")
    }

    @NSManaged public var event: Event?

}
