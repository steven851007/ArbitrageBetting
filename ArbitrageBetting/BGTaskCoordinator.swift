//
//  BGTaskCoordinator.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 10.11.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation
import BackgroundTasks

class BGTaskCoordinator {
    
    let coreDataStack: CoreDataStack
    let oddsAPINetworkHandler: OddsAPINetworkHandler
    
    init(coreDataStack: CoreDataStack, oddsAPINetworkHandler: OddsAPINetworkHandler) {
        self.coreDataStack = coreDataStack
        self.oddsAPINetworkHandler = oddsAPINetworkHandler
    }
    
    func registerForTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.arbitrageBetting.refresh", using: nil) { [unowned self] (task) in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
   // Fetch the latest feed entries from server.
    func handleAppRefresh(task: BGAppRefreshTask) {
        self.scheduleAppRefresh()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let operation = BlockOperation { [weak self] in
            self?.oddsAPINetworkHandler.fetchLatestEvents(completion: { (objects, error) in
                print("Successfully fetched items in the background")
            })
        }
        
        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            queue.cancelAllOperations()
        }

        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }

        queue.addOperations([operation], waitUntilFinished: false)
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.arbitrageBetting.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval.oneHour)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
}

extension TimeInterval {
    static let oneHour: TimeInterval = 60 * 60
}
