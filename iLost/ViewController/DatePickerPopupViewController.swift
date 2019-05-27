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

    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!

    @IBAction func doneButtonTapped(_ sender: Any) {
         performSegue(withIdentifier: "unwindToLostReportViewControllerWithSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        viewDatePicker.layer.cornerRadius = 10
        viewDatePicker.layer.masksToBounds = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToLostReportViewControllerWithSegue" {
            if let destVC = segue.destination as? LostReportViewController {
                destVC.lostItem.dateLost =  dateFromatter.createFormatedDateString(datePicker.date)
            }
        }
    }
}
