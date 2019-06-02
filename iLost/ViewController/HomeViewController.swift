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

    // UI elements
    @IBOutlet weak var tableView: UITableView!
    var vSpinner: UIView?
    
    //Dummy Data
    var sectionHeader = ["Lost Item", "Found Item", "Notification"]
    var row = ["Item1","Item2"]
    var lostRow = [String]()
    var foundRow = [String]()
    var sections:[[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showSpinner(onView: self.view)
        
        Database.database().reference().child("items").observe(.value, with: { (snapshot) in
            if let test = snapshot.value as? [String:AnyObject] {
                for child in test {
                    let value = child.value as? NSDictionary
                    let user = value?["User"] as? String ?? ""
                    let uid = Auth.auth().currentUser?.uid
                    if user == uid {
                        let title = value?["title"] as? String ?? ""
                        let dateFound = value?["dateFound"] as? String ?? ""
                        if dateFound == "" {
                            self.lostRow.append(title)
                            //let item = ItemModel(description: description, category: category, dateLost: dateLost, dateFound: dateFound, images: nil)
                        } else {
                            self.foundRow.append(title)
                        }
                    }
                }
//                print(self.lostRow)
//                self.sections = [self.lostRow, self.row, self.row]
//                self.tableView.delegate = self
//                self.tableView.dataSource = self
                self.sections = [self.lostRow, self.foundRow, self.row]
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.removeSpinner()
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        if let username = firebase.getUserName() {
            print(username)
        }
        
    }

    // Switch to Login Scene after logout process was successful
    @IBAction func logoutButtonPressed(_ sender: Any) {
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
        header.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.sections[section].count
//        return lostRow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableCell", for: indexPath)

        cell.textLabel?.font = UIFont(name:"Verdana", size:15)
        cell.textLabel?.textColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor.white
        }
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeViewTableCell")!
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
//        cell.textLabel?.text = lostRow[indexPath.row]
        return cell
    }
}

