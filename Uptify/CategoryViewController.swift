//
//  CategoryViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryBg: UIImageView!
    @IBOutlet weak var topArtists: UIButton!
    @IBOutlet weak var topTracks: UIButton!
    
    let steelBlue0_40 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.4).cgColor
    let mauve0 = UIColor(named: "Mauve0")!.cgColor
    
    let steelBlue0_75 = UIColor(named: "SteelBlue0")!.withAlphaComponent(0.75).cgColor
    let jade0_75 = UIColor(named: "Jade0")!.withAlphaComponent(0.75).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryBg.applyGradient(colors: [steelBlue0_40, mauve0], stops: [0.0, 0.8])
        topArtists.layer.cornerRadius = 30
        topArtists.applyGradient(colors: [steelBlue0_75, jade0_75], corner: 30)
        topArtists.applyShadow()
        topTracks.layer.cornerRadius = 30
        topTracks.applyGradient(colors: [steelBlue0_75, jade0_75], corner: 30)
        

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
