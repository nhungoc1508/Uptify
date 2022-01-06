//
//  CustomButton.swift
//  Uptify
//
//  Created by Ngoc Hoang on 06/01/2022.
//

import UIKit

class CustomButton: UIButton {
    
    private let cornerRadius: CGFloat = 30
    private var imageLayer: CALayer!
    private var shadowLayer: CALayer!
    
    override func draw(_ rect: CGRect) {
        addShadowsLayers(rect)
    }
    
    private func addShadowsLayers(_ rect: CGRect) {
        // Add Image
        if self.imageLayer == nil {
            let imageLayer = CALayer()
            imageLayer.frame = rect
            imageLayer.contents = UIImage(named: "Rectangle")?.cgImage
            imageLayer.cornerRadius = cornerRadius
            imageLayer.masksToBounds = true
            layer.insertSublayer(imageLayer, at: 0)
            self.imageLayer = imageLayer
        }
        
        // Set the shadow
        if self.shadowLayer == nil {
            let shadowLayer = CALayer()
            shadowLayer.masksToBounds = false
            shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
            shadowLayer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = 15
            shadowLayer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
            layer.insertSublayer(shadowLayer, at: 0)
            self.shadowLayer = shadowLayer
        }
    }
}
