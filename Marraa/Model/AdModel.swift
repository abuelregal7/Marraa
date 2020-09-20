//
//  AdModel.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import Foundation

class AdModel {
    var id:Int
    var date:String
    var title:String
    var price:String
    var location:String
    var picture:String
    var category:String
    var images:[String]
    var isFlipped = false
    
    init(id:Int,date:String,title:String, price:String,location:String , picture:String,category:String , images: [String]) {
        self.id = id
        self.date = date
        self.title = title
        self.price = price
        self.location = location
        self.picture = picture
        self.category = category
        self.images = images
    }
}
