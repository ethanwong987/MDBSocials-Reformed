//
//  FeedVC.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved./Users/ethanwong/MDBiOS/Training Projects/MDBSocials/MDBSocials/Controller/FeedVC.swift
//

import UIKit
import Firebase
import FirebaseAuth
import ChameleonFramework
import ObjectMapper
import SwiftyJSON

class EventVC: UIViewController {
    var posts: [Post] = []
    var myPosts: [Post] = []
    var postView: UICollectionView!
    var currentUser: Users?
    var currPost: Post!
    var numPosts: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(EventVC.reload), name: NSNotification.Name(rawValue: notifKey), object: nil)
        self.setUpNavBar()
        self.changeNavBar()
        self.setUpCollectionView()
        RESTAPIClient.getCurrentUser().then {user in
            self.currentUser = user
            } .then { _ in
                DispatchQueue.main.async {
                    self.changePosts()
                    self.getPosts()
                    self.changePosts()
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postView.reloadData()
    }
    
    @objc func reload() {
        log.info("reloading")
        self.changePosts()
        self.getPosts()
        self.changePosts()
    }
    
    func sortDate() {
        self.posts.sort { (post1, post2) -> Bool in
            return post1.date! > post2.date!
        }
    }

    func filterArray(postArray: [Post]) {
        let feed = (self.tabBarController!.viewControllers![0] as! UINavigationController).viewControllers[0] as! FeedVC
        self.posts.removeAll()
        let id = currentUser?.id
        for post in feed.posts {
            if post.posterId == id || post.numInterested.contains(id!) {
                self.posts.append(post)
                self.numPosts += 1
            } //numPosts -=1 delegate when click button //CAN USE UJNOTIFICATION CENTER FOR INTERESTED BUTTON???
            
            
        }
    }
    
    func getPosts() {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            if var dict = snapshot.value as? [String: Any] {
                dict["id"] = snapshot.key
                let newPost = Post(JSON: dict)
                if self.posts.map({$0.id}).contains(where: {$0 == newPost?.id}) == false {
                    self.posts.insert(newPost!, at: 0)
                    if self.currentUser?.id == newPost?.posterId {
                        self.myPosts.insert(newPost!, at: 0)
                    }
                    Utils.getImage(withUrl: (newPost?.imageUrl)!).then { img in
                        newPost?.image = img
                        } .then {_ in
                            DispatchQueue.main.async {
                                self.postView.reloadData()
                            }
                    }
                }
                self.filterArray(postArray: self.posts)
                self.sortDate()
                //self.sortTime()
            }
        })
    }
    
    func changePosts() {
        if posts.count != numPosts {
            self.postView.reloadData()
            numPosts = posts.count
        }
    }
    
    @objc func toNewSocial() {
        performSegue(withIdentifier: "toNewSocial", sender: self)
    }
    
    @objc func signOut() {
        UserAuth.logOut()
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let detailVC = segue.destination as! DetailVC
            detailVC.currPost = currPost
            detailVC.currUser = currentUser!
            detailVC.delegate = self
        }
    }
}


