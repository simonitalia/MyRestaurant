//
//  ViewController.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    //Property to receive / store MenuItem object from MenuTableVC to show details
    static var showAddToOrderButton: Bool!
    var menuItem: MenuItem!
    
    @IBOutlet weak var menuItemImage: UIImageView!
    @IBOutlet weak var menuItemPriceLabel: UILabel!
    @IBOutlet weak var menuItemNameLabel: UILabel!
    @IBOutlet weak var menuItemDetailLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        
        //Animate button when tapped
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                    //Scales x and y vales to x3 original size
            
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        //Add menuItem (object) to shared / static order (object)
        MenuController.order.menuItems.append(menuItem)
        print("Item/s in Order: \(MenuController.order.menuItems)")
        
        //Save order object to disk
//        Order.save()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        
        //Configure Navigation Bar
//        title = "\(menuItem.name)"
        
        //Show / hide Add to Order Button
        if ItemDetailViewController.showAddToOrderButton == true {
            
            //Round corners of Add to Order Button
            addToOrderButton.layer.cornerRadius = 5.0
            
        } else {
            addToOrderButton.isHidden = true
        }
        
        //Configure UI elements
        menuItemNameLabel.text = menuItem.name
        menuItemPriceLabel.text = String(format: "$%.2f", menuItem.price)
        menuItemDetailLabel.text = menuItem.detailText
        
        //Menu Item image
        MenuController.shared.fetchMenuItemImage(url: menuItem.imageURL) { (fetchedImage) in
            
            guard let image = fetchedImage else { return }
            
            DispatchQueue.main.async {
                self.menuItemImage.image = image
            }
        }
    }
}

