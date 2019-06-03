//
//  LostItemModel.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ItemModel {
    var title: String?
    var description: String?
    var category: String?
    var images: [UIImage]?
    var dateLost: String?
    var dateFound: String?
    var lostLocationsCoordinates = [CLLocationCoordinate2D]()
    var itemID: String?
    var foundID: String?
    var lostID: String?
    var ownerID: String?
    var lostFound: Bool = true
    
    init(){ }

    init(title: String, description: String, category: String, dateLost: String, dateFound: String, images: [UIImage]?, ownerId: String){
        self.title = title
        self.description = description
        self.category = category
        self.dateLost = dateLost
        self.dateFound = dateFound
        self.images = images
        self.ownerID = ownerId
    }


    func getValues() -> [String: String?] {
        let values = ["title": title, "description": description, "category": category, "dateLost": dateLost, "dateFound":  dateFound, "userIdItemOwner": ownerID]
        return values
    }

    func getLocations() -> [[String: Double]] {
        var values = [[String: Double]]()
        for location in lostLocationsCoordinates {
            let latitude = Double(location.latitude)
            let longitude = Double(location.longitude)
            values.append(["latitude": latitude, "longitude":longitude])
        }
        return values
    }

//    func getLoc() -> [String: Double] {
//        var values = [String: Double]()
//        var locations = getLocations()
//        for index in locations.indices {
//            values["Location \(index)"] = locations[index]
//        }
//        return values
//    }
}
