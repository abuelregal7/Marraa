//
//  FeaturePostsCell.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class FeaturePostsCell: UICollectionViewCell {
    
    @IBOutlet weak var adPictureImageView: UIImageView!
    @IBOutlet weak var adCategoryLabel: UILabel!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adLocationLabel: UILabel!
    @IBOutlet weak var adPriceLabel: UILabel!
    
    func configureCell(adModel:AdModel){
        self.adPictureImageView.setImageWith(adModel.images[0].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        self.adCategoryLabel.text = adModel.category
        self.adTitleLabel.text = adModel.title
        self.adLocationLabel.text = adModel.location
        self.adPriceLabel.text = "\(adModel.price) ريال"
    }
    
    override func prepareForReuse() {
        self.adPictureImageView.image = nil
    }
}
