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
//make scrollview!
class DetailVC: UIViewController {
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
    
    var modalView: AKModalView!
    var detailView: DetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpEventPic()
        setUpEventPoster()
        setUpEventTitle()
        setUpEventDescription()
        setUpInterestedButton()
        setUpWhoInterestedButton()
        setUpInterestCount()
    }
    
    func setUpUI(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        view.backgroundColor = Constants.cellColor
        self.navigationController?.navigationBar.tintColor = Constants.feedBackGroundColor
        
        viewTitle = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.12, width: vfw-30, height: vfh*0.1))
        viewTitle.text = currPost.date! + "  " + currPost.time!
        viewTitle.textColor = Constants.feedBackGroundColor
        viewTitle.font = UIFont(name:"SFUIText-Medium", size: 24)
        
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.58, width: vfw-30, height: vfh*0.4))
        borderBox.backgroundColor = Constants.feedBackGroundColor?.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        view.addSubview(borderBox)
        view.addSubview(viewTitle)
    }
    
    func setUpEventPic(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventPic = UIImageView(frame: CGRect(x: vfw*0.04, y: vfh*0.2, width: vfw-30, height: vfh*0.35))
        if currPost.image == nil {
            eventPic.image = UIImage(named:"default-image")
        } else {
            eventPic.image = currPost.image
        }
        eventPic.layer.borderWidth = 1
        eventPic.layer.masksToBounds = false
        eventPic.layer.borderColor = UIColor.black.cgColor
        eventPic.layer.cornerRadius = 10
        eventPic.clipsToBounds = true
        view.addSubview(eventPic)
    }
    
    func setUpEventPoster(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventPosters = UILabel(frame: CGRect(x: vfw*0.08, y: vfh * 0.9, width: vfw-50, height: vfh*0.1))
        eventPosters.text = "Created By: \(currPost.poster!)"
        eventPosters.textColor = .black
        view.addSubview(eventPosters)
    }
    
    func setUpEventTitle(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventTitle = UILabel(frame: CGRect(x: vfw*0.08, y: vfh * 0.58, width: vfw-50, height: vfh*0.1))
        eventTitle.font = UIFont(name: "SFUIText-Medium", size: 40)
        eventTitle.text = currPost.postTitle
        eventTitle.textColor = .white
        view.addSubview(eventTitle)
    }
    
    func setUpEventDescription(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        textBox = UILabel(frame: CGRect(x: vfw*0.08, y: vfh*0.68, width: vfw-60, height: vfh*0.16))
        textBox.backgroundColor = UIColor.white
        textBox.layer.masksToBounds = true
        textBox.layer.cornerRadius = 10
        view.addSubview(textBox)
        
        desc = UITextView(frame: CGRect(x: vfw*0.12, y: vfh*0.68, width: vfw-90, height: vfw*0.18))
        desc.text = currPost.text
        desc.font = UIFont(name: "SFUIText-Medium", size: 18)
        view.addSubview(desc)
    }
    
    func setUpWhoInterestedButton() {
        let sfw = view.frame.width
        let sfh = view.frame.height
        whoInterestedButton = UIButton(frame: CGRect(x: sfw * 0.9, y: sfh * 0.9, width: sfw * 0.08, height: sfh * 0.08))
        whoInterestedButton.setBackgroundImage(UIImage(named:"whiteperson"), for: .normal)
        whoInterestedButton.addTarget(self, action: #selector(whoInterestedView), for: .touchUpInside)
        view.addSubview(whoInterestedButton)
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
        let interestText = UILabel(frame: CGRect(x: vfw*0.68, y: vfh * 0.92, width: vfw*1.2, height: vfh*0.1))
        interestText.text = "Interested"
        interestText.font = UIFont(name:"SFUIText-Medium", size: 15)
        interestText.backgroundColor = .clear
        interestText.textColor = .black
        view.addSubview(interestText)
        interestLabel = UILabel(frame: CGRect(x: vfw*0.76, y: vfh*0.82, width: vfw*0.1, height: vfh*0.16))
        interestLabel.text = String(describing: currPost.numInterested.count)
        interestLabel.font = UIFont(name: "SFUIText-Medium", size: 35)
        view.addSubview(interestLabel)
    }
    
    func setUpInterestedButton(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        interestButton = UIButton(frame: CGRect(x: vfw*0.08, y: vfh*0.86, width: vfw*0.5, height: vfh*0.06))
        interestButton.setTitle("I'm Interested!", for: .normal)
        interestButton.setTitleColor(.white, for: .normal)
        interestButton.layer.cornerRadius = 10
        interestButton.clipsToBounds = true
        interestButton.layer.borderColor = UIColor.white.cgColor
        interestButton.layer.borderWidth = 1
        if currPost.numInterested.contains(currUser.id!) {
            interestButton.backgroundColor = .green
        }
        interestButton.addTarget(self, action: #selector(userIsInterested), for: .touchUpInside)
        view.addSubview(interestButton)
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
        } else {
            sender.backgroundColor = .green
            currPost.numInterested.append(currUser.id!)
            let ref = Database.database().reference().child("Posts").child(currPost.id!)
            ref.updateChildValues(["numInterested" : currPost.numInterested])
        }
        interestLabel.text = String(describing: currPost.numInterested.count)
    }
}

extension DetailVC: DetailViewDelegate {
    func dismissDetailView() {
        modalView.dismiss()
    }
}

