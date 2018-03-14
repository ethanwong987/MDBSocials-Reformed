//
//  SignUpVC-SetUpImagePicker.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/14/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import UIKit

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func pickImage(sender: UIButton!) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicButton.contentMode = .scaleAspectFit
        profilePicButton.setImage(chosenImage, for: .normal)
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
