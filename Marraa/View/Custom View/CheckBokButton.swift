//
//  CheckBokButton.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {
    
    let checkedImage = #imageLiteral(resourceName: "select box")
    let unCheckedImage = #imageLiteral(resourceName: "unselect box")
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(unCheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(TapBtn(_:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func TapBtn(_ sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
