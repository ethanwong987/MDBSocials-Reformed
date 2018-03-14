//
//  SignUpVC-SetUpUI.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/14/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import SkyFloatingLabelTextField

extension NewSocialVC {
    func createEventLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventName = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.3, width: vfw - 60, height: 45))
        eventName.lineColor = Constants.feedBackGroundColor!
        eventName.selectedTitleColor = Constants.feedBackGroundColor!
        eventName.selectedLineColor = Constants.feedBackGroundColor!
        eventName.tintColor = Constants.feedBackGroundColor!
        eventName.placeholder = "Event Name"
        eventName.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(eventName)
    }
    
    func createNameLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        posterName = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.4, width: vfw - 60, height: 45))
        posterName.lineColor = Constants.feedBackGroundColor!
        posterName.selectedTitleColor = Constants.feedBackGroundColor!
        posterName.selectedLineColor = Constants.feedBackGroundColor!
        posterName.tintColor = Constants.feedBackGroundColor!
        posterName.placeholder = "Post Creator"
        posterName.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(posterName)
    }
    
    func createDescLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        enterDesc = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.5, width: vfw - 60, height: 45))
        enterDesc.lineColor = Constants.feedBackGroundColor!
        enterDesc.selectedTitleColor = Constants.feedBackGroundColor!
        enterDesc.selectedLineColor = Constants.feedBackGroundColor!
        enterDesc.tintColor = Constants.feedBackGroundColor!
        enterDesc.placeholder = "Description of Event"
        enterDesc.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(enterDesc)
    }
    
    func createDatePicker() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        datePickerText = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.6, width: vfw - 60, height: 45))
        datePickerText.lineColor = Constants.feedBackGroundColor!
        datePickerText.selectedTitleColor = Constants.feedBackGroundColor!
        datePickerText.selectedLineColor = Constants.feedBackGroundColor!
        datePickerText.tintColor = Constants.feedBackGroundColor!
        datePickerText.placeholder = "Date"
        datePickerText.placeholderColor = Constants.feedBackGroundColor!
        datePickerText.adjustsFontSizeToFitWidth = true
        datePickerText.textAlignment = .left
        datePickerText.layer.masksToBounds = true
        datePickerText.textColor = .black
        view.addSubview(datePickerText)
        setupDatePicker()
    }
    
    func createTimePicker(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        timePickerText = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.7, width: vfw - 60, height: 45))
        timePickerText.lineColor = Constants.feedBackGroundColor!
        timePickerText.selectedTitleColor = Constants.feedBackGroundColor!
        timePickerText.selectedLineColor = Constants.feedBackGroundColor!
        timePickerText.tintColor = Constants.feedBackGroundColor!
        timePickerText.placeholder = "Time"
        timePickerText.placeholderColor = Constants.feedBackGroundColor!
        timePickerText.adjustsFontSizeToFitWidth = true
        timePickerText.textAlignment = .left
        timePickerText.layer.masksToBounds = true
        timePickerText.textColor = .black
        view.addSubview(timePickerText)
        setUpTimePicker()
    }
    
    func setUpTimePicker(){
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(getTime))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        timePickerText.inputAccessoryView = toolbar
        timePickerText.inputView = timePicker
    }
    
    func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveText))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        datePickerText.inputAccessoryView = toolbar
        datePickerText.inputView = datePicker
    }
    
    func setUpUI() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        view.backgroundColor = Constants.cellColor
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.3, width: vfw-30, height: vfh * 0.65))
        borderBox.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        
        eventPic = UIImageView(frame: CGRect(x: vfw*0.04, y: vfh*0.05, width: vfw-30, height: vfh*0.15))
        selectFromLibraryButton = UIButton(frame: eventPic.frame)
        selectFromLibraryButton.setTitle("SELECT \n AN IMAGE", for: .normal)
        selectFromLibraryButton.titleLabel?.numberOfLines = 0
        selectFromLibraryButton.setTitleColor(UIColor.blue, for: .normal)
        selectFromLibraryButton.layer.borderColor = Constants.feedBackGroundColor?.cgColor
        selectFromLibraryButton.layer.borderWidth = 3
        selectFromLibraryButton.setTitleColor(Constants.feedBackGroundColor, for: .normal)
        selectFromLibraryButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 50)
        selectFromLibraryButton.titleLabel?.textAlignment = .center
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        view.addSubview(borderBox)
        view.addSubview(eventPic)
        view.addSubview(selectFromLibraryButton)
        view.bringSubview(toFront: selectFromLibraryButton)
    }
    
    func createButtons() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        createPostButton = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.81, width: vfw - 50, height: 40))
        createPostButton.setTitle("Create Post", for: .normal)
        createPostButton.backgroundColor = Constants.feedBackGroundColor!
        createPostButton.addTarget(self, action: #selector(createPostToFeed), for: .touchUpInside)
        createPostButton.layer.cornerRadius = 10
        
        backToLogin = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.87, width: vfw - 50, height: 40))
        backToLogin.setTitle("Back To Feed", for: .normal)
        backToLogin.setTitleColor(.white, for: .normal)
        backToLogin.addTarget(self, action: #selector(backToFeed), for: .touchUpInside)
        
        
        takePictureButton = UIButton(frame: CGRect(x: vfw*0.15, y: vfh*0.22, width: vfw*0.3, height: vfh*0.05))
        takePictureButton.backgroundColor = Constants.feedBackGroundColor
        takePictureButton.setTitle("Take a photo", for: .normal)
        takePictureButton.layer.cornerRadius = 10
        takePictureButton.layer.borderColor = UIColor.white.cgColor
        takePictureButton.layer.borderWidth = 1
        takePictureButton.addTarget(self, action: #selector(selectPictureFromCamera), for: .touchUpInside)
        
        view.addSubview(takePictureButton)
        view.addSubview(backToLogin)
        view.addSubview(createPostButton)
    }
    
    func setUpMapButton() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        mapButton = UIButton(frame: CGRect(x: vfw*0.6, y: vfh*0.22, width: vfw*0.3, height: vfh*0.05))
        mapButton.backgroundColor = Constants.feedBackGroundColor
        mapButton.setTitle("Pick Location", for: .normal)
        mapButton.layer.cornerRadius = 10
        mapButton.layer.borderColor = UIColor.white.cgColor
        mapButton.layer.borderWidth = 1
        mapButton.addTarget(self, action: #selector(toMap), for: .touchUpInside)
        view.addSubview(mapButton)
    }
    
}
