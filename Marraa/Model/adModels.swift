//
//  adModels.swift
//  Marraa
//
//  Created by Khaled Ghoniem.
//  Copyright © 2019 Khaled Ghoniem. All rights reserved.
//

import Foundation

struct AdSelectTypes : Codable {
    let ad_type : [Ad_type]?
    let ad_cats : [Ad_cats]?
    let ad_currency : [Ad_currency]?
    let conditions : [Conditions]?
    let ad_warraty : [Ad_warraty]?
    let ad_price_type : Ad_price_type?
    
    enum CodingKeys: String, CodingKey {
        
        case ad_type = "ad_type"
        case ad_cats = "ad_cats"
        case ad_currency = "ad_currency"
        case conditions = "conditions"
        case ad_warraty = "ad_warraty"
        case ad_price_type = "ad_price_type"
    }
}

struct Conditions : Codable {
    let term_id : Int?
    let name : String?
    let slug : String?
    let term_group : Int?
    let term_taxonomy_id : Int?
    let taxonomy : String?
    let description : String?
    let parent : Int?
    let count : Int?
    let filter : String?
    
    enum CodingKeys: String, CodingKey {
        
        case term_id = "term_id"
        case name = "name"
        case slug = "slug"
        case term_group = "term_group"
        case term_taxonomy_id = "term_taxonomy_id"
        case taxonomy = "taxonomy"
        case description = "description"
        case parent = "parent"
        case count = "count"
        case filter = "filter"
    }
}

struct Ad_warraty : Codable {
    let term_id : Int?
    let name : String?
    let slug : String?
    let term_group : Int?
    let term_taxonomy_id : Int?
    let taxonomy : String?
    let description : String?
    let parent : Int?
    let count : Int?
    let filter : String?
    
    enum CodingKeys: String, CodingKey {
        
        case term_id = "term_id"
        case name = "name"
        case slug = "slug"
        case term_group = "term_group"
        case term_taxonomy_id = "term_taxonomy_id"
        case taxonomy = "taxonomy"
        case description = "description"
        case parent = "parent"
        case count = "count"
        case filter = "filter"
    }
}

struct Ad_type : Codable {
    let term_id : Int?
    let name : String?
    let slug : String?
    let term_group : Int?
    let term_taxonomy_id : Int?
    let taxonomy : String?
    let description : String?
    let parent : Int?
    let count : Int?
    let filter : String?
    
    enum CodingKeys: String, CodingKey {
        
        case term_id = "term_id"
        case name = "name"
        case slug = "slug"
        case term_group = "term_group"
        case term_taxonomy_id = "term_taxonomy_id"
        case taxonomy = "taxonomy"
        case description = "description"
        case parent = "parent"
        case count = "count"
        case filter = "filter"
    }
}

struct Ad_price_type : Codable {
    let fixed : String?
    let negotiable : String?
    let on_call : String?
    let auction : String?
    let free : String?
    let no_price : String?
    
    enum CodingKeys: String, CodingKey {
        
        case fixed = "Fixed"
        case negotiable = "Negotiable"
        case on_call = "on_call"
        case auction = "auction"
        case free = "free"
        case no_price = "no_price"
    }
}

struct Ad_currency : Codable {
    let term_id : Int?
    let name : String?
    let slug : String?
    let term_group : Int?
    let term_taxonomy_id : Int?
    let taxonomy : String?
    let description : String?
    let parent : Int?
    let count : Int?
    let filter : String?
    
    enum CodingKeys: String, CodingKey {
        
        case term_id = "term_id"
        case name = "name"
        case slug = "slug"
        case term_group = "term_group"
        case term_taxonomy_id = "term_taxonomy_id"
        case taxonomy = "taxonomy"
        case description = "description"
        case parent = "parent"
        case count = "count"
        case filter = "filter"
    }
}

struct Ad_cats : Codable {
    let term_id : Int?
    let name : String?
    let count : Int?
    let description : String?
    let child : [Child]?
    
    enum CodingKeys: String, CodingKey {
        
        case term_id = "term_id"
        case name = "name"
        case count = "count"
        case description = "description"
        case child = "child"
    }
}

struct Child : Codable {
    let term_id : Int?
    let name : String?
    let description : String?
    
    enum CodingKeys: String, CodingKey {
        
        case term_id = "term_id"
        case name = "name"
        case description = "description"
    }
}
