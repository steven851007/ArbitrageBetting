//
//  ArbitrageNavigationController.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 30.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import UIKit
import CoreData

class ArbitrageNavigationController: UINavigationController {

    var configuration: Configuration!
    var masterViewController: MasterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.masterViewController = (self.viewControllers.first as! MasterViewController)
        self.masterViewController.oddsApiNetworkHandler = self.configuration.oddsAPINetworkHandler
        self.masterViewController.fcr = self.configuration.coreDataStack.eventStore.fcr()
        self.masterViewController.coreDataStack = self.configuration.coreDataStack
    }
    

}
