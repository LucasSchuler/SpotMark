//
//  NotificationController.swift
//  SpotMark WatchKit Extension
//
//  Created by Lucas Fraga Schuler on 22/05/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var notifyLabel: WKInterfaceLabel!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        
        notifyLabel.setText(localNotification["customKey"] as? String)
        
        completionHandler(.Custom)
    }
  }
