//
//  GlanceController.swift
//  SpotMark WatchKit Extension
//
//  Created by Lucas Fraga Schuler on 22/05/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

import WatchKit
import Foundation
import Parse

class GlanceController: WKInterfaceController {

    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var name: WKInterfaceLabel!
    @IBOutlet weak var local: WKInterfaceLabel!
    @IBOutlet weak var dateTime: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        Parse.setApplicationId("7ySEIDHgB3RuHV5aD1xCXUm0FWfyF9MGS6Qi3NFx", clientKey: "UlA9Y5wpNe1nFWADy9jLmGCHCoPT1dnkIWdAJ2RN")
        var query = PFQuery(className:"Event")
        query.whereKey("members", equalTo: "959340524084525")
        query.orderByAscending("datetime")
        query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
            var lista : NSMutableArray! = NSMutableArray(array: objects!)
            var event: PFObject = lista.objectAtIndex(0) as! PFObject
            self.name.setText(event["name"] as? String)
            self.local.setText(event["local"] as? String)
            self.dateTime.setText(event["datetime"] as? String)
            self.image.setImageNamed(event["category"] as? String)
        })
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
