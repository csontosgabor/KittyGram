//
//  KittyCollectionViewCell.swift
//  KittyGramTest
//
//  Created by Gabor on 10/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation
import UIKit

protocol KittyCellDelegate: class {
    func likeButtonPressed(_ catId: String, isLiked: Bool)
}

class KittyCollectionViewCell : UICollectionViewCell {
    
    var kitty: Kitty? {
        didSet {
            if let liked = kitty?.isLiked {
                likeButton.isSelected = liked
            }
            if let url = kitty?.url {
                if let cellIdentifier = self.reuseIdentifier { //spinner only on kCell!
                    if cellIdentifier == "kCell" { self.spinner.startAnimating() } }
                kittyImage.loadImageFromURL(url, completion: {
                    self.spinner.stopAnimating()
                })
            }
            setupViews()
        }
    }
    
    var delegate: KittyCellDelegate?
    
    lazy var kittyImage: CatchedImageView = {
        let img = CatchedImageView()
        return img
    }()

    lazy var likeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let selected: UIImage = UIImage(named: "loved")!
        let deSelected: UIImage = UIImage(named: "love")!
        btn.setImage(selected, for: .selected)
        btn.setImage(deSelected, for: .normal)
        btn.addTarget(self, action: #selector(likeButtonTouched), for: .touchUpInside)
        btn.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func likeButtonTouched() {
        guard let id = kitty?.id else { return }
        self.delegate?.likeButtonPressed(id, isLiked: !likeButton.isSelected)
        self.likeButton.isSelected = !self.likeButton.isSelected
    }
    
    func setupViews(){
        //kittyImage  x,y,w,h
        if !kittyImage.isDescendant(of: self) { self.addSubview(kittyImage) }
        kittyImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        kittyImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        kittyImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
       
        //likeButton  x,y,w,h
        if !likeButton.isDescendant(of: self) { self.addSubview(likeButton) }
        
        guard let cellIdentifier = self.reuseIdentifier else { return }
        //setup cell properties based on cellIdentifier
        if cellIdentifier == "kCell" { // setup remaining constrains
            kittyImage.heightAnchor.constraint(equalTo: kittyImage.widthAnchor).isActive = true
            
            likeButton.topAnchor.constraint(equalTo: self.kittyImage.bottomAnchor).isActive = true
            likeButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            likeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        if cellIdentifier == "fCell" { // setup remaining constrains
            kittyImage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            
            likeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
            likeButton.widthAnchor.constraint(equalTo: self.likeButton.heightAnchor).isActive = true
            likeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
            likeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
            likeButton.isSelected = true// fCell loading only the liked pictures, so this value is true
        }
        //spinner x,y,w,h
        if !spinner.isDescendant(of: self) { self.addSubview(spinner) }
        spinner.heightAnchor.constraint(equalTo: self.kittyImage.heightAnchor).isActive = true
        spinner.widthAnchor.constraint(equalTo: self.kittyImage.widthAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.kittyImage.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.kittyImage.centerYAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor(white: 0.99, alpha: 1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
