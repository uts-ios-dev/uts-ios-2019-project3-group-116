//
//  FoundReportViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import MapKit

class FoundReportViewController: UIViewController {

    var map:MapHelper?
    var locationsCoordinates = [CLLocationCoordinate2D]()

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        addLongTapGesture()
         map = MapHelper(delegate: self, mapView: mapView)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        let category = categoryTextField.text
        let title = titleTextField.text
        let date = dateTextField.text
        if (category?.isEmpty)! || (title?.isEmpty)! || (date?.isEmpty)!{
            showAlert()
        }
    }
    func showAlert() {
        let alert = UIAlertController(title: "Incomplete Data", message: "Please fill all the textboxes", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FoundReportViewController {
    func addLongTapGesture(){
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(addPinGesture))
        view.addGestureRecognizer(longTap)
    }

    @objc func addPinGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            map!.setAnnotationWithLongPress(sender: sender)
        }
    }
}

extension FoundReportViewController: MapViewDelegate {
    func annotationRemove(lostLocationsCoordinates: [CLLocationCoordinate2D]) {
        locationsCoordinates = lostLocationsCoordinates
        print("delegate annot remvove")
    }

    func annotaionSet(lostLocationsCoordinates: [CLLocationCoordinate2D]) {
        locationsCoordinates = lostLocationsCoordinates
        print("delegate annot Set")
    }
}
