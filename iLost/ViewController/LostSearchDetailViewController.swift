//
//  LostSearchViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class LostSearchDetailViewController: UIViewController {
    var item:ItemModel?
    var map:MapHelper?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDescriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        map = MapHelper(mapView: mapView)
        
        setupView()
    }

    func setupView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        map = MapHelper(mapView: mapView)
        
        descriptionTextView.text = item?.description
        dateLabel.text = item?.dateLost
        
    }
    
    @IBAction func notiyOwnerButtonPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            if let viewController = segue.destination as? ImageViewController {
                viewController.images = item!.images
                viewController.currentImage = collectionView.indexPathsForSelectedItems!.first!.row
            }
        }
    }
}

extension LostSearchDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1     //return number of sections in collection view
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let images = item?.images else { return 0 }
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ItemCollectionViewCell

        guard let images = item?.images else { return ItemCollectionViewCell() }

        let row = indexPath.row
        let image = images[row]
        cell.imageView?.image = image

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ImageSegue", sender: nil)
    }
}
