//
//  Configuration.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 10.11.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation

class Configuration {
    
    let coreDataStack = CoreDataStack()
    let oddsAPINetworkHandler: OddsAPINetworkHandler
    let bgTaskCoordinator: BGTaskCoordinator
    
    init() {
        self.oddsAPINetworkHandler = OddsAPINetworkHandler(coreDataStack: self.coreDataStack)
        self.bgTaskCoordinator = BGTaskCoordinator(coreDataStack: self.coreDataStack, oddsAPINetworkHandler: self.oddsAPINetworkHandler)
    }
    
}
