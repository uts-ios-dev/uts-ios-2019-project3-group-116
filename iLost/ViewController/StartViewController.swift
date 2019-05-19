//
//  ViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    var firebase = FirebaseHelper()
    @IBAction func logoutButtonPressed(_ sender: Any) {
        firebase.logOutUser()
        dismiss(animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print("---------")

        if let username = firebase.getUserName() {
            print(username)
        }

    }


}

