//
//  TimeArtistsViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit

class TimeArtistsViewController: UIViewController {
    @IBOutlet weak var artistsBg: UIImageView!
    @IBOutlet weak var alltime: UIButton!
    @IBOutlet weak var past6months: UIButton!
    @IBOutlet weak var pastmonth: UIButton!
    var artistsData = Dictionary<String, Any>()
    
    let steelBlue0_40 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.4).cgColor
    let mauve0 = UIColor(named: "Mauve0")!.cgColor
    
    let steelBlue0_75 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.75).cgColor
    let jade0_75 = UIColor(named: "Jade0")!.withAlphaComponent(0.75).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistsBg.applyGradient(colors: [steelBlue0_40, mauve0], stops: [0.4, 0.95])
        
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

        // Do any additional setup after loading the view.
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let viewController = segue.destination as! TopArtistsViewController
        viewController.topTracks = self.artistsData["top-tracks_all-time"] as! [[String:Any]]
        if segue.identifier == "alltime" {
            viewController.label = "all time"
            viewController.topArtists = self.artistsData["top-artists_all-time"] as! [[String:Any]]
        } else if segue.identifier == "6months" {
            viewController.label = "the past 6 months"
            viewController.topArtists = self.artistsData["top-artists_6-months"] as! [[String:Any]]
        } else if segue.identifier == "month" {
            viewController.label = "the past month"
            viewController.topArtists = self.artistsData["top-artists_month"] as! [[String:Any]]
        }
    }

}
