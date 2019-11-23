//
//  CoreDataSyncronizer.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 31.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSyncronizer {
    
    let eventStore: EventStore
    let homeOddsStore: HomeOddsStore
    let awayOddsStore: AwayOddsStore
    let drawOddsStore: DrawOddsStore
    
    
    init(eventStore: EventStore, homeOddsStore: HomeOddsStore, awayOddsStore: AwayOddsStore, drawOddsStore: DrawOddsStore) {
        self.eventStore = eventStore
        self.homeOddsStore = homeOddsStore
        self.awayOddsStore = awayOddsStore
        self.drawOddsStore = drawOddsStore
    }
    
    func updateWith(responseObjects: [OddsAPIResponseObject]) {
        for responseObject in responseObjects where responseObject.hasAtLeastOneOdds {
            self.createOrUpdateEventWith(responseObject)
        }
        self.eventStore.save()
    }

    
    func createOrUpdateEventWith(_ responseObject: OddsAPIResponseObject) {
        let event = eventStore.eventFor(homeTeam: responseObject.event.home, awayTeam: responseObject.event.away) ?? eventStore.newObject()
        
        var homeOddsArray = event.homeOdds?.array as? [HomeOdds] ?? [HomeOdds]()
        var awayOddsArray = event.awayOdds?.array as? [AwayOdds] ?? [AwayOdds]()
        var drawOddsArray = event.drawOdds?.array as? [DrawOdds] ?? [DrawOdds]()
        
        for oddsAPISite in responseObject.sites?.moneyRun?.allSites ?? [] {
            if let newHomeOdd = self.homeOddsStore.createOrUpdateIn(homeOddsArray, with: oddsAPISite) {
                newHomeOdd.event = event
                homeOddsArray.append(newHomeOdd)
            }
            
            if let newAwayOdd = self.awayOddsStore.createOrUpdateIn(awayOddsArray, with: oddsAPISite) {
                newAwayOdd.event = event
                awayOddsArray.append(newAwayOdd)
            }

            if let newDrawOdd = self.drawOddsStore.createOrUpdateIn(drawOddsArray, with: oddsAPISite) {
                newDrawOdd.event = event
                drawOddsArray.append(newDrawOdd)
            }

        }
        homeOddsArray.sort { $0.odds > $1.odds }
        awayOddsArray.sort { $0.odds > $1.odds }
        drawOddsArray.sort { $0.odds > $1.odds }
        
        guard let highestHomeOdd = homeOddsArray.first?.odds,
            let highestAwayOdd = awayOddsArray.first?.odds,
            let highestDrawOdd = drawOddsArray.first?.odds else {
                fatalError()
                
        }
        
        if event.eventId == nil {
            event.eventId = UUID()
        }
        
        if event.homeTeam != responseObject.event.home {
            event.homeTeam = responseObject.event.home
        }

        if event.awayTeam != responseObject.event.away {
            event.awayTeam = responseObject.event.away
        }

        if event.date != responseObject.event.start_time {
            event.date = responseObject.event.start_time
        }

        if event.combinedMarketMargin != 1/highestHomeOdd + 1/highestAwayOdd + 1/highestDrawOdd {
            event.combinedMarketMargin = 1/highestHomeOdd + 1/highestAwayOdd + 1/highestDrawOdd
        }

        if event.homeOdds != NSOrderedSet(array: homeOddsArray) {
            event.homeOdds = NSOrderedSet(array: homeOddsArray)
        }

        if event.awayOdds != NSOrderedSet(array: awayOddsArray) {
            event.awayOdds = NSOrderedSet(array: awayOddsArray)
        }

        if event.drawOdds != NSOrderedSet(array: drawOddsArray) {
            event.drawOdds = NSOrderedSet(array: drawOddsArray)
        }
    }
    
}
