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

    @IBOutlet weak var logoImageView: UIImageView!
    @IBAction func loginButtonPressed(_ sender: Any) {
//        guard let email = emailTextField.text else { return }
//        guard let password = passwordTextField.text else { return }

        let email = "testuser6@gmail.com"
        let password = "testuser6"
        firebase.signIn(email: email, password: password)
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase.delegateSignIn = self
        loginButton.layer.cornerRadius = 20
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
}

extension LoginViewController: FirebaseSignInDelegate {
    func SignedIn() {
        self.performSegue(withIdentifier: "LoginToHomeSegue", sender: nil )
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
