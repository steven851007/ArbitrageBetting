//
//  OddsStore.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 17.11.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation

class OddsStore: BaseStore<Odds> {
    
    func applyFilterFor(sites: [String]) {
        for odd in self.allObjects() {
            odd.isActive = sites.isEmpty ? true : sites.contains(odd.bookmakerName)
        }
    }
    
}
