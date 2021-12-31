//
//  HomeViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 29/12/2021.
//

import UIKit
import SpotifyLogin

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = SpotifyLoginButton(viewController: self, scopes: [.userReadPrivate, .userReadEmail, .userFollowRead])
        self.view.addSubview(button)
        button.center = self.view.center
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: .SpotifyLoginSuccessful, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func loginSuccessful() {
        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
            if error != nil {
                // User is not logged in, show log in flow.
            } else {
                let baseUrl = "https://api.spotify.com/v1"
                let endpoint = "/me/following?type=artist"
                let url = URL(string: (baseUrl + endpoint))
                var request = URLRequest(url: url!)
                request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        print(type(of: data))
                        print(String(decoding: data, as: UTF8.self))
                    }
                }
                task.resume()
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
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
