//
//  Notification.swift
//  iLost
//
//  Created by ak on 03.06.19.
//  Copyright © 2019 ak. All rights reserved.
//

import Foundation

class NotificationModel {
    var notificationID: String?
    var date: String?
    var userIdReciever: String?
    var userIdSender: String?
    var message: String?
    var answer: String?
    var userName: String?

    func getValues() -> [String: String?] {
        let values = ["userIdReciever": userIdReciever, "userIdSender": userIdSender, "date": date, "message": message, "answer": answer]
        return values
    }
}
