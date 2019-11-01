//
//  SettingViewController.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 29.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    let sites = [String]()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        
    }


}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell")!
        cell.textLabel?.text = "BetFair"
        return cell
    }
}
