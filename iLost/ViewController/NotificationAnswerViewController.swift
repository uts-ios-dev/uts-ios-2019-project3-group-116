//
//  NotificationAnswerViewController.swift
//  iLost
//
//  Created by ak on 03.06.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class NotificationAnswerViewController: UIViewController {
    var item = ItemModel()
    var firebase = FirebaseHelper()
    var notification = NotificationModel()

    // UI elements
    @IBOutlet weak var label: UILabel!
    @IBOutlet var messageField: UITextView!
    @IBOutlet var answerField: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (item.dateLost != "" && item.dateFound == "") {
            label.text = "Notify Owner"
        } else if (item.dateFound != "" && item.dateLost == "") {
            label.text = "Notify Finder"
        }
        if let answer = notification.answer {
            answerField.text = answer
        }
        
        if let message = notification.message {
            messageField.text = message
        }
        //TODO: - Add Username
    }
    
    // Save the notification to the database 
    @IBAction func notifyButtonTapped(_ sender: Any) {
        guard let reciever = notification.userIdSender else {
            return }
        guard let sender = firebase.getUserId() else {
            return }
        guard let answerMessage = answerField.text else {
            return }
        guard let message = messageField.text else {
            return }

        let date = Date().description
        firebase.saveNotification(values: ["userIdReciever": reciever, "userIdSender": sender, "date": date, "message": answerMessage, "answer": message])
    }
}
