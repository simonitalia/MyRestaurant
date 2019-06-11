//
//  CategoryTableViewController.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuController.shared.fetchCategories { (fetchedCategories) in
            if let categories = fetchedCategories {
                MenuController.categories = categories
                self.updateUI(with: categories)
                print("Fetched Categories: \(categories)")
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = MenuController.categories[indexPath.row]
        cell.textLabel?.text = category.capitalized
   
        return cell
    }
    
    func updateUI(with categories: [String]) {
        DispatchQueue.main.async {

            //Set My Order tab bar item badge 
            AppDelegate.myOrderTabBarItem.badgeValue = String(MenuController.order.menuItems.count)
            
            MenuController.categories = categories
            self.tableView.reloadData()
        }
    }
    
    //Pass Data to MenuTableVC via Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "CategoriesToCategoryItemsVC" {
            let vc = segue.destination as! CategoryItemsTableViewController
            let indexOfRowTapped = tableView.indexPathForSelectedRow!.row
            vc.category = MenuController.categories[indexOfRowTapped]
        }
    }
    
    //Setup unwind method, to navigate user back this VC when user dismisses OrderConfirmation VC
    @IBAction func unwindToCategoriesTableVC(segue: UIStoryboardSegue) {
        
        //Clear out order object / data
        if segue.identifier == "DismissOrderConfirmationVC" {
            MenuController.order.menuItems.removeAll()
        }
        
    }
}
