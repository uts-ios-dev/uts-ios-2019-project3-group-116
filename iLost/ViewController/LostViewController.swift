//
//  LostViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class LostViewController: UIViewController {
    var images = [UIImage]()
    var imagePicker: ImagePickerHelper!

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBAction func addImagePressed(_ sender: Any) {
         self.imagePicker.present(view: sender as! UIView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
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
    }
}

