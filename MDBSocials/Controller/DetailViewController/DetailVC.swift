//
//  DetailVC.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import PromiseKit
import CoreGraphics
import CoreLocation
import MapKit
import LyftSDK

let notifKey = "interestButton.pressed"
class DetailVC: UIViewController, UIScrollViewDelegate {
    var eventPic: UIImageView!
    var eventPosters: UILabel!
    var eventTitle: UILabel!
    var interestButton: UIButton!
    var interestLabel: UILabel!
    var borderBox: UILabel!
    var textBox: UILabel!
    var desc: UITextView!
    var viewTitle: UILabel!
    var isSelected = false
    var currPost: Post!
    var currUser: Users!
    var picker = UIImagePickerController()
    var whoInterestedButton: UIButton!
    
    var scrollView: UIScrollView!
    var delegate: EventVC!
    var feedDelegate: FeedVC!
    var modalView: AKModalView!
    var detailView: DetailView!
    var mapView: MKMapView!
    
    var appleButton: UIButton!
    var lyftLabel: UIButton!
    //why no lyftButton
    
    
    var currentLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        setUpUI()
        setUpEventPic()
        setUpEventTitle()
        setUpEventDescription()
        setUpInterestedButton()
        setUpMap()
        setUpAppleMapsButton()
        setUpWhoInterestedButton()
        setUpInterestCount()
        setUpLyftLabel()
        setUpScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addPointer()
        self.queryLyft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func createAlert(_ sender: UIButton) {
        sender.backgroundColor = Constants.MDBBlue
    }
    
    @objc func userIsInterested(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifKey), object: self)
        if sender.backgroundColor == Constants.MDBBlue {
            sender.backgroundColor = .clear
            var index = 0
            for id in currPost.numInterested {
                if currUser.id == id {
                    currPost.numInterested.remove(at: index)
                    let postRef = Database.database().reference().child("Posts").child(currPost.id!)
                    postRef.updateChildValues(["numInterested" : currPost.numInterested])

                } else {
                    index += 1
                }
            }
            var index1 = 0
            for eventId in currUser.eventIds {
                if currPost.id == eventId {
                    currUser.eventIds.remove(at: index1)
                    let postRef = Database.database().reference().child("Users").child(currUser.id!)
                    postRef.updateChildValues(["eventIds" : currUser.eventIds])
                } else {
                    index1 += 1
                }
            }
        } else {
            sender.backgroundColor = Constants.MDBBlue
            currPost.numInterested.append(currUser.id!)
            currUser.eventIds.append(currPost.id!)
            let postRef = Database.database().reference().child("Posts").child(currPost.id!)
            let userRef =
                Database.database().reference().child("Users").child(currUser.id!)
            postRef.updateChildValues(["numInterested" : currPost.numInterested])
            userRef.updateChildValues(["eventIds" : currUser.eventIds])
        }
        interestLabel.text = String(describing: currPost.numInterested.count)
        //delegate.numPosts += 1
        //print(delegate.numPosts)
        //delegate.postView.reloadData()

//        delegate.posts.removeAll()
//        let id = currUser.id
//        for post in delegate.posts {
//            if post.posterId == id || post.numInterested.contains(id!) {
//                delegate.posts.append(post)
//                }
//            }
    }
}

extension DetailVC: DetailViewDelegate {
    func dismissDetailView() {
        modalView.dismiss()
    }
}

