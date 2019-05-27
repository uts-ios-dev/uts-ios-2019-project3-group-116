//
//  SingUpViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var firebase = FirebaseHelper()
    var imagePicker: ImagePickerHelper!
    
    var password: String = ""
    
    // UI elements
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: CustomButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
    }
    
    // Create user if all the user information are entered to the textfields
    func createUser() -> UserModel?{
        let name, email, username, surname, phone, address, postcode, city: String
        
        // Check if any textfield is empty
        if nameTextField.text?.isEmpty ?? true {
            nameTextField.shakeTextField()
            return nil
        } else {
            name = nameTextField.text!
        }
        if surnameTextField.text?.isEmpty ?? true {
            surnameTextField.shakeTextField()
            return nil
        } else {
            surname = surnameTextField.text!
        }
        if addressTextField.text?.isEmpty ?? true {
            addressTextField.shakeTextField()
            return nil
        } else {
            address = addressTextField.text!
        }
        if cityTextField.text?.isEmpty ?? true {
            cityTextField.shakeTextField()
            return nil
        } else {
            city = cityTextField.text!
        }
        if postcodeTextField.text?.isEmpty ?? true {
            postcodeTextField.shakeTextField()
            return nil
        } else {
            postcode = postcodeTextField.text!
        }
        if phoneTextField.text?.isEmpty ?? true {
            phoneTextField.shakeTextField()
            return nil
        } else {
            phone = phoneTextField.text!
        }
        if emailTextField.text?.isEmpty ?? true {
            emailTextField.shakeTextField()
            return nil
        } else {
            email = emailTextField.text!
        }
        if usernameTextField.text?.isEmpty ?? true {
            usernameTextField.shakeTextField()
            return nil
        } else {
            username = usernameTextField.text!
        }
        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.shakeTextField()
            return nil
        } else {
            password = passwordTextField.text!
        }
        // Create user
        return UserModel(name: name, surname: surname, username: username, email: email, phone: phone, address: address, postcode: postcode, city: city, image: self.photoImageView.image)
    }
    
    // Handles the sign up and create user process
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        if let user = createUser() {
            firebase.createUser(user: user, password: password)
        }
    }
    
    // Starts the photo selection process
    @IBAction func addPhotoPressed(_ sender: Any) {
        self.imagePicker.present(view: sender as! UIView)
    }
}

// Switch to Home Scene after sign up process was successful
extension SignUpViewController: FirebaseCreateUserDelegate {
    func userCreated() {
        self.performSegue(withIdentifier: "RegisterToHomeSegue", sender: nil )
    }
}

// Handles the photo selection
extension SignUpViewController: ImagePickerDelegate {
    func selectedImage(image: UIImage?) {
        self.photoImageView.image = image
        addPhotoButton.isHidden = true
        photoImageView.isHidden = false
    }
}

// Add shake animation to textfields
extension UIView {
    func shakeTextField() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

// Go to next textfield by return button
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
