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


    @IBOutlet weak var label: UILabel!
    @IBOutlet var messageField: UITextView!
    @IBOutlet var answerField: UITextView!

    @IBAction func notifyButtonTapped(_ sender: Any) {
        guard let reciever = notification.userIdSender else {
//            print("error oID")
            return }
        guard let sender = firebase.getUserId() else {
//            print("error uID")
            return }
        guard let answerMessage = answerField.text else {
//            print("error message")
            return }

        guard let message = messageField.text else {
//            print("error answer")
            return }

        let date = Date().description
        firebase.saveNotification(values: ["userIdReciever": reciever, "userIdSender": sender, "date": date, "message": answerMessage, "answer": message])
    }

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
}
