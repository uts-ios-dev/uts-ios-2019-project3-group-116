//
//  CustomAlertBox.swift
//  iLost
//
//  Created by Camilla Gretsch on 02.06.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class CustomAlertBox: UIAlertController {
    
    static func setup(title: String, message: String, action: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: { _ in
        }))
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        alert.view.subviews.last!.layer.cornerRadius = 20
        alert.view.tintColor = UIColor(red: 39/255, green: 159/255, blue: 238/255, alpha: 1)
        
        return alert
    }
}
