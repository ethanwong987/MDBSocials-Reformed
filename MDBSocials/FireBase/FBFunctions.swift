//
//  FBFunctions.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

//
//  FirebaseDemoAPIClient.swift
//  FirebaseDemoMaster
//
//  Created by Sahil Lamba on 2/16/18.
//  Copyright © 2018 Vidya Ravikumar. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class FBFunctions {
    /*
     static func fetchPosts(withBlock: @escaping ([Post]) -> ()) {
     //TODO: Implement a method to fetch posts with Firebase!
     let ref = Database.database().reference()
     ref.child("Posts").observe(.childAdded, with: { (snapshot) in
     let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
     withBlock([post])
     })
     }
     */
    static func getCurrentUser() -> Promise<Users> {
        return Promise { fulfill, _ in
            let ref = Database.database().reference()
            ref.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                if var dict = snapshot.value as? [String: Any] {
                    dict["id"] = snapshot.key
                    let user = Users(JSON: dict)
                    DispatchQueue.main.async {
                        fulfill(user!)
                    }
                }
            })
        }
    }
    static func createNewUser(id: String, name: String, email: String) {
        let usersRef = Database.database().reference().child("Users")
        let newUser = ["name": name, "email": email]
        let childUpdates = ["/\(id)/": newUser]
        usersRef.updateChildValues(childUpdates)
    }
}



