//
//  NextInterfaceController.swift
//  WatchNewsDemo
//
//  Created by 沈家瑜 on 15/8/14.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import WatchKit
import Foundation


class NextInterfaceController: WKInterfaceController {

    @IBOutlet weak var labelContext: WKInterfaceLabel!
    @IBOutlet weak var labelTitle: WKInterfaceLabel!
    
    var newsTitle = ""
    var newsContext = ""
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let contextInformation = context as? NSDictionary {
            newsTitle = contextInformation["title"] as! String
            newsContext = contextInformation["context"] as! String
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        labelTitle.setText(newsTitle)
        labelContext.setText(newsContext)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
