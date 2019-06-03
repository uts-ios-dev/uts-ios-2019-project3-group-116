//
//  ViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    var firebase = FirebaseHelper()
    var vSpinner: UIView?
    var sectionHeader = ["Lost Item", "Found Item", "Notification"]
    var notificationRow = [String]()
    var lostRow = [String]()
    var foundRow = [String]()
    var sections:[[String]] = []
    var itemsLost: [ItemModel] = []
    var itemsFound: [ItemModel] = []
    var notifications: [NotificationModel] = []
    var item: ItemModel = ItemModel()
    var notification: NotificationModel = NotificationModel()

    // UI elements
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showSpinner(onView: self.view)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.firebase.delegateloadedItems = self
        self.sections = [self.lostRow, self.foundRow, self.notificationRow]
        firebase.loadAllNotifications()
        firebase.loadItems()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.sections = [self.lostRow, self.foundRow, self.notificationRow]
        firebase.loadAllNotifications()
        firebase.loadItems()
    }

    // Switch to Login Scene after logout process was successful
    @IBAction func lougoutButtonPressed(_ sender: Any) {
        firebase.logOutUser()
        dismiss(animated: true, completion: nil)
    }
    
    func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}

// Setup table 
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UILabel = UILabel()
        header.text = self.sectionHeader[section]
        header.textColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        header.font = UIFont(name:"Verdana", size:20)
        header.font = UIFont.boldSystemFont(ofSize: 20)
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableCell", for: indexPath)

        cell.textLabel?.font = UIFont(name:"Verdana", size:15)
        cell.textLabel?.textColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
        }
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        return cell
    }

    // TODO: - Notifications not implemented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowNotificationAnswerSegue") {
            let viewController = segue.destination as! NotificationAnswerViewController
                viewController.notification = notification
        }
        else if (segue.identifier == "UpdateReportItemSegue") {
            let destVC = segue.destination as! ReportViewController
                destVC.item = item
        }
        else if (segue.identifier == "Settings") {
            _ = segue.destination as! SettingsTableViewController
        }
    }

// TODO: - Notifications are not implemented
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            item = itemsLost[indexPath.row]
            performSegue(withIdentifier: "UpdateReportItemSegue", sender: self)
        }
        if indexPath.section == 1 {
            item = itemsFound[indexPath.row]
            performSegue(withIdentifier: "UpdateReportItemSegue", sender: self)
        }
        if indexPath.section == 2 {
            notification = notifications[indexPath.row]
            performSegue(withIdentifier: "ShowNotificationAnswerSegue", sender: self)
        }
    }

    // TODO: - Delete Items and Notification from DB and Table are not implemented

}

extension HomeViewController: FirebaseLoadedItemsDelegate {
    func getNotifcations(notifications: [NotificationModel]) {
        notificationRow.removeAll()
        self.notifications.removeAll()
        print("Count items notification:" + String(notifications.count))
        for notification in notifications{
            self.notifications.append(notification)
            notificationRow.append(notification.date!)
        }
         self.sections[2] =  self.notificationRow
    }

    func getItemModels(items: [ItemModel]) {
        print("Count items:" + String(items.count))
        lostRow.removeAll()
        foundRow.removeAll()
        for item in items {
            if item.dateLost != "" && item.dateFound == "" {
                self.itemsLost.append(item)
                if let dateLost = item.dateLost {
                    self.lostRow.append(item.title! + " " + dateLost)
                }
            }
            if item.dateFound != "" && item.dateLost == "" {
                self.itemsFound.append(item)
                if let dateFound = item.dateFound {
                   self.foundRow.append(item.title! + " " + dateFound)
                }
            }
        }
        self.sections[0] = self.lostRow
        self.sections[1] = self.foundRow
        self.tableView.reloadData()
        self.removeSpinner()
    }


}

