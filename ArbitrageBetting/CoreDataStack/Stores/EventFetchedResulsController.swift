//
//  BaseFetchedResulsController.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 17.11.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation
import CoreData

class EventFetchedResulsController: NSFetchedResultsController<Event> {
    
    override var fetchedObjects: [Event] {
        get {
            return super.fetchedObjects ?? []
        }
    }
    
    override var sections: [NSFetchedResultsSectionInfo] {
        get {
            return super.sections ?? []
        }
    }
    
    func fetch() {
        do {
            try self.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
}
