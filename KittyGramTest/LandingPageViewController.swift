//
//  LandingPageViewController.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation
import UIKit


//HELLO. Thanks for using KittyKat controller! :D
//you need to get an apiKey @ http://thecatapi.com/api-key-registration.html and save it into Service.swift
//you will also need to create a userId which is a string, and you can get it from an input field, what s not included in this project.

class LandingPageViewController: UIViewController {
    
    var landingImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "landing")
        return img
    }()
    
    var loginButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 30
        btn.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        return btn
    }()
    
    var spinner: UIActivityIndicatorView = {
        let spin = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        spin.translatesAutoresizingMaskIntoConstraints = false
        return spin
    }()

    func loginButtonTouched() {
        
        spinner.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.spinner.stopAnimating()
            let user_id = "" //here you an implement a user_id
            let tabBarVC = TabBarViewController(userId: user_id)
            let nav = NavigationController(rootViewController: tabBarVC)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    func setupViews(){
        self.navigationController?.isNavigationBarHidden = true
        
        //landingImage x,y,w,h
        if !landingImage.isDescendant(of: self.view) { self.view.addSubview(landingImage) }
        landingImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        landingImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        landingImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        landingImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        //loginButton x,y,w,y
        if !loginButton.isDescendant(of: self.view) { self.view.addSubview(loginButton) }
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -90).isActive = true
        loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 70).isActive = true
        loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -70).isActive = true
    
        //spinner x,y,w,h
        if !spinner.isDescendant(of: self.loginButton) { self.loginButton.addSubview(spinner) }
        spinner.rightAnchor.constraint(equalTo: self.loginButton.rightAnchor, constant: -16).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.loginButton.centerYAnchor).isActive = true
        spinner.heightAnchor.constraint(equalTo: self.loginButton.heightAnchor, multiplier: 0.35).isActive = true
        spinner.widthAnchor.constraint(equalTo: self.loginButton.heightAnchor, multiplier: 0.35).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}
