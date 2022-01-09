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
        self.modalPresentationStyle = .fullScreen
        
        self.loginBg.applyGradient(colors: [byzantine0_30, steelBlue0], stops: [0.0, 0.8])
        
        let button = SpotifyLoginButton(viewController: self, scopes: [.userReadPrivate, .userReadEmail, .userReadTop])
        button.applyShadow()
        self.view.addSubview(button)
        button.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height-150)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: .SpotifyLoginSuccessful, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.modalPresentationStyle = .fullScreen
        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
            if error != nil {
                // User is not logged in
            } else {
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            }
        }
    }
    
    @objc func loginSuccessful() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let analyzingViewController = main.instantiateViewController(identifier: "AnalyzingViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        UIView.transition(with: delegate.window!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromRight, animations: {
            delegate.window?.rootViewController = analyzingViewController
        }, completion: nil)
    }
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
