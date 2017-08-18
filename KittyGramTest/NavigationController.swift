//
//  NavigationController.swift
//  KittyGramTest
//
//  Created by Gabor on 11/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
   
    
    var topConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !errorLabel.isDescendant(of: self.navigationBar) { self.navigationBar.addSubview(errorLabel) }
        topConstraint = errorLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -20)
        topConstraint?.isActive = true
        errorLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    func showNetworkErrorIndicator(errorMsg: String) {
         if self.errorLabel.isHidden == false { return }//until its finishing
         self.errorLabel.text = errorMsg
         self.errorLabel.isHidden = false
         self.hideStatusBar(-20, duration: 0.5, delay: 0.0)
         UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
             self.topConstraint?.constant = 0
             self.view.layoutIfNeeded()
        }) { (true) in
            self.hideStatusBar(0, duration: 0.5, delay: 2.0)
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseIn, animations: {
                self.topConstraint?.constant = -20
                self.view.layoutIfNeeded()
            }) { (true) in
                self.errorLabel.isHidden = true
            }
        }
    }
    
    func hideStatusBar(_ yOffset:CGFloat, duration: Double, delay: Double) { // -20.0 for example
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as! UIWindow
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: { () -> Void in
            statusBarWindow.frame = CGRect(x: 0, y: yOffset, width: statusBarWindow.frame.size.width, height: statusBarWindow.frame.size.height)
        }, completion: nil)
    }
}
