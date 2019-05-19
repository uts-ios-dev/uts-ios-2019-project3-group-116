//
//  FoundReportViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class FoundReportViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!

    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
    }

}
