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
        for responseObject in responseObjects {
            self.updateWith(responseObject: responseObject)
        }
        self.eventStore.save()
    }
    

    
    func updateWith(responseObject: OddsAPIResponseObject) {
        var homeOddsArray = [HomeOdds]()
        var awayOddsArray = [AwayOdds]()
        var drawOddsArray = [DrawOdds]()
        for oddsAPISite in responseObject.sites?.moneyRun?.allSites ?? [] {
            guard let homeOdds = oddsAPISite.odds.home,
                let awayOdds = oddsAPISite.odds.away,
                let drawOdds = oddsAPISite.odds.draw else {
                    continue
            }
            let newHomeOdd = self.homeOddsStore.newObject()
            newHomeOdd.bookmakerName = oddsAPISite.name
            newHomeOdd.odds = homeOdds
            homeOddsArray.append(newHomeOdd)

            let newAwayOdd = self.awayOddsStore.newObject()
            newAwayOdd.bookmakerName = oddsAPISite.name
            newAwayOdd.odds = awayOdds
            awayOddsArray.append(newAwayOdd)

            let newDrawOdd = self.drawOddsStore.newObject()
            newDrawOdd.bookmakerName = oddsAPISite.name
            newDrawOdd.odds = drawOdds
            drawOddsArray.append(newDrawOdd)
            
        }
        homeOddsArray.sort { $0.odds > $1.odds }
        awayOddsArray.sort { $0.odds > $1.odds }
        drawOddsArray.sort { $0.odds > $1.odds }
        
        guard let highestHomeOdd = homeOddsArray.first?.odds,
            let highestAwayOdd = awayOddsArray.first?.odds,
            let highestDrawOdd = drawOddsArray.first?.odds else { return }
        
        let event = eventStore.eventFor(homeTeam: responseObject.event.home, awayTeam: responseObject.event.away) ?? self.eventStore.newObject()
        event.eventId = UUID()
        event.homeTeam = responseObject.event.home
        event.awayTeam = responseObject.event.away
        event.date = responseObject.event.start_time
        event.combinedMarketMargin = 1/highestHomeOdd + 1/highestAwayOdd + 1/highestDrawOdd
        event.homeOdds = NSOrderedSet(array: homeOddsArray)
        event.awayOdds = NSOrderedSet(array: awayOddsArray)
        event.drawOdds = NSOrderedSet(array: drawOddsArray)
    }
}
