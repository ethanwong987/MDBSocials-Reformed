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
import LocationPicker
import CoreLocation

class NewSocialVC: UIViewController {
    var eventName: SkyFloatingLabelTextField!
    var posterName: SkyFloatingLabelTextField!
    var enterDesc: SkyFloatingLabelTextField!
    var datePickerText: SkyFloatingLabelTextField!
    var timePickerText: SkyFloatingLabelTextField!
    var signUpTitle: UIImageView!
    var borderBox: UILabel!
    var eventPic: UIImageView!
    var createPostButton: UIButton!
    var backToLogin: UIButton!
    var profileImage: UIButton!
    var selectFromLibraryButton: UIButton!
    var takePictureButton: UIButton!
    var mapButton: UIButton!
    var timePicker: UIDatePicker!
    var picker = UIImagePickerController()
    var datePicker: UIDatePicker!
    
    var selectedLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        createNameLabel()
        createDescLabel()
        createDatePicker()
        createTimePicker()
        createEventLabel()
        createButtons()
        setUpMapButton()
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
    
    @objc func getTime() {
        timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timePickerText.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func saveText(){
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        datePickerText.text = selectedDate
        self.view.endEditing(true)
    }
    
    @objc func cancel(){
        self.view.endEditing(true)
    }
    
    @objc func pickImage(sender: UIButton!) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    @objc func toMap() {
        let locationPicker = LocationPickerViewController()
        
        locationPicker.showCurrentLocationButton = true
        locationPicker.currentLocationButtonBackground = Constants.MDBBlue!
        locationPicker.showCurrentLocationInitially = true
        locationPicker.mapType = .standard
        
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.resultRegionDistance = 100
        locationPicker.completion = { location in
            self.selectedLocation = location?.coordinate
        }
        
        
        self.present(locationPicker, animated: true) {
            log.info("Selecting location")
        }
    }
    
    @objc func selectPictureFromCamera() {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func createPostToFeed() {
        createPostButton.isEnabled = false
        if !areTextFieldsCompleted() && !isImageThere(){
            let alert = self.createAlert(warning: "Fill out all fields!")
            self.present(alert, animated: true, completion: nil)
        } else if !areTextFieldsCompleted() {
            let alert = self.createAlert(warning: "Fill out all text fields!")
            self.present(alert, animated: true, completion: nil)
        } else if !isImageThere() {
            let alert = self.createAlert(warning: "Select an image.")
            self.present(alert, animated: true, completion: nil)
        } else {
            self.createPostButton.isEnabled = false
            let postsRef = Database.database().reference().child("Posts")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let imageData = UIImageJPEGRepresentation(eventPic.image!, 0.7)
            postsRef.child("Users").child((Auth.auth().currentUser?.uid)!).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                let date = self.datePickerText.text!
                let time = self.timePickerText.text!
                let posterId = Auth.auth().currentUser?.uid
                let postText = self.enterDesc.text!
                let poster = self.posterName.text!
                let numInterested = 0
                let postTitle = self.eventName.text!
                let location = self.selectedLocation!
                var newPost = ["postTitle": postTitle, "date": date, "time": time, "numInterested": numInterested, "text": postText, "poster": poster, "imageUrl": "", "posterId": posterId, "latitude":location.latitude, "longitude":location.longitude] as [String : Any]
                let key = postsRef.childByAutoId().key
                let storage = Storage.storage().reference().child("Posts").child(key)
                storage.putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                    if error == nil {
                        let imageUrl = metadata?.downloadURL()?.absoluteString
                        newPost["imageUrl"] = imageUrl
                        postsRef.updateChildValues(["\(key)": newPost])
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let alert = self.createAlert(warning: error!.localizedDescription)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    func areTextFieldsCompleted() -> Bool {
        return eventName.hasText && posterName.hasText && datePickerText.hasText && timePickerText.hasText && enterDesc.hasText
    }
    
    func isImageThere() -> Bool {
        return eventPic.image != nil
    }
    
    func createAlert(warning: String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning:", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    @objc func backToFeed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewSocialVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        selectFromLibraryButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventPic.contentMode = .scaleAspectFit
        eventPic.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

