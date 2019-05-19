//
//  MapLostViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
// Resource: https://www.dropbox.com/sh/dusb8mqn3szbnv8/AADEi1SV1nzVOQtaiawoHb47a/User-Location?dl=0&preview=MapScreen.swift&subfolder_nav_tracking=1

import UIKit
import MapKit
import CoreLocation

class MapLostViewController: UIViewController {
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SegueToLostViewController", sender: self)
    }

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 2500
    var lostItem: LostItemModel?

    @IBOutlet weak var mapView: MKMapView!

    @IBAction func addPinGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
//            annotation.title = "Title "
//            annotation.subtitle = "Subtitle"
            lostItem?.lostLocationsCoordinates.append(annotation.coordinate)

            self.mapView.addAnnotation(annotation)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        mapView.delegate = self

        if let lostItem = lostItem {
            for locationCoordinates in lostItem.lostLocationsCoordinates {
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCoordinates
                self.mapView.addAnnotation(annotation)
            }
        }

    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "SegueToLostViewController" {
            if let destination = segue.destination as? LostViewController {
                destination.lostItem = lostItem!
            }
        }
    }
}

extension MapLostViewController: CLLocationManagerDelegate {

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
//    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapLostViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped")
        if let annotation = view.annotation {
             mapView.removeAnnotation(annotation)
            lostItem?.lostLocationsCoordinates.removeAll(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude } )
        }
    }
}
