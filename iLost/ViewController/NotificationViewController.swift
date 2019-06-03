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
    
    @IBOutlet var titleField: UITextView!
    @IBOutlet var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (item.dateLost != "" && item.dateFound == "") {
            titleField.text = "Notify Owner"
        } else if (item.dateFound != "" && item.dateLost == "") {
            titleField.text = "Notify Finder"
        }
        
//        Database.database().reference().child("items").child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            self.titleField.text = value?["title"] as? String ?? ""
//            self.descriptionField.text = value?["description"] as? String ?? ""
//        })
//        { (error) in
//            print(error.localizedDescription)
//        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
