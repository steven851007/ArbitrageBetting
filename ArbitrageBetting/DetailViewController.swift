//
//  DetailViewController.swift
//  ArbitrageBetting
//
//  Created by Istvan Balogh on 2019. 10. 11..
//  Copyright © 2019. Balogh István. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var awayOddsLabel: UILabel!
    @IBOutlet weak var awayBettingSite: UILabel!
    @IBOutlet weak var homeOddsLabel: UILabel!
    @IBOutlet weak var homeBettingSite: UILabel!
    @IBOutlet weak var drawOddsLabel: UILabel!
    @IBOutlet weak var drawBettingSite: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.event.home + " - " + detail.event.away + " in " + detail.league.name
                guard let moneyRun = detail.sites?.moneyRun else {
                    return
                }
                self.awayOddsLabel.text = "\(moneyRun.maxAwayOdd)"
                self.drawOddsLabel.text = "\(moneyRun.maxDrawOdd)"
                self.homeOddsLabel.text = "\(moneyRun.maxHomeOdd)"
                
                self.awayBettingSite.text = moneyRun.maxAwaySite?.name
                self.homeBettingSite.text = moneyRun.maxHomeSite?.name
                self.drawBettingSite.text = moneyRun.maxDrawSite?.name
                
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                self.dateLabel.text = df.string(from: detail.event.start_time)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: OddsAPIResponseObject? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

