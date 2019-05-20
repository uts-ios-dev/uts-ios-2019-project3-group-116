//
//  LostSearchTableViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class LostSearchTableViewController: UITableViewController {

    var lostItems = [ItemModel]()
    var lostItem = ItemModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        data()
    }

    func data(){
        lostItem.title = "title"
        lostItem.category = "Category"
        lostItem.dateLost = "18.05.2019"
        lostItem.description = "text text ..."
        let image = UIImage(named: "cat")
        lostItem.images = [image!,image!,image!,image!]
        lostItems.append(lostItem)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lostItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostSearchTableCell", for: indexPath) as! LostSearchTableViewCell

        cell.titleLabel.text = lostItems[indexPath.row].title
        cell.lostImageView.image = lostItems[indexPath.row].images?.first
        cell.categoryLabel.text  = lostItems[indexPath.row].category
        cell.dateLabel.text = lostItems[indexPath.row].dateLost

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LostSearchDetail" {
            if let destination = segue.destination as? LostSearchDetailViewController {
                if let indexpath = tableView.indexPathForSelectedRow?.row {
                     destination.lostItem = lostItems[indexpath]
                }
            }
        }
    }
}
