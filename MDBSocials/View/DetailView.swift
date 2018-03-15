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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelButtonTapped() {
        delegate?.dismissDetailView()
    }
}

