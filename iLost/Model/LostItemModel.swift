//
//  LostItemModel.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import Foundation
import UIKit

class LostItemModel {
    var description: String
    var category: String
    var images: [UIImage]?
    var dateLost: Date
    var dateFound: Date?

    init(description: String, category: String, date: Date, images: [UIImage]){
        self.description = description
        self.category = category
        self.dateLost = date
        self.images = images
    }
}
