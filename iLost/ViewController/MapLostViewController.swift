//
//  MapLostViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapLostViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}

extension MapLostViewController: CLLocationManagerDelegate {

}
