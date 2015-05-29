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
    @IBOutlet weak var group: WKInterfaceGroup!
    
    @IBOutlet weak var text: WKInterfaceLabel!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to use
        
        super.willActivate()
        group.setBackgroundImageNamed("spotmark_")
      //  image.setImageNamed("spotmark_")
       group.startAnimatingWithImagesInRange(NSMakeRange(0,26), duration: 1, repeatCount: 1)
     //   image.startAnimatingWithImagesInRange(NSMakeRange(0,26), duration: 1, repeatCount: 1)
//        for i in 0...19{
//            image.setImageNamed("spotmark_\(i)@2x")
//        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
        
        notifyLabel.setText(localNotification.description)
      //  notifyLabel.setText("Test message")
        
        println(localNotification.description)
        
        completionHandler(.Custom)
    }
    
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: (WKUserNotificationInterfaceType) -> Void) {
        
        var strTitle = remoteNotification["aps"] as! [NSObject : AnyObject]
        var strTitle2 = strTitle["alert"] as! [NSObject : AnyObject]
        var strTitleAux = strTitle2["title"] as! String
         var body = strTitle2["body"] as! String
        
        notifyLabel.setText(strTitleAux)
        text.setText(body)
        
        completionHandler(.Custom)

        
        
    }
  }
