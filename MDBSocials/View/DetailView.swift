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

protocol DetailViewDelegate {
    func dismissDetailView()
}

class DetailView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var cancelButton: UIButton!
    var addToCartButton: UIButton!
    var delegate: DetailViewDelegate?
    var currPost: Post!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        layer.cornerRadius = 3
        clipsToBounds = true
        backgroundColor = .white
        
        cancelButton = UIButton(frame: CGRect(x: 15, y: 15, width: 18, height: 18))
        cancelButton.contentMode = .scaleAspectFill
        cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addSubview(cancelButton)
        
        addToCartButton = UIButton(frame: CGRect(x: 0, y: frame.height - 50, width: frame.width, height: 50))
        addToCartButton.backgroundColor = Constants.feedBackGroundColor
        addToCartButton.setTitle("INTERESTED", for: .normal)
        
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.setTitleColor(.lightGray, for: .disabled)
        addToCartButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 14)
        addSubview(addToCartButton)
        
    }
    
    func setup() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        tableView.layer.backgroundColor = UIColor.black.cgColor
        self.addSubview(tableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height/6)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = currPost.numInterested[0]
        return cell
        
        //if cell is self then highlight green
        //if no one is interested, createAlert when pressing icon - Woops! Looks like no one is interested yet. Be the first!
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelButtonTapped() {
        delegate?.dismissDetailView()
    }
}

