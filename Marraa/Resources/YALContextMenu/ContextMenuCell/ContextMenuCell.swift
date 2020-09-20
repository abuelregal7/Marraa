//
//  Cell.swift
//  SwiftContextMenu
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

class ContextMenuCell : UITableViewCell, YALContextMenuCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func animatedIcon() ->  UIView{
    return self.menuImageView;
        
    }
    
    func animatedContent() ->  UIView{
        return self.menuTitleLabel;
    }
}
