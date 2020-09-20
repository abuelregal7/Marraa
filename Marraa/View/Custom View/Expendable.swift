//
//  Expendable.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggelSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UIGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggelSection(header: self, section: cell.section)
    }
    
    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        
        l = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-40, height: 90))
        l!.text = title
        l!.numberOfLines = 0
        l!.textAlignment = .right
        l!.backgroundColor = UIColor.clear
        self.l!.font = UIFont(name: "Cairo-SemiBold", size: 16)
        self.l!.textColor = UIColor.white
        self.addSubview(l!)
        self.l!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
        self.l!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        self.l!.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.section = section
        self.delegate = delegate
    }
    
    var l :UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 15.0
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.5137254902, blue: 0.7647058824, alpha: 1)
    }
}
