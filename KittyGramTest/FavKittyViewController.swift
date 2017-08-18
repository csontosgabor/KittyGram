//
//  FavKittyViewController.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation
import UIKit

class FavKittyViewController: UICollectionViewController {

    var userId: String?
    var refresher:UIRefreshControl!
    var dataSource:KittyDatasource?
    
    lazy var placeHolder: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "nofav")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isHidden = true
        return img
    }()
    
    func fetchLikedKitties() {
        placeHolder.isHidden = true
        guard let userId = self.userId else { return }
        Service.sharedInstance.fetchLikedKitties(userId: userId, completionHandler: { (kittyDatasource, err) in
            if err != nil {
                self.dataSource = try! KittyDatasource(objects: [Dictionary<String,String>]())//creating a new datasource
                self.dataSource?.loadFetchedKitties(isFromFeed:false)//loading the saved datasourcefiles
                self.refreshCollView()
            } else {
                guard let dataSource = kittyDatasource else { return }
                self.dataSource = dataSource
                if self.dataSource?.numberOfItems() != 0 {
                self.dataSource?.storeFetchedKitties(isFromFeed: false)//storing the fetched values
                self.refreshCollView()
                }
            }
        })
    }
    
    func setPlaceholderIfNeeded() {
        if self.dataSource?.numberOfItems() == 0 {
                self.placeHolder.isHidden = false
        } else {self.placeHolder.isHidden = true}
    }
    
    func setupViews() {
        //collectionView
        self.collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.register(KittyCollectionViewCell.self, forCellWithReuseIdentifier: "fCell")
        
        //refesher
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.gray
        self.refresher.addTarget(self, action: #selector(fetchLikedKitties), for: .valueChanged)
        self.collectionView?.addSubview(refresher)
        
        //placeHolder x,y,w,h
        if !placeHolder.isDescendant(of: collectionView!){ collectionView?.addSubview(placeHolder) }
        placeHolder.centerYAnchor.constraint(equalTo: (collectionView?.centerYAnchor)!, constant: -50).isActive = true
        placeHolder.centerXAnchor.constraint(equalTo: (collectionView?.centerXAnchor)!).isActive = true
        placeHolder.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        placeHolder.heightAnchor.constraint(equalTo: placeHolder.widthAnchor).isActive = true
        
        //title setup
        self.tabBarController?.navigationItem.title = "😺 + ❤️"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLikedKitties()
    }
    
    public init(userId: String) {
        self.userId = userId
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -KittyCellDelegate
extension FavKittyViewController: KittyCellDelegate {
    
    func likeButtonPressed(_ catId: String, isLiked: Bool) {
        //set like or not
        guard let userId = self.userId else { return }
        //saving the original dataSource, if the unlike request is failing to network connection
        let originalKitties = self.dataSource?.kitties
        //removing instantly the disliked cell avoiding another user interaction with like button
        self.dataSource?.removeLikedCat(catId)
        self.dataSource?.storeFetchedKitties(isFromFeed: false)//storing the fetched values
        refreshCollView()//refreshing collview
        Service.sharedInstance.likeKitty(isLiked, userId: userId, catId: catId, completionHandler: {
            success in
                if success {
                    // Post notification sending to change the value in KittyViewController cell if needed
                    let dislikedId:[String: String] = ["id": catId]
                    let notificationName = Notification.Name("catDislikedNotification")
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: dislikedId)
                } else {//unsucessfully liked, set back the original datasource to try disliking again
                    self.dataSource?.kitties = originalKitties//push back the original kitties!
                    self.dataSource?.storeFetchedKitties(isFromFeed: false)//storing the fetched values
                    self.refreshCollView()
                    //show network connection error
                    self.showErrWithMsg(errorMsg: "Network connection lost")
                }
        })
    }
    
    func refreshCollView(){
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            if self.refresher.isRefreshing { self.refresher.endRefreshing() }
            self.setPlaceholderIfNeeded()
        }
    }
}

//MARK: -UICollectionViewDelegate
extension FavKittyViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.numberOfSections() ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItems() ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fCell", for: indexPath) as! KittyCollectionViewCell
        cell.delegate = self
        cell.kitty = self.dataSource?.kittyAtIndex(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 3  - 1.5
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let kitty = self.dataSource?.kittyAtIndex(indexPath.row)
        let showKittyVC = ShowKittyViewController(kitty: kitty)
        self.tabBarController?.navigationController?.pushViewController(showKittyVC, animated: true)
    }
}
