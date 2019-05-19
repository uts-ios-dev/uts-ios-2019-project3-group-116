//
//  LostViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LostReportViewController: UIViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    var images = [UIImage]()
    var imagePicker: ImagePickerHelper!
    var locationsCoordinates = [CLLocationCoordinate2D]()
    var lostItem = LostItemModel()
    var firebase = FirebaseHelper()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 2500
   

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let category = categoryTextField.text {
             lostItem.category = category
        }
        if let date = dateTextField.text {
            lostItem.dateLost = date
        }
        if let description = descriptionTextView.text {
            lostItem.description = description
        }
        firebase.saveItemDescription(item: lostItem)

        if let image = images.first {
            guard let data = image.jpegData(compressionQuality: CGFloat(0.0)) else { return }
            firebase.saveImage(data: data, item: "Item1", fileName: "Image1")
        }

    }
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBAction func addImagePressed(_ sender: Any) {
         self.imagePicker.present(view: sender as! UIView)
    }

    @IBAction func UnwindToLostViewController(segue: UIStoryboardSegue) {
        print(lostItem.lostLocationsCoordinates.count)

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        checkLocationServices()
        mapView.delegate = self

    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LostReportViewController: ImagePickerDelegate {
    func selectedImage(image: UIImage?) {
        guard let image = image else { return }
         self.images.append(image)
         imagesCollectionView.reloadData()
    }
}

extension LostReportViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1     //return number of sections in collection view
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! LostItemCollectionViewCell

        let image = images[indexPath.row]

        cell.imageView.image = image

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      performSegue(withIdentifier: "ImageSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            if let viewController = segue.destination as? ImageViewController {
                 viewController.images = images
            }
        }

        if segue.identifier == "MapSegue" {
            if let viewController = segue.destination as? MapLostViewController {
                viewController.lostItem = lostItem
            }
        }

    }
}

extension LostReportViewController {
    @IBAction func addPinGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            //            annotation.title = "Title "
            //            annotation.subtitle = "Subtitle"
            lostItem.lostLocationsCoordinates.append(annotation.coordinate)

            self.mapView.addAnnotation(annotation)
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
}

extension LostReportViewController: CLLocationManagerDelegate {

    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        guard let location = locations.last else { return }
    //        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
    //        mapView.setRegion(region, animated: true)
    //    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension LostReportViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped")
        if let annotation = view.annotation {
            mapView.removeAnnotation(annotation)
            lostItem.lostLocationsCoordinates.removeAll(where: { $0.latitude == annotation.coordinate.latitude && $0.longitude == annotation.coordinate.longitude } )
        }
    }
}


