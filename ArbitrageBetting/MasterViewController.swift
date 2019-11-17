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
    var fcr: EventFetchedResulsController!
    var coreDataStack: CoreDataStack!
    var diffableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID>!
    var updatedObjects = [NSManagedObjectID]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(fetchData(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl!)
        
        navigationItem.leftBarButtonItem = editButtonItem
        self.coreDataStack.applyFilterFor(sites: ["Pinnacle", "Betfair", "bwin", "Betfair Exchange", "William Hill"])
        self.diffableDataSource = UITableViewDiffableDataSource<String, NSManagedObjectID>(tableView: self.tableView, cellProvider: { [unowned self] (tableView, indexPath, _) -> UITableViewCell? in
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
            cell.contentView.backgroundColor = self.updatedObjects.contains(object.objectID) ? .black : .darkGray
            return cell
        })
        self.tableView.dataSource = self.diffableDataSource
        self.tableView.delegate = self
        self.fcr.delegate = self
        self.fcr.fetch()
    }
    
    @objc func fetchData(_ control: UIRefreshControl) {
        self.oddsApiNetworkHandler.fetchLatestEvents { _, error in
            DispatchQueue.main.async {
                control.endRefreshing()
            }
            if let error = error {
                print(error)
                return
            }
        }
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
        view.text = self.fcr.sections[section].name
        return view
    }
    
    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        if indexPath.section < self.fcr.sections.count {
           if indexPath.row < self.fcr.sections[indexPath.section].numberOfObjects {
              return true
           }
        }
        return false
    }

}

extension MasterViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        if self.diffableDataSource.numberOfSections(in: self.tableView) > 0 {
            self.updatedObjects = snapshot.itemIdentifiers
        }
        self.diffableDataSource.apply(snapshot)
    }
    

}
