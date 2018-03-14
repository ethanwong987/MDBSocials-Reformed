//
//  FeedVC-SetUpUI.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/14/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import ChameleonFramework

extension FeedVC {
    func setUpNavBar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Event", style: .plain, target: self, action: #selector(toNewSocial))
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.feedBackGroundColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.feedBackGroundColor
        self.navigationController?.navigationBar.barTintColor = Constants.cellColor
        self.title = "My Feed"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func setUpCollectionView(){
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let cvLayout = UICollectionViewFlowLayout()
        postView = UICollectionView(frame: frame, collectionViewLayout: cvLayout)
        postView.delegate = self
        postView.dataSource = self
        postView.register(FeedViewCell.self, forCellWithReuseIdentifier: "post")
        postView.backgroundColor = Constants.feedBackGroundColor
        view.addSubview(postView)
    }
}
