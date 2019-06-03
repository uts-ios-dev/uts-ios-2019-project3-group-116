//
//  NotificationViewController.swift
//  iLost
//
//  Created by ak on 20.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import Firebase

class NotificationViewController: UIViewController {
    var item = ItemModel()
    var firebase = FirebaseHelper()
    var notification = NotificationModel()

    @IBOutlet weak var label: UILabel!
    @IBOutlet var titleField: UITextView!

    @IBAction func notifyButtonTapped(_ sender: Any) {
        guard let reciever = item.ownerID else {
//            print("error oID")
            return }
        guard let sender = firebase.getUserId() else {
//            print("error uID")
            return }
        guard let message = titleField.text else {
//            print("error message")
            return }

        let date = Date().description

        firebase.saveNotification(values: ["userIdReciever": reciever, "userIdSender": sender, "date": date, "message": message, "answer": ""])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (item.dateLost != "" && item.dateFound == "") {
            label.text = "Notify Owner"
        }
        else if (item.dateFound != "" && item.dateLost == "") {
            label.text = "Notify Finder"
        }

        if let message = notification.message {
            titleField.text = message
        }
    }
}
