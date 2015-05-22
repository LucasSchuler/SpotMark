//
//  InterfaceController.swift
//  SpotMark WatchKit Extension
//
//  Created by Lucas Fraga Schuler on 22/05/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!

    // 1 - Create Rows
    let titles = ["Apple Watch Sport", "Apple Watch", "Apple Watch Edition"]
    let images = ["watch-0", "watch-1","watch-2"]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: .AllowAnimatedEmoji) { (results) -> Void in
            // Do something here...
        }
        
        
        // 2 - Set the number of rows in table
        table.setNumberOfRows(titles.count, withRowType: "WatchRow")
        
        // 3 - Create the rows
        for i in 0..<titles.count {
            if let row = table.rowControllerAtIndex(i) as? WatchRow {
               row.titleLabel.setText(titles[i])
            }
        }
       
    }

  
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "gotoDetail" {
            let imgWatch = images[rowIndex]
            return imgWatch
        }
        
        return nil
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
