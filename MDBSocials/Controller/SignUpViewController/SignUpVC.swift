//
//  SignUpVC.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import ChameleonFramework

class SignUpVC: UIViewController {
    var fullname: SkyFloatingLabelTextField!
    var userName: SkyFloatingLabelTextField!
    var passWord: SkyFloatingLabelTextField!
    var confirmPwd: SkyFloatingLabelTextField!
    var emailText: SkyFloatingLabelTextField!
    var profilePicButton: UIButton!
    var borderBox: UILabel!
    var signUpButton: UIButton!
    var backToLogin: UIButton!
    var profileImage: UIButton!
    var picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        createNameLabels()
        createPassWordLabel()
        createUserLabel()
        createEmailLabel()
        createButtons()
    }
    
    @objc func signUpToFeed() {
        let email = emailText.text!
        let password = passWord.text!
        let name = fullname.text!
        let username = userName.text!
        
        Auth.auth().createUser(withEmail: email, password: password, completion:{ (user, error) in if error == nil {
            let ref = Database.database().reference()
            let uid = (user?.uid)!
            let userRef = ref.child("Users").child(uid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let imageData = UIImageJPEGRepresentation(self.profilePicButton.currentImage!, 0.7)
            userRef.setValue(["uid":uid, "name":name, "email":email, "username":username, "password":password, "imageUrl": "", "eventIds": []])
            let key = userRef.childByAutoId().key
            let storage = Storage.storage().reference().child("Users").child(key)
            storage.putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                if error == nil {
                    let imageUrl = metadata?.downloadURL()?.absoluteString
                    userRef.updateChildValues(["imageUrl": imageUrl])
                    self.performSegue(withIdentifier: "signUpToFeed", sender: self)
                    } else {
                    
                        let alert = self.createAlert(warning: error!.localizedDescription)
                        self.present(alert, animated: true, completion: nil)
                    }
            })
            if let error = error {
                log.error(error.localizedDescription)
            }
            }
        })
    }
    
    func createAlert(warning: String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning:", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    @objc func toLogin() {
        self.dismiss(animated: true, completion: nil)
    }
}
