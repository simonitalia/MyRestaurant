//
//  MenuTableViewController.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import UIKit

class CategoryItemsTableViewController: UITableViewController {
    
    //Property to store category object passed from CategoryTableVC
    var category: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category.capitalized
        fireFetchMenuItems()
        
    }
    
    func fireFetchMenuItems() {
        
        //Fetch Menu items JSON Data from API end point
        MenuController.shared.fetchMenuItems(forCategory: category) { (fetchedMenuItems, error) in
            if let menuItems = fetchedMenuItems {
                self.updateUI(with: menuItems)
                print("Fetched Category Menu Items: \(menuItems)")
            
            } else {
                if let error = error {
                    self.showErrorAlert(error)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuController.menuItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath)

        let menuItem = MenuController.menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name.capitalized
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        
        //Fetch and load menuItem image from menuItem.url
        MenuController.shared.fetchMenuItemImage(url: menuItem.imageURL) { (fetchedImage) in
            
            guard let image = fetchedImage else { return }
            
            //Update cell image to fecthedImage via main thread
            DispatchQueue.main.async {
                
                //Ensure wrong image isn't inserted into a recycled cell
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                    
                    //If current cell index and table index don't match, exit method
                    currentIndexPath != indexPath {
                    return
                }
                
                //Set cell image
                cell.imageView?.image = image
                
                //Update cell layout to accommodate image
                cell.setNeedsLayout()
            }
        }

        return cell
    }
    
    //Override default cell height of 44
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        return 45    }
    
    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            MenuController.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    
    //Pass Menu Item Data to MenuItemDetailTableVC via Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CategoryItemsToItemDetailVC" {
            let vc = segue.destination as! ItemDetailViewController
            let indexOfRowTapped = tableView.indexPathForSelectedRow!.row
            vc.menuItem = MenuController.menuItems[indexOfRowTapped]
            
            //Update Add to Order Button flag
            ItemDetailViewController.showAddToOrderButton = true
        }
    }
    
    //Error alert in case of issues fetching Menu Items from server
    func showErrorAlert(_ error: Error) {
        
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Try again?", style: .default, handler: {
                action in self.fireFetchMenuItems()
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(ac, animated: true)
        }
    }
}
