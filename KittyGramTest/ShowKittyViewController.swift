//
//  ShowKittyViewController.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation
import UIKit

class ShowKittyViewController: UIViewController {
    
    var kitty: Kitty?
    
    var kittyImage: CatchedImageView = {
        let img = CatchedImageView()
        return img
    }()

    var imgURLLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func loadKitty() {
        if let id = kitty?.id {
            self.title = id
        }
        if let url = kitty?.url {
            kittyImage.loadImageFromURL(url)
            imgURLLabel.text = url
        }
    }

    func setupViews(){
        self.view.backgroundColor = .white
        
        //kittyImage  x,y,w,h
        if !kittyImage.isDescendant(of: self.view) { self.view.addSubview(kittyImage) }
        kittyImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        kittyImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        kittyImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        kittyImage.heightAnchor.constraint(equalTo: kittyImage.widthAnchor).isActive = true
        
        //likeButton  x,y,w,h
        if !imgURLLabel.isDescendant(of: self.view) { self.view.addSubview(imgURLLabel) }
        imgURLLabel.topAnchor.constraint(equalTo: self.kittyImage.bottomAnchor).isActive = true
        imgURLLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        imgURLLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        imgURLLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    public init(kitty: Kitty?) {
        self.kitty = kitty
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadKitty()
    }
}
