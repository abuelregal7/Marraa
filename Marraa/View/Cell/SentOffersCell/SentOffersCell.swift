//
//  SentOffersCell.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class SentOffersCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(offer:Offer){
        self.img.setImageWith(offer.img.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
        self.title.text = offer.title
        self.userName.text = offer.toUserName
    }
    
    override func prepareForReuse() {
        self.img.image = nil
    }
}
