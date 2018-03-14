//
//  DetailView.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/2/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

//
//  MenuItemDetailView.swift
//  MenuApp
//
//  Created by Akkshay Khoslaa on 2/19/18.
//  Copyright © 2018 Akkshay Khoslaa. All rights reserved.
//

import UIKit
import ChameleonFramework
import PromiseKit

protocol DetailViewDelegate {
    func dismissDetailView()
}

class DetailView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var interestedButton: UIButton!
    var delegate: DetailViewDelegate?
    var currPost: Post!
    var currUser: Users!
    var postUser: Users!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layer.cornerRadius = 3
        clipsToBounds = true
        backgroundColor = .white
        interestedButton = UIButton(frame: CGRect(x: 0, y: frame.height - 50, width: frame.width, height: 50))
        interestedButton.backgroundColor = Constants.feedBackGroundColor
        interestedButton.setTitle("INTERESTED", for: .normal)
        interestedButton.setTitleColor(Constants.cellColor, for: .normal)
        interestedButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 14)
        addSubview(interestedButton)
        
    }
    
    func setup() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        tableView.layer.backgroundColor = UIColor.black.cgColor
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currPost.numInterested.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height/8)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let uid = currPost.numInterested[indexPath.row]
        firstly {
            return FirebaseClient.fetchUser(id: uid)
            }.then { user -> Void in
                //print("user is")
                //print(user.toJSON())
                self.postUser = user
                //print(self.postUser.toJSON())
            } .then { _ in
                DispatchQueue.main.async {
                    cell.textLabel?.text = self.postUser.name
                    Utils.getImage(withUrl: self.postUser.imageUrl!).then { img in
                        cell.imageView?.image = img
                    }
                    cell.textLabel?.font = UIFont(name: "SFUIText-Medium", size: 20)
                    cell.textLabel?.textAlignment = .center
                    cell.imageView?.frame = CGRect(x: 10, y: 10, width: cell.frame.height * 0.01, height: cell.frame.height * 0.01)
                    cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)!/2
                    cell.imageView?.layer.masksToBounds = true
                    cell.contentMode = .scaleAspectFill
                }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelButtonTapped() {
        delegate?.dismissDetailView()
    }
}

