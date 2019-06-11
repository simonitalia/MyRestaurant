//
//  MenuItem.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import Foundation

//struct Category: Codable {
//    var label: String
//    
//}

struct Categories: Codable  {
    var categories: [String]

}

//Pull in each item from remote server and construct menu item object
struct MenuItem: Codable {
    
    let id: Int
    let name: String
    let detailText: String
    let price: Double
    let category: String
    let imageURL: URL
    
    //Map MenuItem properties to JSON Data Dictionary keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
            //Since "description" is a swift keyword, need to change the reference to it in the JSON, to detailText property
        case price
        case category
        case imageURL = "image_url"
    }
}

//Store each menu item object as collection of items / obejcts
struct Menu: Codable {
    
    var items: [MenuItem]
    
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
    
}
