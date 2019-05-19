//
//  LostViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import CoreLocation


class LostViewController: UIViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    var images = [UIImage]()
    var imagePicker: ImagePickerHelper!
    var locationsCoordinates = [CLLocationCoordinate2D]()
    var lostItem = LostItemModel()
    var firebase = FirebaseHelper()

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
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LostViewController: ImagePickerDelegate {
    func selectedImage(image: UIImage?) {
        guard let image = image else { return }
         self.images.append(image)
         imagesCollectionView.reloadData()
    }
}

extension LostViewController: UICollectionViewDelegate, UICollectionViewDataSource {

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

