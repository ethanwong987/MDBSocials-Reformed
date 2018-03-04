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
//make scrollview!
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
    var containerView = UIView()
    
    var modalView: AKModalView!
    var detailView: DetailView!
    var delegate: EventVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setUpUI()
        setUpEventPic()
        setUpEventPoster()
        setUpEventTitle()
        setUpEventDescription()
        setUpInterestedButton()
        setUpWhoInterestedButton()
        setUpInterestCount()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x:0, y:0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
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
    
    func setUpScrollView() {
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        containerView = UIView()
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
    }
    
    func setUpUI(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        view.backgroundColor = Constants.cellColor
        self.navigationController?.navigationBar.tintColor = Constants.feedBackGroundColor
        
        viewTitle = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.07, width: vfw-30, height: vfh*0.1))
        viewTitle.text = currPost.date! + "  " + currPost.time!
        viewTitle.textColor = Constants.feedBackGroundColor
        viewTitle.font = UIFont(name:"AppleSDGothicNeo-Medium ", size: 24)
        
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.52, width: vfw-30, height: vfh*0.27))
        borderBox.backgroundColor = Constants.feedBackGroundColor?.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        borderBox.layer.borderWidth = 1
        borderBox.layer.borderColor = UIColor.white.cgColor
        containerView.addSubview(borderBox)
        containerView.addSubview(viewTitle)
    }
    
    func setUpEventPic(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventPic = UIImageView(frame: CGRect(x: vfw*0.04, y: vfh*0.15, width: vfw * 0.67, height: vfh*0.35))
        if currPost.image == nil {
            eventPic.image = UIImage(named:"default-image")
        } else {
            eventPic.image = currPost.image
        }
        eventPic.layer.borderWidth = 1
        eventPic.layer.masksToBounds = false
        eventPic.layer.borderColor = UIColor.white.cgColor
        eventPic.layer.cornerRadius = 10
        eventPic.clipsToBounds = true
        containerView.addSubview(eventPic)
    }
    
    func setUpEventPoster(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventPosters = UILabel(frame: CGRect(x: vfw*0.08, y: vfh * 0.7, width: vfw-50, height: vfh*0.1))
        eventPosters.text = "Created By: \(currPost.poster!)"
        eventPosters.textColor = .black
        containerView.addSubview(eventPosters)
    }
    
    func setUpEventTitle(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventTitle = UILabel(frame: CGRect(x: vfw*0.08, y: vfh * 0.52, width: vfw-50, height: vfh*0.1))
        eventTitle.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 24)
        eventTitle.text = currPost.postTitle
        eventTitle.textColor = .white
        containerView.addSubview(eventTitle)
    }
    
    func setUpEventDescription(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        textBox = UILabel(frame: CGRect(x: vfw*0.08, y: vfh*0.6, width: vfw-60, height: vfh*0.12))
        textBox.backgroundColor = UIColor.white
        textBox.layer.masksToBounds = true
        textBox.layer.cornerRadius = 10
        containerView.addSubview(textBox)
        
        desc = UITextView(frame: CGRect(x: vfw*0.12, y: vfh*0.6, width: vfw-90, height: vfw*0.18))
        desc.text = currPost.text
        desc.font = UIFont(name: "HelveticaNeue", size: 18)
        containerView.addSubview(desc)
    }
    
    func setUpWhoInterestedButton() {
        let sfw = view.frame.width
        let sfh = view.frame.height
        whoInterestedButton = UIButton(frame: CGRect(x: sfw * 0.75, y: sfh * 0.15, width: sfw * 0.21, height: sfh * 0.35))
        whoInterestedButton.backgroundColor = Constants.feedBackGroundColor
        whoInterestedButton.layer.cornerRadius = 10
        whoInterestedButton.layer.borderColor = UIColor.white.cgColor
        whoInterestedButton.layer.borderWidth = 1
        whoInterestedButton.setImage(UIImage(named:"whiteperson"), for: .normal)
        whoInterestedButton.addTarget(self, action: #selector(whoInterestedView), for: .touchUpInside)
        containerView.addSubview(whoInterestedButton)
    }
    
    @objc func whoInterestedView() {
        let navBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        detailView = DetailView(frame: CGRect(x: 15, y: 70, width: view.frame.width - 30, height: view.frame.height - 100))
        detailView.currPost = currPost
        detailView.currUser = currUser
        detailView.delegate = self
        modalView = AKModalView(view: detailView)
        modalView.dismissAnimation = .FadeOut
        navigationController?.view.addSubview(modalView)
        modalView.show()
    }
    
    func setUpInterestCount() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        interestLabel = UILabel(frame: CGRect(x: vfw*0.82, y: vfh*0.15, width: vfw*0.1, height: vfh*0.16))
        interestLabel.textColor = .white
        interestLabel.text = String(describing: currPost.numInterested.count)
        interestLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 50)
        containerView.addSubview(interestLabel)
    }
    
    func setUpInterestedButton(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        interestButton = UIButton(frame: CGRect(x: vfw*0.08, y: vfh*0.72, width: vfw*0.5, height: vfh*0.06))
        interestButton.setTitle("I'm Interested!", for: .normal)
        interestButton.setTitleColor(.white, for: .normal)
        interestButton.layer.cornerRadius = 10
        interestButton.clipsToBounds = true
        interestButton.layer.borderColor = UIColor.white.cgColor
        interestButton.layer.borderWidth = 1
        
        if currPost.posterId == currUser.id {
            interestButton.addTarget(self, action: #selector(createAlert), for: .touchUpInside)
        } else {
            if currPost.numInterested.contains(currUser.id!) {
                interestButton.backgroundColor = .green
            }
            interestButton.addTarget(self, action: #selector(userIsInterested), for: .touchUpInside)
            containerView.addSubview(interestButton)
        }
    }
    
    @objc func createAlert(_ sender: UIButton) {
        print("hi")
        sender.backgroundColor = .green
    }
    
    @objc func userIsInterested(_ sender: UIButton) {
        if sender.backgroundColor == .green {
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
            sender.backgroundColor = .green
            currPost.numInterested.append(currUser.id!)
            currUser.eventIds.append(currPost.id!)
            let postRef = Database.database().reference().child("Posts").child(currPost.id!)
            let userRef =
                Database.database().reference().child("Users").child(currUser.id!)
            postRef.updateChildValues(["numInterested" : currPost.numInterested])
            userRef.updateChildValues(["eventIds" : currUser.eventIds])
        
        }
            
        interestLabel.text = String(describing: currPost.numInterested.count)

}
}

extension DetailVC: DetailViewDelegate {
    func dismissDetailView() {
        modalView.dismiss()
    }
}

