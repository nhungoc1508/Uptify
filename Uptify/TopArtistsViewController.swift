//
//  TopArtistsViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit

class TopArtistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topartistsBg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        topartistsBg.applyGradient(colors: [jade0_40, steelBlue0], stops: [0.4, 0.95])

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
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
        return cell
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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