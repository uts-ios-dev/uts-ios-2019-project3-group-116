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
import BTNavigationDropdownMenu

class ReportViewController: UIViewController {
    var reportLost: Bool = true
    var images = [UIImage]()
    var imagePicker: ImagePickerHelper!
    var locationsCoordinates = [CLLocationCoordinate2D]()
    var item = ItemModel()
    var firebase = FirebaseHelper()
    var map:MapHelper?
    
    // UI elements
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var titleTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        mapView.isUserInteractionEnabled = false
        map = MapHelper( mapView: mapView)
        setTapGetureOnDateTextField()
        addPlusImageToImages()
        setUpNavigationMenu()
    }
    
    // Setup the top navigation menu and handles the switching between lost and found report
    private func setUpNavigationMenu() {
        let navigationMenu = CustomDropDownMenu.setup(items: ["Report Lost Item", "Report Found Item"])
        navigationMenu.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if (indexPath == 0) {
                self!.reportLost = true
            } else if (indexPath == 1) {
                self!.reportLost = false
            }
        }
        navigationItem.titleView = navigationMenu
    }
   
    // Add image to the image collection
    fileprivate func addPlusImageToImages() {
        if let image = UIImage(named: "plus"){
            images.append(image)
        }
    }
    
    // Unwind from date picker view to report view controller
    @IBAction func unwindToReportViewControllerFromDatePicker(segue: UIStoryboardSegue) {
        dateTextField.text = item.dateLost
    }
    
    // Unwind from map view to report view controller
    @IBAction func unwindToReportViewControllerFromMap(segue: UIStoryboardSegue) {
        map?.removeAllAnnotation()
        map?.lostLocationsCoordinates = locationsCoordinates
    }
    
    // Handles the map button
    @IBAction func mapButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "MapSegue", sender: nil)
    }
    
    // Handles the tap gesture on date text field
    fileprivate func setTapGetureOnDateTextField() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(performSegueSetDate))
        dateTextField.isUserInteractionEnabled = true
        dateTextField.addGestureRecognizer(tapGesture)
    }
    
    // Opens the date picker view 
    @objc func performSegueSetDate(){
        performSegue(withIdentifier: "SetDateSegue", sender: nil)
    }
    
    // Passes data to the image and map view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" { // Passes the current image to image view
            if let viewController = segue.destination as? ImageViewController {
                var imagesTemp = images
                imagesTemp.removeLast(1)
                viewController.images = imagesTemp
                viewController.currentImage = imagesCollectionView.indexPathsForSelectedItems!.first!.row
            }
        }
        
        if segue.identifier == "MapSegue" { // Passes the current locaion to map view
            if let viewController = segue.destination as? MapViewController {
                viewController.locationsCoordinates = map!.lostLocationsCoordinates
            }
        }
    }
    
    // Saves the report to the database
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if (checkMandatoryFields()) {
            item.title = titleTextfield.text!
            item.category = categoryTextField.text!
            item.description = descriptionTextView.text!
            item.images = images
            if (reportLost) {
                item.dateLost = dateTextField.text!
            } else {
                item.dateFound = dateTextField.text!
            }
            
            firebase.saveItemDescription(item: item)
            
//            if let image = images.first {
//                // guard let data = image.jpegData(compressionQuality: CGFloat(0.0)) else { return }
//                // firebase.saveImage(data: data, item: "Item1", fileName: "Image1")
//                firebase.saveImage(image: image, folderName: "items", fileName: "\(item.title)-1")
//            }
        }
    }
    
    // Checks if the report is ready to be saved
    private func checkMandatoryFields() -> Bool {
        if (categoryTextField.text!.isEmpty) || (titleTextfield.text!.isEmpty) || (dateTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Incomplete Data", message: "Please fill in all mandatory text fields!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

// Setup the collection view for images and handles to segues to image and map view
extension ReportViewController: UICollectionViewDelegate, UICollectionViewDataSource {

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ItemCollectionViewCell
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
}

// Deletes the selected image from the collection view
extension ReportViewController: DeleteImageCollectionViewDelegate {
    func deleteImage(indexPath: IndexPath) {
        images.remove(at: indexPath.row)
        imagesCollectionView.reloadData()
    }
}

// Adds an image to the collection view
extension ReportViewController: AddImageCollectionViewDelegate {
    func addImage() {
          self.imagePicker.present(view: self.view)
    }
}

// Handles the image selection process
extension ReportViewController: ImagePickerDelegate {
    func selectedImage(image: UIImage?) {
        guard let image = image else { return }
        self.images.insert(image, at: 0)
        imagesCollectionView.reloadData()
    }
}

//// MARK: - Gestures
//extension LostReportViewController {
//    
//    fileprivate func setTapGetureOnDateTextField() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(performSegueSetDate))
//        dateTextField.isUserInteractionEnabled = true
//        dateTextField.addGestureRecognizer(tapGesture)
//    }
//    
//    
//    @objc func performSegueSetDate(){
//        performSegue(withIdentifier: "SetDateSegue", sender: nil)
//    }
//    
//    
//    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
//        if let category = categoryTextField.text {
//            lostItem.category = category
//        }
//        if let date = dateTextField.text {
//            lostItem.dateLost = date
//        }
//        if let description = descriptionTextView.text {
//            lostItem.description = description
//        }
//        firebase.saveItemDescription(item: lostItem)
//        
//        if let image = images.first {
//            guard let data = image.jpegData(compressionQuality: CGFloat(0.0)) else { return }
//            firebase.saveImage(data: data, item: "Item1", fileName: "Image1")
//        }
//    }
//    
//    
//    @IBAction func mapButtonTapped(_ sender: Any) {
//        performSegue(withIdentifier: "MapSegue", sender: nil)
//    }
//}
