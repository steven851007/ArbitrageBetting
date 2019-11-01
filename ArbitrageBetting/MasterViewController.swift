//
//  MasterViewController.swift
//  ArbitrageBetting
//
//  Created by Istvan Balogh on 2019. 10. 11..
//  Copyright © 2019. Balogh István. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var responseObjects: [OddsAPIResponseObject] = []
    var oddsApiNetworkHandler: OddsAPINetworkHandler!
    var fcr: NSFetchedResultsController<Event>!
    var coreDataStack: CoreDataStack!
//    var diffableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        self.coreDataStack.applyFilterFor(sites: ["Pinnacle", "Betfair", "bwin", "Betfair Exchange", "William Hill"])
//        self.diffableDataSource = UITableViewDiffableDataSource<String, NSManagedObjectID>(tableView: self.tableView, cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
//            return nil
//        })
//        self.tableView.dataSource = self.diffableDataSource
        
        self.fcr.delegate = self
        do {
            try self.fcr.performFetch()
            self.tableView.reloadData()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
//        self.oddsApiNetworkHandler.sendRequest { responseObject, error in
//            guard let responseObject = responseObject, error == nil else {
//                print(error ?? "Unknown error")
//                return
//            }
//            self.responseObjects = responseObject
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = self.fcr.object(at: indexPath)
                let controller = segue.destination as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fcr.sections?[section].name
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.fcr.sectionIndexTitles
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fcr.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fcr.fetchedObjects?.count ?? 0
    }
    
    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if let sections = self.fcr?.sections,
        indexPath.section < sections.count {
           if indexPath.row < sections[indexPath.section].numberOfObjects {
              return true
           }
        }
        return false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard self.validateIndexPath(indexPath) else {
            return cell
        }
        let object = self.fcr.object(at: indexPath)
        cell.textLabel!.text = object.homeTeam + " - " + object.awayTeam
        guard let homeOdds = object.homeOdds?.firstObject as? HomeOdds,
        let awayOdds = object.awayOdds?.firstObject as? AwayOdds,
        let drawOdds = object.drawOdds?.firstObject as? DrawOdds else {
            return cell
        }
        cell.detailTextLabel?.text = "1: \(homeOdds.bookmakerName) X: \(drawOdds.bookmakerName) 2: \(awayOdds.bookmakerName) %: \(object.combinedMarketMargin)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            responseObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

extension MasterViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.tableView.reloadData()
    }
}
