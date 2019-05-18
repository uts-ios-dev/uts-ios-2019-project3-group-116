//
//  SingUpViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var firebase = FirebaseHelper()
    var imagePicker: ImagePicker!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let password = passwordTextField.text else { return }
        if let user = createUser() {
           firebase.createUser(user: user, password: password)
        }
    }
    @IBAction func addPhotoPressed(_ sender: Any) {
        self.imagePicker.present(view: sender as! UIView)
    }
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    // TODO: check if content is empty
    func createUser() -> UserModel?{
        guard let email = emailTextField.text else { return nil}
        guard let username = usernameTextField.text else { return nil }
        guard let name = nameTextField.text else { return nil }
        guard let surname = surnameTextField.text else { return nil}
        guard let phone = phoneTextField.text else { return nil}
        guard let address = addressTextField.text else { return nil }
        guard let postcode = postcodeTextField.text else { return nil }
        guard let city = cityTextField.text else { return nil }
       

        let user = UserModel(name: name, surname: surname, username: username, email: email, phone: phone, address: address, postcode: postcode, city: city)



        return user
    }
}

extension RegisterViewController: FirebaseCreateUserDelegate {
    func userCreated() {
       self.performSegue(withIdentifier: "RegisterToHomeSegue", sender: nil )
    }
}

extension RegisterViewController: ImagePickerDelegate {
    func selectedImage(image: UIImage?) {
        self.photoImageView.image = image
    }
}
