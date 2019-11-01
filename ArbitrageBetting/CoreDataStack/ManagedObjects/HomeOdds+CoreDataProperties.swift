//
//  HomeOdds+CoreDataProperties.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//
//

import Foundation
import CoreData

@objc(HomeOdds)
public class HomeOdds: Odds {

}

extension HomeOdds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HomeOdds> {
        return NSFetchRequest<HomeOdds>(entityName: "HomeOdds")
    }

    @NSManaged public var event: Event?

}
