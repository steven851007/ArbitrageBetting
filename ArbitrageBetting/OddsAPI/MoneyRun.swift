//
//  MoneyRun.swift
//  ArbitrageBetting
//
//  Created by Istvan Balogh on 2019. 10. 11..
//  Copyright © 2019. Balogh István. All rights reserved.
//

import Foundation

class MoneyRun: Codable {
    
    var sitesFilter = ["Pinnacle", "Betfair", "bwin", "Betfair Exchange", "William Hill"]
    
    var combinedMarketMargin: Float {
        return self.maxHomeProbability + self.maxAwayProbability + self.maxDrawProbability
    }
    
    var maxHomeProbability: Float {
        return 1/self.maxHomeOdd
    }
    
    var maxAwayProbability: Float {
        return 1/self.maxAwayOdd
    }
    
    var maxDrawProbability: Float {
        return 1/self.maxDrawOdd
    }
    
    var maxHomeSite: OddsAPISite? {
        return self.allSitesOrderedByHomeOdds.first
    }
    
    var maxDrawSite: OddsAPISite? {
        return self.allSitesOrderedByDrawOdds.first
    }
    
    var maxAwaySite: OddsAPISite? {
        return self.allSitesOrderedByAwayOdds.first
    }
    
    var maxHomeOdd: Float {
        return self.maxHomeSite?.odds.home ?? Float.leastNormalMagnitude
    }
    
    var maxDrawOdd: Float {
        return self.maxDrawSite?.odds.draw ?? Float.leastNormalMagnitude
    }
    
    var maxAwayOdd: Float {
        return self.maxAwaySite?.odds.away ?? Float.leastNormalMagnitude
    }
    
    var allSitesOrderedByHomeOdds: [OddsAPISite] {
        return self.allSites.filter { (site) -> Bool in
            site.odds.home != nil
        }.sorted(by: { $0.odds.home! > $1.odds.home! })
    }
    
    var allSitesOrderedByAwayOdds: [OddsAPISite] {
        return self.allSites.filter { (site) -> Bool in
            site.odds.away != nil
        }.sorted(by: { $0.odds.away! > $1.odds.away! })
    }
    
    var allSitesOrderedByDrawOdds: [OddsAPISite] {
        return self.allSites.filter { (site) -> Bool in
            site.odds.draw != nil
        }.sorted(by: { $0.odds.draw! > $1.odds.draw! })
    }
    
    var allSites: [OddsAPISite] {
        return [self.twelveBet,
        self.oneEightEightBet,
        self.oneEightBet,
        self.oneXBet,
        self.eightEightEightSport,
        self.asianodds,
        self.betAtHome,
        self.bet365,
        self.betago,
        self.betclic,
        self.betfair,
        self.betfairExchange,
        self.betfred,
        self.bethard,
        self.betjoe,
        self.betsafe,
        self.betsson,
        self.betvictor,
        self.betway,
        self.boylesports,
        self.bwin,
        self.comeon,
        self.coolbet,
        self.dafabet,
        self.expekt,
        self.intertops,
        self.interwetten,
        self.jetbull,
        self.leonbets,
        self.marathonbet,
        self.matchbook,
        self.mrgreen,
        self.nordicbet,
        self.oddsring,
        self.pinnacle,
        self.sbobet,
        self.sportingbet,
        self.titanbet,
        self.unibet,
        self.williamHill,
        self.youwin].compactMap { $0 }.filter { (site) -> Bool in
            sitesFilter.contains(site.name)
        }
    }
    
    let twelveBet: OddsAPISite?
    let oneEightEightBet: OddsAPISite?
    let oneEightBet: OddsAPISite?
    let oneXBet: OddsAPISite?
    let eightEightEightSport: OddsAPISite?
    let asianodds: OddsAPISite?
    let betAtHome: OddsAPISite?
    let bet365: OddsAPISite?
    let betago: OddsAPISite?
    let betclic: OddsAPISite?
    let betfair: OddsAPISite?
    let betfairExchange: OddsAPISite?
    let betfred: OddsAPISite?
    let bethard: OddsAPISite?
    let betjoe: OddsAPISite?
    let betsafe: OddsAPISite?
    let betsson: OddsAPISite?
    let betvictor: OddsAPISite?
    let betway: OddsAPISite?
    let boylesports: OddsAPISite?
    let bwin: OddsAPISite?
    let comeon: OddsAPISite?
    let coolbet: OddsAPISite?
    let dafabet: OddsAPISite?
    let expekt: OddsAPISite?
    let intertops: OddsAPISite?
    let interwetten: OddsAPISite?
    let jetbull: OddsAPISite?
    let leonbets: OddsAPISite?
    let marathonbet: OddsAPISite?
    let matchbook: OddsAPISite?
    let mrgreen: OddsAPISite?
    let nordicbet: OddsAPISite?
    let oddsring: OddsAPISite?
    let pinnacle: OddsAPISite?
    let sbobet: OddsAPISite?
    let sportingbet: OddsAPISite?
    let titanbet: OddsAPISite?
    let unibet: OddsAPISite?
    let williamHill: OddsAPISite?
    let youwin: OddsAPISite?
    
    enum CodingKeys: String, CodingKey {
        case twelveBet = "12bet"
        case oneEightEightBet = "188bet"
        case oneEightBet = "18bet"
        case oneXBet = "1xbet"
        case eightEightEightSport = "888sport"
        case asianodds = "asianodds"
        case betAtHome = "bet-at-home"
        case bet365 = "bet365"
        case betago = "betago"
        case betclic = "betclic"
        case betfair = "betfair"
        case betfairExchange = "betfair-exchange"
        case betfred = "betfred"
        case bethard = "bethard"
        case betjoe = "betjoe"
        case betsafe = "betsafe"
        case betsson = "betsson"
        case betvictor = "betvictor"
        case betway = "betway"
        case boylesports = "boylesports"
        case bwin = "bwin"
        case comeon = "comeon"
        case coolbet = "coolbet"
        case dafabet = "dafabet"
        case expekt = "expekt"
        case intertops = "intertops"
        case interwetten = "interwetten"
        case jetbull = "jetbull"
        case leonbets = "leonbets"
        case marathonbet = "marathonbet"
        case matchbook = "matchbook"
        case mrgreen = "mrgreen"
        case nordicbet = "nordicbet"
        case oddsring = "oddsring"
        case pinnacle = "pinnacle"
        case sbobet = "sbobet"
        case sportingbet = "sportingbet"
        case titanbet = "titanbet"
        case unibet = "unibet"
        case williamHill = "william-hill"
        case youwin = "youwin"
    }
}
