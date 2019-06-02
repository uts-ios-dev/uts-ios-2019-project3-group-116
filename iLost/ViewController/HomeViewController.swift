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
    var lostRowKeys = [String]()
    var foundRow = [String]()
    var foundRowKeys = [String]()
    var sections:[[String]] = []

    // UI elements
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showSpinner(onView: self.view)
        loadData()
    }

    // Loads the lost, found items and the notifications from the database
    func loadData() {
        Database.database().reference().child("items").observe(.value, with: { (snapshot) in
            if let test = snapshot.value as? [String:AnyObject] {
                for child in test {
                    let value = child.value as? NSDictionary
                    let user = value?["User"] as? String ?? ""
                    let uid = Auth.auth().currentUser?.uid
                    if user == uid {
                        let title = value?["title"] as? String ?? ""
                        let dateFound = value?["dateFound"] as? String ?? ""
                        let dateLost = value?["dateLost"] as? String ?? ""
                        if dateLost != "" && dateFound == "" {
                            self.lostRow.append(title)
                            self.lostRowKeys.append(child.key)
                        } else if dateFound != "" && dateLost == "" {
                            self.foundRow.append(title)
                            self.foundRowKeys.append(child.key)
                        }
                    }
                }
                self.sections = [self.lostRow, self.foundRow, self.notificationRow]
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.removeSpinner()
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
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
    
    @IBAction func unwindToHomeViewControllerFromReport(segue: UIStoryboardSegue) {
        sections.removeAll()
        lostRow.removeAll()
        foundRow.removeAll()
        notificationRow.removeAll()
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
        print(sections[indexPath.section][indexPath.row])
        print(indexPath.row)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowNotificationSegue") {
            let viewController = segue.destination as! NotificationViewController
            
            let section = self.tableView.indexPathForSelectedRow?.section
            let row = self.tableView.indexPathForSelectedRow?.row
            if section == 0 {
                viewController.itemId = lostRowKeys[row!]
            } else if section == 1 {
                viewController.itemId = foundRowKeys[row!]
            }
        } else if (segue.identifier == "UpdateReportItemSegue") {
            _ = segue.destination as! ReportViewController
        } else if (segue.identifier == "Settings") {
            _ = segue.destination as! SettingsTableViewController
        }
    }
}

