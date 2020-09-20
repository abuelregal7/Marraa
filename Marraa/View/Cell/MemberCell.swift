//
//  MemberCell.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    func configureCell(adTitle:String,memberName:String){
       
        self.title.text = adTitle
        self.userName.text = memberName
    }
}
