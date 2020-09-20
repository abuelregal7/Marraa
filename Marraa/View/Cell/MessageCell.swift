//
//  MessageCell.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var msgLabel: PaddedLabel!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(msg:Msg) {
        if  msg.type == "my_message" {
            msgLabel.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.6784313725, blue: 0.9137254902, alpha: 1)
            msgLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            trailing.priority = UILayoutPriority(rawValue: 250)
            leading.priority = UILayoutPriority(rawValue: 750)
        } else {
            msgLabel.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            msgLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            trailing.priority = UILayoutPriority(rawValue: 750)
            leading.priority = UILayoutPriority(rawValue: 250)
        }
        
        msgLabel.layer.masksToBounds = true
        msgLabel.layer.cornerRadius = 20
        msgLabel.text = msg.msg
    }
}
