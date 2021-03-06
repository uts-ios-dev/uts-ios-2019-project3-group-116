//
//  MapHelper.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//


import Foundation

import CoreLocation
import MapKit

class MapHelper: NSObject {
    var mapView:MKMapView?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 2500
    var lostLocationsCoordinates = [CLLocationCoordinate2D]() {
        didSet {
            setAnnotation()
        }
    }

    init(mapView: MKMapView) {
        super.init()
        self.mapView = mapView
        self.checkLocationServices()
        self.mapView!.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPinGesture))
        mapView.addGestureRecognizer(longTapGesture)
    }
}

extension MapHelper {
    @IBAction func addPinGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView?.convert(location, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate!
            //            annotation.title = "Title "
            //            annotation.subtitle = "Subtitle"
            lostLocationsCoordinates.append(annotation.coordinate)
            self.mapView?.addAnnotation(annotation)
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView?.setRegion(region, animated: true)
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
            mapView?.showsUserLocation = true
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
        default:
            print("error")
        }
    }

    func setAnnotation() {
        for locationCoordinate in lostLocationsCoordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            self.mapView!.addAnnotation(annotation)
        }
    }

    func removeAllAnnotation(){
        let allAnnotations = self.mapView!.annotations
        self.mapView!.removeAnnotations(allAnnotations)
    }
}

extension MapHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapHelper: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped")
        if let annotation = view.annotation {
            mapView.removeAnnotation(annotation)
            lostLocationsCoordinates.removeAll(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude } )
        }
    }
}
