//
//  LostSearchViewController.swift
//  iLost
//
//  Created by ak on 19.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

class LostSearchDetailViewController: UIViewController {
    var lostItem:ItemModel?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func notiyOwnerButtonPressed(_ sender: Any) {
    }
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var lostDateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            if let viewController = segue.destination as? ImageViewController {
                viewController.images = lostItem!.images
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

        guard let images = lostItem?.images else { return 0 }
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! LostItemCollectionViewCell

        guard let images = lostItem?.images else { return LostItemCollectionViewCell() }

        let row = indexPath.row
        let image = images[row]
        cell.imageView?.image = image

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ImageSegue", sender: nil)
    }
}
