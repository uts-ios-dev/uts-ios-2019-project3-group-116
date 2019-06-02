//
//  SearchViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    var firebase = FirebaseHelper()
    var vSpinner: UIView?
    var searchLost = true
    var lostItems = [ItemModel]()
    var foundItems = [ItemModel]()
    var searchResults = [ItemModel]()
    
    // UI elements
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(onView: self.view)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setUpNavigationMenu()
        data()
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
        Database.database().reference().child("items").observe(.value, with: { (snapshot) in
            if let test = snapshot.value as? [String:AnyObject] {
                for child in test {
                    let value = child.value as? NSDictionary
                        let dateFound = value?["dateFound"] as? String ?? ""
                        let dateLost = value?["dateLost"] as? String ?? ""
                        if dateLost != "" && dateFound == "" {
                            self.lostItems.append(ItemModel(title: value?["title"] as? String ?? "", description: value?["description"] as? String ?? "", category: value?["category"] as? String ?? "", dateLost: dateLost, dateFound: "", images: [UIImage()]))
                        } else if dateFound != "" && dateLost == "" {
                           self.foundItems.append(ItemModel(title: value?["title"] as? String ?? "", description: value?["description"] as? String ?? "", category: value?["category"] as? String ?? "", dateLost: "", dateFound: dateFound, images: [UIImage()]))
                        }
                }
                self.searchResults = self.lostItems
                self.tableView.reloadData()
                self.removeSpinner()
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
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
