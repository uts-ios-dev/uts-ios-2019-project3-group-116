//
//  LoginViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
//import Firebase

class LoginViewController: UIViewController {
    var firebase = FirebaseHelper()

    // UI elements
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebase.delegateSignIn = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        passwordTextField.delegate = self
        emailTextField.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Check if an email address and password are entered and send them to the firebase
    @IBAction func loginButtonPressed(_ sender: Any) {
        if (emailTextField.text == "" || passwordTextField.text == "") {
            if (emailTextField.text == "") {
                emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            
            if (passwordTextField.text == "") {
                passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            
            loginButton.shake()
        } else {
            if let email = emailTextField.text, let password = passwordTextField.text {
                firebase.signIn(email: email, password: password)
            }
        }
    }
}

// Switch to Home Scene after login process was successful
extension LoginViewController: FirebaseSignInDelegate {
    func SignedIn(success: Bool) {
        if (success) {
            self.performSegue(withIdentifier: "LoginToHomeSegue", sender: nil )
        } else {
            self.present(CustomAlertBox.setup(title: "Login unsuccessful", message: "Wrong Email Address or Password!", action: "Try again"), animated: true, completion: nil)
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
}

// Go to next textfield by return button
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
