//
//  SearchViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var searchLost = true
    var lostItems = [ItemModel]()
    var foundItems = [ItemModel]()
    var searchResults = [ItemModel]()
    
    // UI elements
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setUpNavigationMenu()
        data()
        searchResults = lostItems
    }

    // Setup the top navigation menu and handles the switching between lost and found search
    private func setUpNavigationMenu() {
        let navigationMenu = CustomDropDownMenu.setup(items: ["Search Lost Item", "Search Found Item"])
        navigationMenu.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self!.searchResults.removeAll()
            if (indexPath == 0) {
                self!.searchLost = true
                self!.searchResults = self!.lostItems
            } else if (indexPath == 1) {
                self!.searchLost = false
                self!.searchResults = self!.foundItems
            }
            self!.tableView.reloadData()
        }
        navigationItem.titleView = navigationMenu
    }
    
    // Dummy data
    func data(){
        // TODO load found items to array foundItems
        // TODO load lost items to array lostItems
    
        let item = ItemModel()
        item.title = "title"
        item.category = "Category"
        item.dateLost = "18.05.2019"
        item.description = "text text ..."
        let image = UIImage(named: "cat")
        item.images = [image!,image!,image!,image!]
        lostItems.append(item)
        
        let item2 = ItemModel()
        item2.title = "sss"
        item2.category = "djhd"
        item2.dateLost = "14.5.2018"
        item2.description = "wkjdhskhhdsjkhfjhdsf"
        foundItems.append(item2)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchDetail" {
            if let destination = segue.destination as? LostSearchDetailViewController {
                if let indexpath = tableView.indexPathForSelectedRow?.row {
                    destination.item = lostItems[indexpath]
                }
            }
        }
    }
}

// 
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostSearchTableCell", for: indexPath) as! SearchTableViewCell
        
        cell.titleLabel.text = searchResults[indexPath.row].title
        cell.searchImageView.image = searchResults[indexPath.row].images?.first
        cell.categoryLabel.text  = searchResults[indexPath.row].category
        cell.dateLabel.text = searchResults[indexPath.row].dateLost
        
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1)
        }
        
        return cell
    }
}
