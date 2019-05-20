//
//  ImageViewController.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.


import UIKit

class ImageViewController: UIViewController {
    var images:[UIImage]?
    var currentImage = 0

    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func xButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image =  images?[currentImage]
        setupPageControl()
        addSwipeGesture()
    }

    func setupPageControl() {
        pageControl.currentPage = currentImage
        pageControl.numberOfPages = images!.count
        pageControl.hidesForSinglePage = true
    }

// Resource : https://stackoverflow.com/questions/38529775/how-to-create-a-side-swiping-photo-gallery-in-swift-ios

    func addSwipeGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector (respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }

   @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == images!.count - 1 {
                    currentImage = 0
                }else{
                    currentImage += 1
                }
            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = images!.count - 1
                }else{
                    currentImage -= 1
                }
            default:
                break
            }
             imageView.image = images![currentImage]
             pageControl.currentPage = currentImage
        }
    }
}

extension ImageViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
