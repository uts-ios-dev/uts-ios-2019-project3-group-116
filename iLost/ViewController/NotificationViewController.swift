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

    // UI elements
    @IBOutlet weak var label: UILabel!
    @IBOutlet var titleField: UITextView!

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
    
    // Save the notification to the database 
    @IBAction func notifyButtonTapped(_ sender: Any) {
        guard let reciever = item.ownerID else {
            return }
        guard let sender = firebase.getUserId() else {
            return }
        guard let message = titleField.text else {
            return }

        let date = Date().description
        firebase.saveNotification(values: ["userIdReciever": reciever, "userIdSender": sender, "date": date, "message": message, "answer": ""])
    }
}
