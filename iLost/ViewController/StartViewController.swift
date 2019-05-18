//
//  ViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import Firebase
class StartViewController: UIViewController {
    @IBAction func logoutButtonPressed(_ sender: Any) {

        do{
            try Auth.auth().signOut()
        }
        catch {
            print("error logout")
        }
        dismiss(animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print("---------")

        if let username = Auth.auth().currentUser?.displayName {
            print(username)
        }

    }


}

