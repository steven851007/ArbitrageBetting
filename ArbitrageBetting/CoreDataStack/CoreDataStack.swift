//
//  CoreDataStack.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 01.11.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let persistentContainer: NSPersistentContainer
    let eventStore: EventStore
    let homeOddsStore: HomeOddsStore
    let awayOddsStore: AwayOddsStore
    let drawOddsStore: DrawOddsStore
    let oddsStore: OddsStore
    let syncronizer: CoreDataSyncronizer
    
    init() {
        let container = NSPersistentContainer(name: "ArbitrageBetting")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.persistentContainer = container
        self.eventStore = EventStore(context: self.persistentContainer.viewContext)
        self.homeOddsStore = HomeOddsStore(context: self.persistentContainer.viewContext)
        self.awayOddsStore = AwayOddsStore(context: self.persistentContainer.viewContext)
        self.drawOddsStore = DrawOddsStore(context: self.persistentContainer.viewContext)
        self.oddsStore = OddsStore(context: self.persistentContainer.viewContext)
        self.syncronizer = CoreDataSyncronizer(eventStore: self.eventStore, homeOddsStore: self.homeOddsStore, awayOddsStore: self.awayOddsStore, drawOddsStore: self.drawOddsStore)
    }
    
    func applyFilterFor(sites: [String]) {
        self.oddsStore.applyFilterFor(sites: sites)
        self.eventStore.recalculateCombinedMarketMargins()
        self.eventStore.save()
    }
    
}
