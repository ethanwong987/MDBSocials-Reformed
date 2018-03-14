//
//  FeedVC-CollectionView.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/14/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//
import UIKit
import ChameleonFramework

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numPosts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! FeedViewCell
        let currentPost = posts[indexPath.row]
        
        cell.setupEventText()
        cell.setUpNumInterested()
        cell.setupEventPoster()
        //cell.setupActivityIndidicator()
        cell.setupEventImage()
        cell.createDateText()
        cell.createTimeText()
        cell.postTitleName = currentPost.postTitle
        cell.posterTextName = currentPost.poster
        cell.numInterestedName = String(describing: currentPost.numInterested.count)
        cell.dateTextName = currentPost.date
        cell.timeTextName = currentPost.time
        cell.image = currentPost.image
        cell.currUser = currentUser
        cell.currPost = currentPost
        
        cell.layer.borderWidth = 1.0
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 10
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        cell.awakeFromNib()
        return cell
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: postView.bounds.width - 20, height: postView.bounds.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: postView.bounds.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currPost = posts[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: self)
    }
}

