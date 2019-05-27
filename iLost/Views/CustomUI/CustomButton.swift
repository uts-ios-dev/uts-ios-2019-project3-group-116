//
//  CustomButton.swift
//  iLost
//
//  Created by Camilla Gretsch on 26.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit

// Define layout of the button 
class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        setShadow()
        
        titleLabel?.font = UIFont(name: "Verdana", size: 30)
        setTitleColor(.white, for: .normal)
        
        backgroundColor = UIColor(red: 39/255, green: 159/255, blue: 238/255, alpha: 1)
        layer.cornerRadius = 20
        layer.borderWidth = 0
    }
    
    private func setShadow(){
        layer.shadowColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    public func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 3
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
