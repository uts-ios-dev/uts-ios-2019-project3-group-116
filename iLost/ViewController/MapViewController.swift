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
    var map:MapHelper?
    var locationsCoordinates: [CLLocationCoordinate2D]?
    
    // UI elements
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map = MapHelper(mapView: mapView)
        map?.lostLocationsCoordinates = locationsCoordinates!
    }
    
    // Closes map view and returns to report view after date is picked
    @IBAction func doneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToReportViewControllerFromMap", sender: self)
    }

    // Passes the selected location to the report view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToReportViewControllerFromMap" {
            if let destVC = segue.destination as? ReportViewController {
                destVC.locationsCoordinates = map!.lostLocationsCoordinates
            }
        }
    }
}

