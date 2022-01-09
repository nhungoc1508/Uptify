//
//  CategoryViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit
import SpotifyLogin

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryBg: UIImageView!
    @IBOutlet weak var topArtists: UIButton!
    @IBOutlet weak var topTracks: UIButton!
    @IBOutlet weak var logOut: UIButton!
    var data = Dictionary<String, Any>()
    let groups = [
        "artists": [
            "top-artists_all-time",
            "top-artists_6-months",
            "top-artists_month",
            "top-tracks_all-time"
        ],
        "tracks": [
            "top-tracks_all-time",
            "top-tracks_6-months",
            "top-tracks_month"
        ]
    ]
    
    let steelBlue0_40 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.4).cgColor
    let mauve0 = UIColor(named: "Mauve0")!.cgColor
    
    let steelBlue0_75 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.75).cgColor
    let jade0_75 = UIColor(named: "Jade0")!.withAlphaComponent(0.75).cgColor
    
    let byzantine0 = UIColor(named: "Byzantine0")!.cgColor
    let steelBlue0 = UIColor(named: "SteelBlue0")!.cgColor
    let jade0 = UIColor(named: "Jade0")!.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryBg.applyGradient(colors: [steelBlue0_40, mauve0], stops: [0.0, 0.8])
        topArtists.layer.cornerRadius = 30
        topArtists.applyGradient(colors: [steelBlue0_75, jade0_75], corner: 30)
        // topArtists.applyShadow()
        
        topTracks.layer.cornerRadius = 30
        topTracks.applyGradient(colors: [steelBlue0_75, jade0_75], corner: 30)
        // topTracks.applyShadow()
        
        logOut.layer.cornerRadius = 12
        logOut.applyGradient(colors: [byzantine0, steelBlue0], corner: 12)

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showArtists" {
            let viewController = segue.destination as! TimeArtistsViewController
            for name in self.groups["artists"]! {
                viewController.artistsData[name] = self.data[name]
            }
        } else if segue.identifier == "showTracks" {
            let viewController = segue.destination as! TimeTracksViewController
            for name in self.groups["tracks"]! {
                viewController.tracksData[name] = self.data[name]
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        SpotifyLogin.shared.logout()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = main.instantiateViewController(identifier: "HomeViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        UIView.transition(with: delegate.window!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            delegate.window?.rootViewController = homeViewController
        }, completion: nil)
    }

}
