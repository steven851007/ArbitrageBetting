//
//  MoneyRun.swift
//  ArbitrageBetting
//
//  Created by Istvan Balogh on 2019. 10. 11..
//  Copyright © 2019. Balogh István. All rights reserved.
//

import Foundation

class MoneyRun: Codable {
    
    var sitesFilter = ["bet-at-home", "Interwetten"]
    
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
    
    var maxHomeSite: Site? {
        return self.allSitesOrderedByHomeOdds.first
    }
    
    var maxDrawSite: Site? {
        return self.allSitesOrderedByDrawOdds.first
    }
    
    var maxAwaySite: Site? {
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
    
    var allSitesOrderedByHomeOdds: [Site] {
        return self.allSites.filter { (site) -> Bool in
            site.odds.home != nil
        }.sorted(by: { $0.odds.home! > $1.odds.home! })
    }
    
    var allSitesOrderedByAwayOdds: [Site] {
        return self.allSites.filter { (site) -> Bool in
            site.odds.away != nil
        }.sorted(by: { $0.odds.away! > $1.odds.away! })
    }
    
    var allSitesOrderedByDrawOdds: [Site] {
        return self.allSites.filter { (site) -> Bool in
            site.odds.draw != nil
        }.sorted(by: { $0.odds.draw! > $1.odds.draw! })
    }
    
    var allSites: [Site] {
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
    
    let twelveBet: Site?
    let oneEightEightBet: Site?
    let oneEightBet: Site?
    let oneXBet: Site?
    let eightEightEightSport: Site?
    let asianodds: Site?
    let betAtHome: Site?
    let bet365: Site?
    let betago: Site?
    let betclic: Site?
    let betfair: Site?
    let betfairExchange: Site?
    let betfred: Site?
    let bethard: Site?
    let betjoe: Site?
    let betsafe: Site?
    let betsson: Site?
    let betvictor: Site?
    let betway: Site?
    let boylesports: Site?
    let bwin: Site?
    let comeon: Site?
    let coolbet: Site?
    let dafabet: Site?
    let expekt: Site?
    let intertops: Site?
    let interwetten: Site?
    let jetbull: Site?
    let leonbets: Site?
    let marathonbet: Site?
    let matchbook: Site?
    let mrgreen: Site?
    let nordicbet: Site?
    let oddsring: Site?
    let pinnacle: Site?
    let sbobet: Site?
    let sportingbet: Site?
    let titanbet: Site?
    let unibet: Site?
    let williamHill: Site?
    let youwin: Site?
    
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
