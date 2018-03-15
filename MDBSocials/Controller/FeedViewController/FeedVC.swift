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

class FeedVC: UIViewController {
    var posts: [Post] = []
    var myPosts: [Post] = []
    var auth = Auth.auth()
    var postView: UICollectionView!
    var postsRef: DatabaseReference = Database.database().reference().child("Posts")
    var storage: StorageReference = Storage.storage().reference()
    var currentUser: Users?
    var currPost: Post!
    var postUser: Users?
    var numPosts: Int = 0
    var navBar: UINavigationBar!
    var delegate: EventVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RESTAPIClient.getCurrentUser().then {user in
            self.currentUser = user
            } .then { _ in
                DispatchQueue.main.async {
                    self.setUpNavBar()
                    self.setUpCollectionView()
                    self.getPosts()
                    self.changePosts()
        
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let events = (self.tabBarController!.viewControllers![1] as! UINavigationController).viewControllers[0] as! EventVC
        events.posts.removeAll()
        let id = currentUser?.id //doesn't work correctly cuz async
        for post in self.posts {
            if post.posterId == id || post.numInterested.contains(id!) {
                events.posts.append(post)
                events.numPosts += 1
            }
        }
    }
    
    func sortDate() {
        self.posts.sort { (post1, post2) -> Bool in
            return post1.date! > post2.date!
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
                    self.numPosts = self.numPosts + 1
                    Utils.getImage(withUrl: (newPost?.imageUrl)!).then { img in
                        newPost?.image = img
                        } .then {_ in
                            DispatchQueue.main.async {
                                self.postView.reloadData()
                            }
                    }
                }
                self.sortDate()
            }
        })
    }
    
    func changePosts() {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childChanged, with: { (snapshot) in
            self.postView.reloadData()
        })
    }
    @objc func toNewSocial() {
        performSegue(withIdentifier: "toNewSocial", sender: self)
    }
    
    @objc func signOut() {
        log.info("\(currentUser!) has signed out.")
        UserAuth.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let detailVC = segue.destination as! DetailVC
            detailVC.currPost = currPost
            detailVC.currUser = currentUser!
        }
    }
}
