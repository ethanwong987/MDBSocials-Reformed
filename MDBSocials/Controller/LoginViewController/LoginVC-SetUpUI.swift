//
//  LoginVC-SetUpUI.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/14/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import ChameleonFramework

extension LoginVC {
    func animateBackgroundColour () {
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop += 1
        } else {
            backgroundLoop = 0
        }
        UIView.animate(withDuration: 5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.backgroundColor =  self.backgroundColours[self.backgroundLoop];
        }) {(Bool) -> Void in
            self.animateBackgroundColour();
        }
    }
    
    func setUpLoginUI() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        view.backgroundColor = Constants.MDBBlue
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.58, width: vfw-30, height: 260))
        borderBox.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        
        emailText = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.6, width: vfw - 60, height: 45))
        emailText.lineColor = Constants.MDBOrange!
        emailText.selectedTitleColor = Constants.MDBOrange!
        emailText.selectedLineColor = Constants.MDBOrange!
        emailText.tintColor = Constants.MDBOrange
        
        passWord = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.7, width:
            vfw - 60, height: 45))
        passWord.lineColor = Constants.MDBOrange!
        passWord.selectedTitleColor = Constants.MDBOrange!
        passWord.selectedLineColor = Constants.MDBOrange!
        
        emailText.placeholder = "Email"
        emailText.placeholderColor = Constants.MDBOrange!
        passWord.placeholder = "Password"
        passWord.placeholderColor = Constants.MDBOrange!
        
        view.addSubview(borderBox)
        view.addSubview(emailText)
        view.addSubview(passWord)
    }
    
    func createButtons() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        loginButton = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.81, width: vfw - 50, height: 40))
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = Constants.MDBOrange
        loginButton.addTarget(self, action: #selector(logInToFeed), for: .touchUpInside)
        loginButton.layer.cornerRadius = 10
        
        signUpButton = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.88, width: vfw - 50, height: 40))
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = Constants.MDBBlue
        signUpButton.addTarget(self, action: #selector(toSignUp), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 10
        
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    func createTitle() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        MDBLogo = UIImageView(frame: CGRect(x:vfw * 0.06, y: -(vfh * 0.3), width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height))
        MDBLogo.image = UIImage(named: "mdb_white")
        MDBLogo.contentMode = .scaleAspectFit
        
        MDBTitle = UILabel(frame: CGRect(x: vfw*0.19, y: vfh*0.1, width: vfw-30, height: 300))
        MDBTitle.text = "SOCIALS"
        MDBTitle.textAlignment = .center
        MDBTitle.textColor = .white
        MDBTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 55)
        welcomeTitle = UILabel(frame: CGRect(x: vfw*0.07, y: vfh*0.5, width: vfw-30, height: 45))
        welcomeTitle.text = "WELCOME! PLEASE SIGN IN."
        welcomeTitle.font = UIFont(name: "HiraKakuProN-W3", size: 23)
        welcomeTitle.textColor = .white
        
        view.addSubview(welcomeTitle)
        view.addSubview(MDBTitle)
        view.addSubview(MDBLogo)
    }
}
