//
//  ProfileViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{
    var imagePicker: ImagePickerHelper!
    var firebase = FirebaseHelper()
    var user:UserModel? = nil

    // UI elements
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postalcodeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
        self.firebase.delegateLoadedProfile = self
        
        firebase.loadUserProfile()
    }
    
    // Send updated user data to firebase
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let surname = surnameTextField.text else { return }
        guard let phone = phoneTextField.text else { return }
        guard let address = addressTextField.text else { return }
        guard let postcode = postalcodeTextField.text else { return }
        guard let city = cityTextField.text else { return }
        guard let username = user?.username else { return }
        guard let email = user?.email else { return }

        let userNew = UserModel(name: name, surname: surname , username: username, email: email, phone: phone, address: address, postcode: postcode, city: city, image: nil)

        firebase.saveUserProfile(values: userNew.getValues())
    }

    // Starts the photo selection process
    @IBAction func addPhotoPressed(_ sender: Any) {
        self.imagePicker.present(view: sender as! UIView)
    }
}

// Handles the photo selection
extension ProfileViewController: ImagePickerDelegate {
    func selectedImage(image: UIImage?) {
        self.profileImageView.image = image
    }
}

// Read user data from firebase
extension ProfileViewController: FirebaseLoadedProfileDelegate {
    func userProfile(user: UserModel) {
       self.user = user
        nameTextField.text = user.name
        surnameTextField.text = user.surname
        phoneTextField.text = user.phone
        addressTextField.text = user.address
        cityTextField.text = user.city
        usernameLabel.text = user.username
        postalcodeTextField.text = user.postcode
    }


}
