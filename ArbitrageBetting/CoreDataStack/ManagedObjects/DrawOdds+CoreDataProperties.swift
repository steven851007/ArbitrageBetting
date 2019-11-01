//
//  DrawOdds+CoreDataProperties.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DrawOdds)
public class DrawOdds: Odds {

}

extension DrawOdds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrawOdds> {
        return NSFetchRequest<DrawOdds>(entityName: "DrawOdds")
    }

    @NSManaged public var event: Event?

}
