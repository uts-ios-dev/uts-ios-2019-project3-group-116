//
//  AddImageCollectionViewCell.swift
//  iLost
//
//  Created by ak on 27.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

protocol AddImageCollectionViewDelegate {
    func addImage()
}


class AddImageCollectionViewCell: UICollectionViewCell {

    var delegate: AddImageCollectionViewDelegate?
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.addImage()
    }
}
