//
//  ViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var firebase = FirebaseHelper()

    // UI elements
    @IBOutlet weak var tableView: UITableView!
    
    //Dummy Data
    var sectionHeader = ["Lost Item", "Found Item", "Notification"]
    var row = ["Item1","Item2"]
    var sections:[[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sections = [row, row, row]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if let username = firebase.getUserName() {
            print(username)
        }
        
    }

    // Switch to Login Scene after logout process was successful
    @IBAction func logoutButtonPressed(_ sender: Any) {
        firebase.logOutUser()
        dismiss(animated: true, completion: nil)

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
    
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        return cell
    }
}

