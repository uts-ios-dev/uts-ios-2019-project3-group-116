//
//  ImagePicker.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import Foundation
import UIKit


public protocol ImagePickerDelegate: class {
    func selectedImage(image: UIImage?)
}

class ImagePickerHelper: NSObject {

    let imagePickerController = UIImagePickerController()
    var presentationController: UIViewController?
    var delegate: ImagePickerDelegate?

    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        super.init()
        self.imagePickerController.delegate = self
        self.presentationController = presentationController
        self.delegate = delegate
    }

// Resource: "App Development with Swift"

   func present(view: UIView) {
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                action in
                    self.imagePickerController.sourceType = .camera
                    self.presentationController?.present(self.imagePickerController, animated: true,
                                 completion: nil)
            })
            alertController.addAction(cameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photolibrary", style: .default, handler: { action in
                self.imagePickerController.sourceType = .photoLibrary
                self.presentationController?.present(self.imagePickerController, animated: true,
                             completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
         self.presentationController?.present(alertController, animated: true, completion: nil)
    }
}

//Resource: https://stackoverflow.com/questions/51342028/cannot-subscript-a-value-of-type-string-any-with-an-index-of-type-uiimage

extension ImagePickerHelper: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        delegate?.selectedImage(image: selectedImage)
        self.presentationController?.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerHelper: UINavigationControllerDelegate {
}
