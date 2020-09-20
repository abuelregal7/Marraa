//
//  UserPostsCell.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class UserPostsCell: UITableViewCell {

    @IBOutlet weak var adPictureImageView: UIImageView!
    @IBOutlet weak var adCategoryLabel: UILabel!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adLocationLabel: UILabel!
    @IBOutlet weak var adPriceLabel: UILabel!
    @IBOutlet weak var adDateLabel: UILabel!
    
    func configureCell(adModel:AdModel){
        self.adPictureImageView.setImageWith(adModel.picture.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        self.adCategoryLabel.text = adModel.category
        self.adTitleLabel.text = adModel.title
        self.adLocationLabel.text = adModel.location
        self.adPriceLabel.text = "\(adModel.price) ريال"
        self.adDateLabel.text = "\(adModel.date)"
    }
    
    override func prepareForReuse() {
        self.adPictureImageView.image = nil
    }
}
