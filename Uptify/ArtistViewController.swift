//
//  ArtistViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 07/01/2022.
//

import UIKit

class ArtistViewController: UIViewController {
    var artist = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Name: \(artist["name"] as! String)")
        let genres = artist["genres"] as! [String]
        print("Genres: \(genres.joined(separator: ", "))")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
