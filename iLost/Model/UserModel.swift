//
//  User.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import Foundation
import UIKit

class UserModel {
    var name: String
    var surname: String
    var username: String
    var email: String
    var phone: String
    var address: String
    var postcode: String
    var city: String
    var image: UIImage?
    var imageURL: String
    var userID: String?
    
    init(name: String, surname: String, username: String, email: String, phone: String, address: String, postcode: String, city: String, image: UIImage?, imageURL: String)
    {
        self.name = name
        self.surname = surname
        self.username = username
        self.email = email
        self.phone = phone
        self.address = address
        self.postcode = postcode
        self.city = city
        self.image = image
        self.imageURL = imageURL
    }

    func getValues() -> [String:String] {
        let values = ["email": email, "username": username, "name": name, "surname": surname, "phone": phone, "address": address, "postcode": postcode, "city": city, "imageURL": imageURL]
        return values
    }
}
