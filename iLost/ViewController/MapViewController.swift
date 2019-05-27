//
//  MapViewController.swift
//  iLost
//
//  Created by ak on 27.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    @IBAction func doneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLostReportViewControllerFromMap", sender: self)
    }
    @IBOutlet weak var mapView: MKMapView!
    var map:MapHelper?
    var locationsCoordinates: [CLLocationCoordinate2D]?

    override func viewDidLoad() {
        super.viewDidLoad()
        map = MapHelper(mapView: mapView)
        map?.lostLocationsCoordinates = locationsCoordinates!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToLostReportViewControllerFromMap" {
            if let destVC = segue.destination as? LostReportViewController {
                destVC.locationsCoordinates = map!.lostLocationsCoordinates
            }
        }
    }
}

