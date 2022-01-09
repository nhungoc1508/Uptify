//
//  TopArtistsViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit
import AlamofireImage

class TopArtistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topartistsBg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenLabel: UILabel!
    
    var topArtists = [[String:Any]]()
    var topTracks = [[String:Any]]()
    var label = String()
    
    let jade0_40 = UIColor(named: "Jade0")!.withAlphaComponent(0.4).cgColor
    let steelBlue0 = UIColor(named: "SteelBlue0")!.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.rowHeight = 155
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        screenLabel.text = "Your top artists of " + label
        
        topartistsBg.applyGradient(colors: [jade0_40, steelBlue0], stops: [0.4, 0.95])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.topArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopArtistsTableViewCell", for: indexPath) as! TopArtistsTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        cell.button.layer.cornerRadius = 15
        cell.button.applyShadow(radius: 7)
        cell.thumbnail.layer.cornerRadius = 15
        cell.thumbnail.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        let artist = self.topArtists[indexPath.row]
        if artist["images"] != nil {
            let images = artist["images"] as! [[String:Any]]
            let imageUrl = URL(string: images[0]["url"] as! String)
            cell.thumbnail.af.setImage(withURL: imageUrl!)
        }
        cell.name.text = (artist["name"] as! String)
        cell.rank.text = String(indexPath.row + 1)
        
        return cell
    }
    
    @objc func showArtistDetail() {
        self.performSegue(withIdentifier: "showArtist", sender: self)
    }
    
    func filterTopTracks(artistId: String) -> [[String:Any]] {
        var topTracksMine = [[String:Any]]()
        for track in self.topTracks {
            let artists = track["artists"] as! [[String:Any]]
            for artist in artists {
                if artistId == artist["id"] as! String {
                    topTracksMine.append(track)
                }
            }
        }
        return topTracksMine
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendBtn = sender as! UIButton
        if let superview = sendBtn.superview, let cell = superview.superview as? TopArtistsTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let artist = self.topArtists[indexPath.row]
                let viewController = segue.destination as! ArtistViewController
                let artistId = artist["id"] as! String
                viewController.artistId = artistId
                let topTracks = filterTopTracks(artistId: artistId)
                viewController.topTracksMine = topTracks
                viewController.topTracksAll50 = self.topTracks
            }
        }
    }
}
