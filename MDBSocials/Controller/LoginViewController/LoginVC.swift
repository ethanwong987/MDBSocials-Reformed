//
//  ViewController.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/19/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import ChameleonFramework

class LoginVC: UIViewController {
    var emailText: SkyFloatingLabelTextField!
    var passWord: SkyFloatingLabelTextField!
    var userName: SkyFloatingLabelTextField!
    var welcomeTitle: UILabel!
    var borderBox: UILabel!
    var loginButton: UIButton!
    var signUpButton: UIButton!
    var MDBLogo: UIImageView!
    var MDBTitle: UILabel!
    var backgroundColours = [Constants.MDBBlue, Constants.cellColor, Constants.feedBackGroundColor]
    var backgroundLoop = 0
    
    override func viewDidLoad() {
        checkIfUserIsSignedIn()
        super.viewDidLoad()
        setUpLoginUI()
        animateBackgroundColour()
        createButtons()
        createTitle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func checkIfUserIsSignedIn() {
        log.info("Checking if signed in")
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                log.info("Signed in")
                self.performSegue(withIdentifier: "toFeed", sender: self)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func logInToFeed() {
        let email = emailText.text!
        let password = passWord.text!
        emailText.text = ""
        passWord.text = ""
        UserAuth.signIn(email: email, password: password).then { _ in
            self.performSegue(withIdentifier: "toFeed", sender: self)
            }.then {
                log.info("Logged In.")
        }
    }
    
    /*
     if error == nil {
     self.performSegue(withIdentifier: "toFeed", sender: self)}
     else {
     let alert = self.createAlert(warning: error!.localizedDescription)
     self.present(alert, animated: true, completion: nil)
     }
     }
     */
    
    
    func createAlert(warning: String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning:", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    
    @objc func toSignUp() {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
}

