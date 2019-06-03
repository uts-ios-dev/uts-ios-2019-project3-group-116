//
//  DatePickerPopupViewController.swift
//  iLost
//
//  Created by ak on 27.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class DatePickerPopupViewController: UIViewController {
    var dateFromatter = DateFormatterHelper()
    
    // UI elements
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // Setup the date picker view layout
    func setupView(){
        viewDatePicker.layer.cornerRadius = 10
        viewDatePicker.layer.masksToBounds = true
    }
    
    // Closes date picker view and returns to report view after date is picked
    @IBAction func doneButtonTapped(_ sender: Any) {
         performSegue(withIdentifier: "unwindToLostReportViewControllerWithSegue", sender: self)
    }

    // Passes the selected date to the report view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToLostReportViewControllerWithSegue" {
            if let destVC = segue.destination as? ReportViewController {
                destVC.item.dateLost =  dateFromatter.createFormatedDateString(datePicker.date)
            }
        }
    }
}
