//
//  ArtistViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 07/01/2022.
//

import UIKit
import SpotifyLogin
import AlamofireImage

class ArtistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var artistId = String()
    var artistData = Dictionary<String, Any>()
    var topTracksData = [[String:Any]]()
    var topTracksMine = [[String:Any]]()
    var topTracksAll50 = [[String:Any]]()
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistGenres: UILabel!
    @IBOutlet weak var topTracks50Label: UILabel!
    
    @IBOutlet weak var topTracks: UICollectionView!
    @IBOutlet weak var topTracks50: UICollectionView!
    
    let rose0_30 = UIColor(named: "Rose0")!.withAlphaComponent(0.3).cgColor
    let rose3 = UIColor(named: "Rose3")!.cgColor
    let byzantine0 = UIColor(named: "Byzantine0")!.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTracks.delegate = self
        self.topTracks.dataSource = self
        self.topTracks.reloadData()
        self.topTracks.backgroundColor = UIColor.clear
        
        self.topTracks50.delegate = self
        self.topTracks50.dataSource = self
        self.topTracks50.reloadData()
        self.topTracks50.backgroundColor = UIColor.clear
        
        self.bg.applyGradient(colors: [rose0_30, rose3, byzantine0], stops: [0.1, 0.4, 0.8])
        
        self.artistImage.alpha = 0
        self.artistName.isHidden = true
        self.artistGenres.isHidden = true
        
        if self.topTracksMine.count == 0 {
            self.topTracks50Label.isHidden = true
        }
        
        SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
            if error == nil, token != nil {
                let accessToken = token!
                self?.fetchArtist(accessToken: accessToken)
                self?.fetchTopTracks(accessToken: accessToken)
            }
        }

        // Do any additional setup after loading the view.
    }
    
    func fetchArtist(accessToken: String) {
        let baseUrl = "https://api.spotify.com/v1"
        let endpoint = "/artists/" + self.artistId
        let url = URL(string: (baseUrl + endpoint))
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.artistData = dataDictionary
                self.updateInfo()
            }
        }
        task.resume()
    }
    
    func fetchTopTracks(accessToken: String) {
        let baseUrl = "https://api.spotify.com/v1"
        let endpoint = "/artists/\(self.artistId)/top-tracks?market=US"
        let url = URL(string: (baseUrl + endpoint))
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.topTracksData = dataDictionary["tracks"] as! [[String:Any]]
                self.topTracks.reloadData()
            }
        }
        task.resume()
    }
    
    func updateInfo() {
        if artistData["images"] != nil {
            let images = artistData["images"] as! [[String:Any]]
            let imageUrl = URL(string: images[0]["url"] as! String)
            artistImage.af.setImage(withURL: imageUrl!)
        }
        artistImage.alpha = 1
        
        artistName.isHidden = false
        artistName.text = artistData["name"] as? String
        
        artistGenres.isHidden = false
        let genres = artistData["genres"] as! [String]
        if genres.count == 0 {
            artistGenres.isHidden = true
        } else {
            let capGenres = genres.map { $0.capitalized }
            let genreString = capGenres.joined(separator: ", ")
            artistGenres.text = genreString
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topTracks {
            return self.topTracksData.count
        } else if collectionView == self.topTracks50 {
            return self.topTracksMine.count
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.topTracks.dequeueReusableCell(withReuseIdentifier: "ArtistViewCollectionViewCell", for: indexPath) as! ArtistViewCollectionViewCell
        cell.trackImage.layer.cornerRadius = 12
        
        var track = [String:Any]()
        if collectionView == self.topTracks {
            track = self.topTracksData[indexPath.item]
        } else if collectionView == self.topTracks50 {
            track = self.topTracksMine[indexPath.item]
        }
        let trackAlbum = track["album"] as! [String:Any]
        let images = trackAlbum["images"] as! [[String:Any]]
        let imageUrl = URL(string: images[0]["url"] as! String)
        cell.trackImage.af.setImage(withURL: imageUrl!)
        cell.trackName.text = track["name"] as? String
        
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
        let cell = sender as! ArtistViewCollectionViewCell
        let collectionView = cell.superview as! UICollectionView
        var track = [String:Any]()
        if collectionView == self.topTracks {
            let indexPath = self.topTracks.indexPath(for: cell)!
            track = self.topTracksData[indexPath.item]
        } else if collectionView == self.topTracks50 {
            let indexPath = self.topTracks50.indexPath(for: cell)!
            track = self.topTracksMine[indexPath.item]
        }
        let viewController = segue.destination as! TrackViewController
        viewController.track = track
        viewController.topTracksAll50 = self.topTracksAll50
    }

}
