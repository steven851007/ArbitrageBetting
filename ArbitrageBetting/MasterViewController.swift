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
    var diffableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        self.coreDataStack.applyFilterFor(sites: ["Pinnacle", "Betfair", "bwin", "Betfair Exchange", "William Hill"])
        self.diffableDataSource = UITableViewDiffableDataSource<String, NSManagedObjectID>(tableView: self.tableView, cellProvider: { (tableView, indexPath, _) -> UITableViewCell? in
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
        })
        self.tableView.dataSource = self.diffableDataSource
        self.tableView.delegate = self
        self.fcr.delegate = self
        do {
            try self.fcr.performFetch()
            self.updateSnapshot()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
//        self.oddsApiNetworkHandler.fetchLatestEvents { responseObject, error in
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
    
    func updateSnapshot() {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<String, NSManagedObjectID>()
        guard let sections = self.fcr.sections else { return }
        let sectionIds = sections.map { $0.name }
        diffableDataSourceSnapshot.appendSections(sectionIds)
        
        for (_, sectionInfo) in sections.enumerated() {
            guard let objects = sectionInfo.objects as? [NSManagedObject] else { return }
            let objectIds = objects.map { $0.objectID }
            diffableDataSourceSnapshot.appendItems(objectIds, toSection: sectionInfo.name)
        }
            
        self.diffableDataSource.apply(diffableDataSourceSnapshot)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        view.text = self.fcr.sections?[section].name
        return view
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

}

extension MasterViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        self.diffableDataSource.apply(snapshot)
    }
}
