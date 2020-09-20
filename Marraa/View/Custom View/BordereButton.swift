//
//  BordereButton.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class BordereButton: UIButton {
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 0.2862745098, green: 0.6784313725, blue: 0.9137254902, alpha: 1) {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = borderColor.cgColor
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = borderColor.cgColor
    }
}
