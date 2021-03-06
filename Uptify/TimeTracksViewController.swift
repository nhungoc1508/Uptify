//
//  TimeTracksViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit

class TimeTracksViewController: UIViewController {
    @IBOutlet weak var tracksBg: UIImageView!
    @IBOutlet weak var alltime: UIButton!
    @IBOutlet weak var past6months: UIButton!
    @IBOutlet weak var pastmonth: UIButton!
    
    var tracksData = Dictionary<String, Any>()
    
    let steelBlue0_40 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.4).cgColor
    let mauve0 = UIColor(named: "Mauve0")!.cgColor
    let steelBlue0_75 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.75).cgColor
    let jade0_75 = UIColor(named: "Jade0")!.withAlphaComponent(0.75).cgColor

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tracksBg.applyGradient(colors: [steelBlue0_40, mauve0], stops: [0.4, 0.95])
        
        // alltime.layoutIfNeeded()
        // alltime.subviews.first?.contentMode = .scaleAspectFill
        alltime.layer.cornerRadius = 30
        alltime.applyGradient(colors: [steelBlue0_75, jade0_75], corner: 30)
        
        // past6months.layoutIfNeeded()
        // past6months.subviews.first?.contentMode = .scaleAspectFill
        past6months.layer.cornerRadius = 30
        past6months.applyGradient(colors: [steelBlue0_75, jade0_75], corner: 30)
        
        // pastmonth.layoutIfNeeded()
        // pastmonth.subviews.first?.contentMode = .scaleAspectFill
        pastmonth.layer.cornerRadius = 30
        pastmonth.applyGradient(colors: [steelBlue0_75, jade0_75], corner: 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        alltime.subviews.first?.contentMode = .scaleAspectFill
        past6months.subviews.first?.contentMode = .scaleAspectFill
        pastmonth.subviews.first?.contentMode = .scaleAspectFill
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! TopTracksViewController
        viewController.topTracksAll50 = self.tracksData["top-tracks_all-time"] as! [[String:Any]]
        if segue.identifier == "alltime" {
            viewController.label = "all time"
            viewController.topTracks = self.tracksData["top-tracks_all-time"] as! [[String:Any]]
        } else if segue.identifier == "6months" {
            viewController.label = "the past 6 months"
            viewController.topTracks = self.tracksData["top-tracks_6-months"] as! [[String:Any]]
        } else if segue.identifier == "month" {
            viewController.label = "the past month"
            viewController.topTracks = self.tracksData["top-tracks_month"] as! [[String:Any]]
        }
    }
}
