//
//  InterfaceController.swift
//  SpotMark WatchKit Extension
//
//  Created by Lucas Fraga Schuler on 22/05/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

import WatchKit
import Foundation
import Parse

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    var lista : NSMutableArray! = NSMutableArray()
    
    @IBOutlet weak var img: WKInterfaceImage!
    // 1 - Create Rows
   // let titles = ["Apple Watch Sport", "Apple Watch", "Apple Watch Edition"]
   // let images = ["watch-0", "watch-1","watch-2"]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        //HANDOFF
        self.updateUserActivity("com.SpotMark.Handoff.events", userInfo: ["Event": "Veio do Handoff!"], webpageURL: nil)
        
        // Configure interface objects here.
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: .AllowAnimatedEmoji) { (results) -> Void in
            // Do something here...
        }
        
        self.loadParse()
    }
    
    func loadParse(){
       // Parse.enableDataSharingWithApplicationGroupIdentifier(“group.com.parse.parseuidemo”);
        // Setup Parse
        Parse.setApplicationId("7ySEIDHgB3RuHV5aD1xCXUm0FWfyF9MGS6Qi3NFx", clientKey: "UlA9Y5wpNe1nFWADy9jLmGCHCoPT1dnkIWdAJ2RN")
        var query = PFQuery(className:"Event")
        query.whereKey("members", equalTo: "959340524084525")
        query.orderByAscending("datetime")
        query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
            println(objects!.count);
            self.lista = NSMutableArray(array: objects!)
            self.loadTableView()
        })
    }
    
    func loadTableView(){
        // Set the number of rows in table
        table.setNumberOfRows(lista.count, withRowType: "WatchRow")
        
        // 3 - Create the rows
        for i in 0..<lista.count {
            if let row = table.rowControllerAtIndex(i) as? WatchRow {
                var event: PFObject = lista.objectAtIndex(i) as! PFObject
                row.titleLabel.setText(event["name"] as? String)
                var imageName = (event["category"]as? String)! + "1" + ".png"
                row.image.setImageNamed(imageName)
            }
        }
    }
  
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
       // if segueIdentifier == "gotoDetail" {
        //    let imgWatch = images[rowIndex]
          //  return imgWatch
        //}
        
        return lista.objectAtIndex(rowIndex)
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
