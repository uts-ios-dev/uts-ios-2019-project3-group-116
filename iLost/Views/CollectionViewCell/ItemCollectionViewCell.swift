//
//  LostItemCollectionViewCell.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

protocol DeleteImageCollectionViewDelegate {
    func deleteImage(indexPath: IndexPath)
}

class ItemCollectionViewCell: UICollectionViewCell {

    var delegate: DeleteImageCollectionViewDelegate?

    var indexPath: IndexPath?
    
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func xButtonTapped(_ sender: Any) {
        delegate?.deleteImage(indexPath: indexPath!)

    }
}
