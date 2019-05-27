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
    @IBOutlet weak var imagesCollectionView: UICollectionView!


    var images = [UIImage]()
    var imagePicker: ImagePickerHelper!
    var locationsCoordinates = [CLLocationCoordinate2D]()
    var lostItem = ItemModel()
    var firebase = FirebaseHelper()
    var map:MapHelper?


    //MARK: - Unwind
    @IBAction func unwindToLostReportViewController(segue: UIStoryboardSegue) {
        dateTextField.text = lostItem.dateLost
    }


    @IBAction func unwindToLostReportViewControllerFromMap(segue: UIStoryboardSegue) {
        map?.removeAllAnnotation()
        map?.lostLocationsCoordinates = locationsCoordinates
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        mapView.isUserInteractionEnabled = false
        map = MapHelper( mapView: mapView)
        setTapGetureOnDateTextField()
        addPlusImageToImages()
    }


    fileprivate func addPlusImageToImages() {
        if let image = UIImage(named: "plus"){
            images.append(image)
        }
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

        if indexPath.row == images.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
            let image = images[indexPath.row]
            cell.imageView.image = image
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! LostItemCollectionViewCell
            let image = images[indexPath.row]
            cell.imageView.image = image
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(indexPath.row == images.count - 1) {
            performSegue(withIdentifier: "ImageSegue", sender: nil)
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            if let viewController = segue.destination as? ImageViewController {
                var imagesTemp = images
                imagesTemp.removeLast(1)
                viewController.images = imagesTemp
                viewController.currentImage = imagesCollectionView.indexPathsForSelectedItems!.first!.row
            }
        }

        if segue.identifier == "MapSegue" {
            if let viewController = segue.destination as? MapViewController {
                viewController.locationsCoordinates = map!.lostLocationsCoordinates
            }
        }
    }
}


extension LostReportViewController: DeleteImageCollectionViewDelegate {
    func deleteImage(indexPath: IndexPath) {
        images.remove(at: indexPath.row)
        imagesCollectionView.reloadData()
    }
}


extension LostReportViewController: AddImageCollectionViewDelegate {
    func addImage() {
          self.imagePicker.present(view: self.view)
    }
}


extension LostReportViewController: ImagePickerDelegate {
    func selectedImage(image: UIImage?) {
        guard let image = image else { return }
        // self.images.append(image)
        self.images.insert(image, at: 0)
        imagesCollectionView.reloadData()
    }
}


// MARK: - Gestures
extension LostReportViewController {

    fileprivate func setTapGetureOnDateTextField() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(performSegueSetDate))
        dateTextField.isUserInteractionEnabled = true
        dateTextField.addGestureRecognizer(tapGesture)
    }


    @objc func performSegueSetDate(){
        performSegue(withIdentifier: "SetDateSegue", sender: nil)
    }


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


    @IBAction func mapButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "MapSegue", sender: nil)
    }
}
