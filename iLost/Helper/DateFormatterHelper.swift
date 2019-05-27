//
//  DateFormattter.swift
//  iLost
//
//  Created by ak on 27.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class DateFormatterHelper: NSObject {

    func createFormatedDateString(_ date: Date) -> String {
        let dateFormatterGet                = DateFormatter()
        dateFormatterGet.dateFormat         = "yyyy-MM-dd HH:mm:ssZ"
        let dateFormatterPrint              = DateFormatter()
        dateFormatterPrint.dateFormat       = "dd.MM.yyyy"
        let dateNew                         = dateFormatterGet.date(from: date.description)
        return dateFormatterPrint.string(from: dateNew!)
    }
}
