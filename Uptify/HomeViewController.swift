//
//  HomeViewController.swift
//  Uptify
//
//  Created by Ngoc Hoang on 29/12/2021.
//

import UIKit
import SpotifyLogin

class HomeViewController: UIViewController {
    @IBOutlet weak var loginBg: UIImageView!
    let byzantine0_30 = UIColor(named: "Byzantine0")!.withAlphaComponent(0.3).cgColor
    let steelBlue0 = UIColor(named: "SteelBlue0")!.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBg.applyGradient(colors: [byzantine0_30, steelBlue0], stops: [0.0, 0.8])
        
        let button = SpotifyLoginButton(viewController: self, scopes: [.userReadPrivate, .userReadEmail, .userReadTop])
        button.applyShadow()
        self.view.addSubview(button)
        button.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height-150)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: .SpotifyLoginSuccessful, object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
            if error != nil {
                // User is not logged in, show log in flow.
            } else {
                let viewController = segue.destination as! AnalyzingViewController
                viewController.accessToken = accessToken!
            }
        }
    }
    
    @objc func loginSuccessful() {
        print("Performing segue")
        print("Logged in successfully")
        performSegue(withIdentifier: "loginSuccess", sender: self)
        /*
        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
            if error != nil {
                // User is not logged in, show log in flow.
            } else {
                let baseUrl = "https://api.spotify.com/v1"
                // let endpoint = "/me/top/tracks?time_range=short_term"
                let endpoint = "/tracks/6rrKbzJGGDlSZgLphopS49"
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
        */
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

extension UIImageView
{
    func applyGradient(colors: [CGColor], stops: [NSNumber]? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = stops
        gradientLayer.frame = self.bounds
        // gradientLayer.cornerRadius = 12
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIButton
{
    func applyShadow(radius: CGFloat? = 15) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = radius!
    }
    
    func applyGradient(colors: [CGColor], corner: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = corner
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
