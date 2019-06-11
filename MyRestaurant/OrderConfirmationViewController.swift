//
//  OrderConfirmationViewController.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/10/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var prepTimeRemainingLabel: UILabel!
    
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
    }
    
    func updateUI() {
        
        //Hide back navigation bar item
        navigationItem.hidesBackButton = true
        
        prepTimeRemainingLabel.text = "Thanks for your order. Your order is estimated to be ready in \(minutes!) minutes."
    }
    
}
