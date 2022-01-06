//
//  AnalyzingViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit

class AnalyzingViewController: UIViewController {
    @IBOutlet weak var analyzingBg: UIImageView!
    let jade1_40 = UIColor(named: "Jade1")!.withAlphaComponent(0.4).cgColor
    let rose1 = UIColor(named: "Rose1")!.cgColor
    var accessToken = String()
    var data = Dictionary<String, Any>()
    // var data = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Screen does load?")
        analyzingBg.applyGradient(colors: [jade1_40, rose1], stops: [0.0, 0.9])
        self.fetchData(name: "top-artists", endpoint: "/me/top/artists?limit=3")

        // Do any additional setup after loading the view.
    }
    
    func fetchData(name: String, endpoint: String) {
        let baseUrl = "https://api.spotify.com/v1"
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
                self.data[name] = dataDictionary["items"] as! Array<Dictionary<String, Any>>
                self.performSegue(withIdentifier: "showCategory", sender: self)
            }
            // let topArtists = self.data["top-artists"] as! Array<Dictionary<String, Any>>
            // print(topArtists[0]["name"] as! String)
        }
        task.resume()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let viewController = segue.destination as! CategoryViewController
        viewController.data = self.data
    }

}
