//
//  TrackViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 08/01/2022.
//

import UIKit
import AlamofireImage
import SpotifyLogin

class TrackViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var recTracksLabel: UILabel!
    
    @IBOutlet weak var artistsView: UICollectionView!
    @IBOutlet weak var recTracksView: UICollectionView!
    
    var trackId = String()
    var track = Dictionary<String, Any>()
    var artists = [[String:Any]]()
    var recTracks = [[String:Any]]()
    var topTracksAll50 = [[String:Any]]()
    
    let jade0_30 = UIColor(named: "Jade0")!.withAlphaComponent(0.3).cgColor
    let steelBlue3 = UIColor(named: "SteelBlue3")!.cgColor
    let steelBlue0 = UIColor(named: "SteelBlue0")!.cgColor

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.artistsView.delegate = self
        self.artistsView.dataSource = self
        self.artistsView.reloadData()
        self.artistsView.backgroundColor = UIColor.clear
        
        self.recTracksView.delegate = self
        self.recTracksView.dataSource = self
        self.recTracksView.reloadData()
        self.recTracksView.backgroundColor = UIColor.clear
        
        self.bg.applyGradient(colors: [jade0_30, steelBlue3, steelBlue0], stops: [0.1, 0.4, 0.8])
        self.trackImage.alpha = 0
        self.trackName.isHidden = true
        self.albumName.isHidden = true
        
        let album = track["album"] as! [String:Any]
        let images = album["images"] as! [[String:Any]]
        let imageUrl = URL(string: images[0]["url"] as! String)
        self.trackImage.alpha = 1
        self.trackImage.af.setImage(withURL: imageUrl!)
        
        self.trackName.isHidden = false
        self.albumName.isHidden = false
        self.trackName.text = track["name"] as? String
        self.albumName.text = album["name"] as? String
        // self.artists = track["artists"] as! [[String:Any]]
        
        if self.topTracksAll50.count == 0 {
            
        }
        
        SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
            if error == nil, token != nil {
                let accessToken = token!
                self?.fetchArtists(accessToken: accessToken)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func fetchArtists(accessToken: String) {
        var ids = [String]()
        for artist in track["artists"] as! [[String:Any]] {
            ids.append(artist["id"] as! String)
        }
        let idString = ids.joined(separator: ",")
        
        let baseUrl = "https://api.spotify.com/v1"
        let endpoint = "/artists?ids=" + idString
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
                self.artists = dataDictionary["artists"] as! [[String:Any]]
                self.artistsView.reloadData()
                self.fetchRecommendations(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchRecommendations(accessToken: String) {
        let baseUrl = "https://api.spotify.com/v1"
        var idsOfArtists = [String]()
        var genres = [String]()
        for artist in self.artists {
            idsOfArtists.append(artist["id"] as! String)
            let allGenres = artist["genres"] as! [String]
            for genre in allGenres {
                genres.append(genre)
            }
        }
        if genres.count > 0 {
            let idsOfArtistsLim = idsOfArtists[...min(5, idsOfArtists.count-1)]
            let genresLim = genres[...min(5, genres.count-1)]
            let artistString = idsOfArtistsLim.joined(separator: ",")
            let genreString = genresLim.joined(separator: ",")
            let endpoint = "/recommendations?seed_artists=\(artistString)&seed_genres=\(genreString)&seed_tracks=\(self.track["id"] as! String)"
            let url = URL(string: (baseUrl + endpoint.replacingOccurrences(of: " ", with: "%20")))
            var request = URLRequest(url: url!)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                // This will run when the network request returns
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if dataDictionary["tracks"] != nil {
                        self.recTracks = dataDictionary["tracks"] as! [[String:Any]]
                        self.recTracksView.reloadData()
                    } else {
                        self.recTracksLabel.isHidden = true
                    }
                }
            }
            task.resume()
        } else {
            self.recTracksLabel.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.artistsView {
            return min(2, self.artists.count)
        } else if collectionView == self.recTracksView {
            return self.recTracks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.artistsView {
            let cell = self.artistsView.dequeueReusableCell(withReuseIdentifier: "TrackViewCollectionViewCell", for: indexPath) as! TrackViewCollectionViewCell
            let artist = self.artists[indexPath.item]
            cell.artistName.text = artist["name"] as? String
            let images = artist["images"] as! [[String:Any]]
            let imageUrl = URL(string: images[0]["url"] as! String)
            cell.artistImage.layer.cornerRadius = 12
            cell.artistImage.af.setImage(withURL: imageUrl!)
            return cell
        } else {
            let cell = self.recTracksView.dequeueReusableCell(withReuseIdentifier: "ArtistViewCollectionViewCell", for: indexPath) as! ArtistViewCollectionViewCell
            let recTrack = self.recTracks[indexPath.item]
            cell.trackName.text = recTrack["name"] as? String
            let album = recTrack["album"] as! [String:Any]
            let images = album["images"] as! [[String:Any]]
            let imageUrl = URL(string: images[0]["url"] as! String)
            cell.trackImage.layer.cornerRadius = 12
            cell.trackImage.af.setImage(withURL: imageUrl!)
            return cell
        }
    }
    
    func filterTopTracks(artistId: String) -> [[String:Any]] {
        var topTracksMine = [[String:Any]]()
        for track in self.topTracksAll50 {
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTrack" {
            let cell = sender as! ArtistViewCollectionViewCell
            let indexPath = self.recTracksView.indexPath(for: cell)!
            let recTrack = self.recTracks[indexPath.item]
            let viewController = segue.destination as! TrackViewController
            viewController.track = recTrack
        } else if segue.identifier == "showArtist" {
            let cell = sender as! TrackViewCollectionViewCell
            let indexPath = self.artistsView.indexPath(for: cell)!
            let artist = self.artists[indexPath.item]
            let viewController = segue.destination as! ArtistViewController
            let artistId = artist["id"] as! String
            viewController.artistId = artistId
            let topTracks = filterTopTracks(artistId: artistId)
            viewController.topTracksMine = topTracks
            viewController.topTracksAll50 = self.topTracksAll50
        }
    }

}
