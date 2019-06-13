//
//  MyOrderTableViewController.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    @IBOutlet weak var navBarSubmitButton: UIBarButtonItem!
    
    var orderMinutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Display Edit button on nav bar and set initial state
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load (if) any exitsing order data from disk / user defaults
//        Order.load()
        
        //Set initial nav bar button states
        updateNavBarButtonsState()
        
        //Respond to order object changes by triggering reload of table data
        NotificationCenter.default.addObserver(tableView as Any, selector: #selector(tableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
        
        //And Nav bar button items
        NotificationCenter.default.addObserver(self, selector: #selector(updateNavBarButtonsState), name: MenuController.orderUpdateNotification, object: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.order.menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)

        let menuItem = MenuController.order.menuItems[indexPath.row]
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
    
    // MARK: - Override methods to support conditional editing of the table view.
    
    //Enable deletion of table row/s
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Remove deleted table row/s from table dataSource
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            MenuController.order.menuItems.remove(at: indexPath.row)
            
            //Update order object saved on disk
//            Order.save()
        }

    }
    
    //Pass Menu Item Data to MenuItemDetailTableVC via Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Send user to ItemDetailVC
        if segue.identifier == "MyOrderToItemDetailVC" {
            let vc = segue.destination as! ItemDetailViewController
            let indexOfRowTapped = tableView.indexPathForSelectedRow!.row
            vc.menuItem = MenuController.order.menuItems[indexOfRowTapped]
            
            //Update Add to Order Button flag
            ItemDetailViewController.showAddToOrderButton = false
        }
        
        //Send user to OrderConfirmationVC
        if segue.identifier == "OrderToOrderConfirmationVC" {
            let vc = segue.destination as! OrderConfirmationViewController
            vc.minutes = orderMinutes
        }
    }
    
    @IBAction func navBarSubmitButtonTapped(_ sender: Any) {
        
        //Calculate Order Total
        let orderTotal = MenuController.order.menuItems.reduce(0.0) {
            (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        //Format orderTotal
        let formattedOrderTotal = String(format: "$%.2f", orderTotal)
        
        //Create Alert and display formatted orderTotal
        let ac = UIAlertController(title: "Confirm Your Order", message: "Submit Order. \nOrder Total: \(formattedOrderTotal)", preferredStyle: .alert)
        
        //Submit Order action button
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { action in
            self.postOrder()
        })
        
        //Dismiss Alert action butotn
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //Present Alert
        present(ac, animated: true, completion: nil)
    }
    
    func postOrder() {
        
        //Pull out just the IDs from the order, and sum u all the minutes for each menuID using map
        let menuIDs = MenuController.order.menuItems.map { $0.id }
        MenuController.shared.submitOrder(for: menuIDs) {
            (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "OrderToOrderConfirmationVC", sender: nil)
                }
            }
        }
    }
    
    @objc func updateNavBarButtonsState() {
        
        //Disabled state if no order/s exist
        if MenuController.order.menuItems.count == 0 {
            editButtonItem.isEnabled = false
            navBarSubmitButton.isEnabled = false
        
        //Enable state if order/s exist
        } else {
            editButtonItem.isEnabled = true
            navBarSubmitButton.isEnabled = true
        }
        
    }
    
}
