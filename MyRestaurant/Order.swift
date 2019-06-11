//
//  Category.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import Foundation

struct Order: Codable  {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
    
}
