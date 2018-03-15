//
//  DetailView-TableView.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/14/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import PromiseKit

extension DetailView {
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
                self.postUser = user
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
}
