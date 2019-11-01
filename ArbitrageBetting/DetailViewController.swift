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
                label.text = detail.homeTeam + " - " + detail.awayTeam //+ " in " + detail.league.name
                guard let homeOdds = detail.homeOdds?.firstObject as? HomeOdds,
                let awayOdds = detail.awayOdds?.firstObject as? AwayOdds,
                let drawOdds = detail.drawOdds?.firstObject as? DrawOdds else {
                    return
                }
                self.awayOddsLabel.text = "\(awayOdds.odds)"
                self.drawOddsLabel.text = "\(drawOdds.odds)"
                self.homeOddsLabel.text = "\(homeOdds.odds)"
                
                self.awayBettingSite.text = awayOdds.bookmakerName
                self.homeBettingSite.text = homeOdds.bookmakerName
                self.drawBettingSite.text = drawOdds.bookmakerName
                
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                self.dateLabel.text = df.string(from: detail.date)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

