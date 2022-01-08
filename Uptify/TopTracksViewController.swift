//
//  TopTracksViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit
import AlamofireImage

class TopTracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var toptracksBg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenLabel: UILabel!
    var topTracks = [[String:Any]]()
    var label = String()
    
    let rose0_40 = UIColor(named: "Rose0")!.withAlphaComponent(0.4).cgColor
    let byzantine0 = UIColor(named: "Byzantine0")!.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        tableView.rowHeight = 155
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        screenLabel.text = "Your top tracks of " + label
        
        toptracksBg.applyGradient(colors: [rose0_40, byzantine0], stops: [0.4, 0.9])

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.topTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopTracksTableViewCell", for: indexPath) as! TopTracksTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        cell.button.layer.cornerRadius = 15
        cell.button.applyShadow(radius: 7)
        cell.thumbnail.layer.cornerRadius = 15
        cell.thumbnail.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        let track = self.topTracks[indexPath.row]
        let album = track["album"] as! [String:Any]
        if album["images"] != nil {
            let images = album["images"] as! [[String:Any]]
            let imageUrl = URL(string: images[0]["url"] as! String)
            cell.thumbnail.af.setImage(withURL: imageUrl!)
        }
        cell.name.text = (track["name"] as! String)
        cell.rank.text = String(indexPath.row + 1)
        let artists = track["artists"] as! [[String:Any]]
        var artistsString = [String]()
        for artist in artists {
            artistsString.append(artist["name"] as! String)
        }
        let allArtists = artistsString.joined(separator: ", ")
        // cell.artist.text = (artists[0]["name"] as! String)
        cell.artist.text = allArtists
        
        return cell
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let sendBtn = sender as! UIButton
        if let superview = sendBtn.superview, let cell = superview.superview as? TopTracksTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let track = self.topTracks[indexPath.row]
                let viewController = segue.destination as! TrackViewController
                // let trackId = track["id"] as! String
                viewController.track = track
            }
        }
    }
}
