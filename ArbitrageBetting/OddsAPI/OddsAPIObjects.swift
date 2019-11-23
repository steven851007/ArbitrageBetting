//
//  OddsAPIObjects.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 30.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let longFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

class OddsAPILeague: Codable {
    let name: String
}

class OddsAPIResponseObject: Codable {
    let event: OddsAPIEvent
    let sites: OddsAPISites?
    let league: OddsAPILeague
    
    var hasAtLeastOneOdds: Bool {
        var highestHomeOdd = Float.leastNormalMagnitude
        var highestAwayOdd = Float.leastNormalMagnitude
        var highestDrawOdd = Float.leastNormalMagnitude
        for oddsAPISite in self.sites?.moneyRun?.allSites ?? [] {
            highestHomeOdd = max(highestHomeOdd, oddsAPISite.odds.home ?? Float.leastNormalMagnitude)
            highestAwayOdd = max(highestAwayOdd, oddsAPISite.odds.away ?? Float.leastNormalMagnitude)
            highestDrawOdd = max(highestDrawOdd, oddsAPISite.odds.draw ?? Float.leastNormalMagnitude)
        }
        if highestHomeOdd == Float.leastNormalMagnitude ||
           highestAwayOdd == Float.leastNormalMagnitude ||
            highestDrawOdd == Float.leastNormalMagnitude {
            return false
        }
        
        return true
    }
    
}

class OddsAPIEvent: Codable {
    let home: String
    let away: String
    let start_time: Date
}

class OddsAPIOdds: Codable {
    let home: Float?
    let draw: Float?
    let away: Float?
    
    enum CodingKeys: String, CodingKey {
        case home = "1"
        case draw = "X"
        case away = "2"
    }
}

class OddsAPISite: Codable {
    let name: String
    let odds: OddsAPIOdds
}

class OddsAPISites: Codable {
    let moneyRun: MoneyRun?
    
    enum CodingKeys: String, CodingKey {
        case moneyRun = "1x2"
    }
}
