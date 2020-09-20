//
//  GradientButton.swift
//  Golden Store
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {

    let gradientlayer = CAGradientLayer()
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1) {
        didSet {
            setGradient(topGradientColor: topColor, bottomGradientColor: bottomColor)
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.4274509804, green: 0.6980392157, blue: 1, alpha: 1) {
        didSet {
            setGradient(topGradientColor: topColor, bottomGradientColor: bottomColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
            gradientlayer.colors = [topColor.cgColor,bottomColor.cgColor]
            gradientlayer.startPoint = CGPoint(x: 1, y: 0)
            gradientlayer.endPoint = CGPoint(x: 0, y: 1)
            gradientlayer.frame = self.bounds
            self.layer.insertSublayer(gradientlayer, at: 0)
    }
    
    @IBInspectable var cornerRaduis: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRaduis
        }
    }
    
    override func awakeFromNib() {
        setView()
    }
    
    func setView() {
        self.layer.cornerRadius = cornerRaduis
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        gradientlayer.frame = self.bounds
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setView()
    }
}
