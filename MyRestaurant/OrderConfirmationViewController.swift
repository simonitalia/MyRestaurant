//
//  OrderConfirmationViewController.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/10/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import UIKit
import UserNotifications

class OrderConfirmationViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    static var center = UNUserNotificationCenter.current()
    
    @IBOutlet weak var prepTimeRemainingLabel: UILabel!
    
    //Reset Button tapped actions
    @IBAction func resetButtonTapped(_ sender: Any) {
        
        //Reset root view controller Order Tab to ensure user is sent back root VC if navigating back to Order tab after a Reset button on this VC has been tapped
        navigationController?.popToRootViewController(animated: false)
    }
    
    
    //IBOutlet for usewr to subscribe to local notifications
    @IBAction func registerLocalButtonTapped(_ sender: Any) {
        
        //Reequest user permission for notifications
//        let notificationCenter = UNUserNotificationCenter.current()
        OrderConfirmationViewController.center.requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("Permission to receive notifications granted")
                
                //Schedule Local Notificaiton
                self.scheduleLocalNotification()
                
            } else {
                print("Permission to receive notifications denied!")
            }
        }
    }
    
    //Property to receive Order minutes from OrderTableVC
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
    
    //Mark: - Schedule Local Notificaitons for Order Prep time
    func scheduleLocalNotification() {
        
        //Call method to display Notification Action Button
        registerCategories()
        
//        let notificationCenter = UNUserNotificationCenter.current()
        
        //Interval based trigger (4 minutes before order is ready)
        let interval: TimeInterval = 10
            //In seconds
//        let minutesReminder = (minutes - minutes) + 240
//        interval = TimeInterval(minutesReminder)
        
        //Configure notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Order Update"
        notificationContent.body = "Your order will be ready in \(String(format: "%.0f", interval)) minutes."
        notificationContent.categoryIdentifier = "reminder"
        notificationContent.userInfo = ["customData": "fizzbuzz"]
        notificationContent.sound = UNNotificationSound.default
        
        //Trigger for Alert
        let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        ////Configure request with calendar based trigger
        let timeIntervalNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: timeIntervalTrigger)
        OrderConfirmationViewController.center.add(timeIntervalNotificationRequest)
    }
    
    //Setup Notification Action Button
    func registerCategories() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        let showNotificationAction = UNNotificationAction(identifier: "showAction", title: "Snooze", options: .foreground)
        
        let notificationCategory = UNNotificationCategory(identifier: "reminder", actions:[showNotificationAction], intentIdentifiers: [])
        notificationCenter.setNotificationCategories([notificationCategory])
    }
}
