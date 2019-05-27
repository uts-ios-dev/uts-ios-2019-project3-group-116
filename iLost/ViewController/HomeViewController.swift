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
        
        print("---------")
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeader[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableCell", for: indexPath)
    
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        return cell
    }
}

