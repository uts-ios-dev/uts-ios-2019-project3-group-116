//
//  FoundSearchTableViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class FoundSearchTableViewController: UITableViewController {

    var foundItems = [ItemModel]()
    var foundItem = ItemModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        data()
    }

    func data(){
        foundItem.title = "title"
        foundItem.category = "Category"
        foundItem.dateLost = "18.05.2019"
        foundItem.description = "text text ..."
        foundItems.append(foundItem)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foundItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundSearchTableCell", for: indexPath) as! FoundSearchTableViewCell

        cell.titleLabel.text = foundItems[indexPath.row].title
        cell.categoryLabel.text  = foundItems[indexPath.row].category
        cell.dateLabel.text = foundItems[indexPath.row].dateLost

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoundSearchDetail" {
            if let destination = segue.destination as? LostSearchDetailViewController {
                if let indexpath = tableView.indexPathForSelectedRow?.row {
                    destination.lostItem = foundItems[indexpath]
                }
            }
        }
    }
}
