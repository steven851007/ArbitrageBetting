//
//  AppDelegate.swift
//  ArbitrageBetting
//
//  Created by Istvan Balogh on 2019. 10. 11..
//  Copyright © 2019. Balogh István. All rights reserved.
//

import UIKit
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

class Configuration {
    
    let coreDataStack = CoreDataStack()
    let oddsAPINetworkHandler: OddsAPINetworkHandler
    
    init() {
        self.oddsAPINetworkHandler = OddsAPINetworkHandler(coreDataStack: self.coreDataStack)
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let configuration = Configuration()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack

    

    // MARK: - Core Data Saving support

  


}

