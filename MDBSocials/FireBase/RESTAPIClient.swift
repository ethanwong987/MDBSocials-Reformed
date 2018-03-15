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
import Foundation
import PromiseKit
import Firebase
import Alamofire
import SwiftyJSON

class RESTAPIClient {
    static func fetchUser(id: String) -> Promise<Users> {
        return Promise { fulfill, _ in
            
            let ref = Database.database().reference()
            ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    static func fetchPost(id: String) -> Promise<Post> {
        return Promise { fulfill, _ in
        
            let ref = Database.database().reference()
            ref.child("Posts").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if var dict = snapshot.value as? [String: Any] {
                    dict["id"] = snapshot.key
                    let post = Post(JSON: dict)
                    DispatchQueue.main.async {
                        fulfill(post!)
                    }
                }
            })
        }
    }
    
//    static func getCurrentUser() -> Promise<Users> {
//        return Promise { fulfill, _ in
//            let ref = Database.database().reference()
//            ref.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
//                if var dict = snapshot.value as? [String: Any] {
//                    dict["id"] = snapshot.key
//                    let user = Users(JSON: dict)
//                    DispatchQueue.main.async {
//                        fulfill(user!)
//                    }
//                }
//            })
//        }
//    }

    static func getCurrentUser() -> Promise<Users> {
        return Promise { fulfill, error in
            Alamofire.request("https://mdbsocials-final.herokuapp.com/users/\((Auth.auth().currentUser?.uid)!)").responseJSON { response in
                if let response = response.result.value {
                    let json = JSON(response)
                    if var result = json.dictionaryObject {
                        result["id"] = (Auth.auth().currentUser?.uid)!
                        if let user = Users(JSON: result) {
                            fulfill(user)
                        }
                    }
                }
            }
        }
    }
    
//    static func getUserWithId(id: String) -> Promise<Users> {
//        return Promise { fulfill, error in
//            Alamofire.request("https://mdbsocials-final.herokuapp.com/users/\(id)").responseJSON { response in
//                if let response = response.result.value {
//                    let json = JSON(response)
//                    if let result = json.dictionaryObject {
//                        if let user = Users(JSON: result){
//                            fulfill(user)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    static func createNewUser(id: String, name: String, email: String) {
        let usersRef = Database.database().reference().child("Users")
        let newUser = ["name": name, "email": email]
        let childUpdates = ["/\(id)/": newUser]
        usersRef.updateChildValues(childUpdates)
    }
}




