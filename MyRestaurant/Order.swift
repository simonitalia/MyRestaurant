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
    
    static func save() {
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(MenuController.order) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "order")
            
        } else {
            print("Failed to save Order object to user defaults")
        }
    }
    
    static func load() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "order") as? Data {
            
            let jsonDecoder = JSONDecoder()
            
            do {
                MenuController.order = try jsonDecoder.decode(Order.self, from: data)
            
            } catch {
                print("Failed to load order object from user defaults with error: \(error.localizedDescription)")
            }
        }
    }
}
