//
//  NetworkController.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

//Manages networking requests to remote server and retrieves menu (JSON)  data
import Foundation
import UIKit

class MenuController {
    
    //Static propeties to share objects across the app's VCs
    static let shared = MenuController()
    static var categories = [String]()
    static var menuItems = [MenuItem]()
    
    //Set Notification to inform OrderTableVC when order object changes
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdated")
    
    static var order = Order() {
        
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdateNotification, object: nil)
        }
    }
    
    let baseURL = URL(string: "http://127.0.0.1:8090/")!
    
    //MARK: - Methods to Fetch data from API end points
    func fetchCategories(completion: @escaping ([String]?, Error?) -> Void) {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        let task = URLSession.shared.dataTask(with: categoriesURL) {
            (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
                
                let categories = try? jsonDecoder.decode(Categories.self, from: data) {
                completion(categories.categories, nil)
                
            } else {
                if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    func fetchMenuItems(forCategory categoryName: String, completion: @escaping ([MenuItem]?, Error?) -> Void) {
        
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) {
            (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
            
                let menu = try? jsonDecoder.decode(Menu.self, from: data) {
                completion(menu.items, nil)
            
            } else {
                if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    //Fetch menu item images
    func fetchMenuItemImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
                
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    //Mark: - Method to Post data back to server
    func submitOrder(for menuIDs: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        
        //Modify Url from GET to POST
        var requestType = URLRequest(url: orderURL)
        requestType.httpMethod = "POST"
        requestType.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Set data object to POST and encode as JSON
        let data: [String: [Int]] = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        //Set data within URL body
        requestType.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: requestType) {
            (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
                
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
}




