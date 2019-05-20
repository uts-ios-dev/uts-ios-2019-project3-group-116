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
