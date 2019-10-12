//
//  MasterViewController.swift
//  ArbitrageBetting
//
//  Created by Istvan Balogh on 2019. 10. 11..
//  Copyright © 2019. Balogh István. All rights reserved.
//

import UIKit

class League: Codable {
    let name: String
}

class ResponseObject: Codable {
    let event: Event
    let sites: Sites?
    let league: League
    
    var combinedMarketMargin: Float? {
        return self.sites?.moneyRun?.combinedMarketMargin
    }
}

class Event: Codable {
    let home: String
    let away: String
}
class Odds: Codable {
    let home: Float?
    let draw: Float?
    let away: Float?
    
    enum CodingKeys: String, CodingKey {
        case home = "1"
        case draw = "X"
        case away = "2"
    }
}

class Site: Codable {
    let name: String
    let odds: Odds
}

class Sites: Codable {
    let moneyRun: MoneyRun?

    enum CodingKeys: String, CodingKey {
        case moneyRun = "1x2"
    }
}




class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let urlString = "https://app.oddsapi.io/api/v1/odds"
    var responseObjects: [ResponseObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.sendRequest(self.urlString, parameters: ["sport": "soccer"]) { responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            self.responseObjects = responseObject
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping ([ResponseObject]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        request.setValue("720e3a60-ec48-11e9-aa5a-7de85876d229", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    completion(nil, error)
                    return
            }

            let responseObjects: [ResponseObject] = try! JSONDecoder().decode([ResponseObject].self, from: data).filter { $0.combinedMarketMargin != nil }.sorted(by: { $0.combinedMarketMargin! < $1.combinedMarketMargin! })
            completion(responseObjects, nil)
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = responseObjects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = responseObjects[indexPath.row]
        cell.textLabel!.text = object.event.home + " - " + object.event.away
        guard let moneyRun = object.sites?.moneyRun else {
            return cell
        }
        cell.detailTextLabel?.text = "1: \(moneyRun.maxHomeSite?.name ?? "") X: \(moneyRun.maxDrawSite?.name ?? "") 2: \(moneyRun.maxAwaySite?.name ?? "") %: \(object.combinedMarketMargin!)"
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

