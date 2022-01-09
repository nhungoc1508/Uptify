//
//  AnalyzingViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit
import SpotifyLogin

class AnalyzingViewController: UIViewController {
    @IBOutlet weak var analyzingBg: UIImageView!
    
    let jade1_40 = UIColor(named: "Jade1")!.withAlphaComponent(0.4).cgColor
    let rose1 = UIColor(named: "Rose1")!.cgColor
    
    var accessToken = String()
    var data = Dictionary<String, Any>()
    let groups = [
        "top-artists_all-time": "/me/top/artists?time_range=long_term",
        "top-artists_6-months": "/me/top/artists?time_range=medium_term",
        "top-artists_month": "/me/top/artists?time_range=short_term",
        "top-tracks_all-time": "/me/top/tracks?time_range=long_term",
        "top-tracks_6-months": "/me/top/tracks?time_range=medium_term",
        "top-tracks_month": "/me/top/tracks?time_range=short_term"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyzingBg.applyGradient(colors: [jade1_40, rose1], stops: [0.0, 0.9])
        SpotifyLogin.shared.getAccessToken { [weak self] (token, error) in
            if error == nil, token != nil {
                self?.accessToken = token!
            }
        }
        self.fetchAllData()
    }
    
    func fetchAllData() {
        let baseUrl = "https://api.spotify.com/v1"
        let dispatchGroup = DispatchGroup()
        for (name, endpoint) in self.groups {
            let url = URL(string: (baseUrl + endpoint + "&limit=50"))
            dispatchGroup.enter()
            var request = URLRequest(url: url!)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    self.data[name] = dataDictionary["items"] as! Array<Dictionary<String, Any>>
                    dispatchGroup.leave()
                }
            }
            task.resume()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.performSegue(withIdentifier: "showCategory", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! CategoryViewController
        viewController.data = self.data
    }
}
