//
//  TabBarViewController.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    var userId: String?
    
    func setupTabBars(){
        guard let userId = self.userId  else { return }
        
        let navKitty = UINavigationController(rootViewController: KittyViewController(userId: userId))
        navKitty.tabBarItem.image = UIImage(named: "cat")
        navKitty.title = "Kitties"
        
        let navLiked = UINavigationController(rootViewController: FavKittyViewController(userId: userId))
        navLiked.tabBarItem.image = UIImage(named: "love")
        navLiked.title = "Loved"
        
        viewControllers = [navKitty,navLiked]
        
        let logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutBtn
    }
    
    func logout() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBars()
    }
    
    public init(userId: String) {
        //passed data from previous controller
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIViewController {
    
    func showErrWithMsg(errorMsg: String) {
        if let nav = self.parent?.parent?.navigationController as? NavigationController {
             nav.showNetworkErrorIndicator(errorMsg: errorMsg)
        }
    }
}

