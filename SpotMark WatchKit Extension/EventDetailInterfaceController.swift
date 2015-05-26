//
//  EventDetailInterfaceController.swift
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 22/05/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

import WatchKit
import Foundation
import Parse

class EventDetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var name: WKInterfaceLabel!
    @IBOutlet weak var local: WKInterfaceLabel!
    @IBOutlet weak var dateTime: WKInterfaceDate!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        //HANDOFF
        self.updateUserActivity("com.SpotMark.Handoff.eventsDetail", userInfo: ["OneEvent": "Veio do Handoff!"], webpageURL: nil)
        
        if let event = context as? PFObject {
            setTitle("Event")
            self.name.setText(event["name"]as? String)
            self.local.setText(event["local"]as? String)
            var imageName = (event["category"]as? String)! + ".png"
            self.image.setImageNamed(imageName)
//            let datetime = event["datetime"]!.componentsSeparatedByString(" ")
//           //self.imgWatch.setImageNamed(imgWatchName)
//            self.name.setText("name")
        }
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

}
