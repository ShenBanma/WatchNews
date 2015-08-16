//
//  InterfaceController.swift
//  WatchNewsDemo WatchKit Extension
//
//  Created by 沈家瑜 on 15/8/14.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import WatchKit
import Alamofire
import SwiftyJSON


class InterfaceController: WKInterfaceController,GetNewsDelegate {
    
    @IBOutlet weak var labelRemind: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    var news = [News]()
    
    var imageUrlCache = [String: UIImage]()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }
    
    func getNewsToHttp() {
        let controller = HttpGetController()
        controller.delegate = self
        controller.getHttp("https://cnbeta1.com/api/getArticles")
    }
    
    func getNews(news: [News]) {
        self.news = news
        self.reloadTable()
    }
    
    func reloadTable() {
        var types = [String]()
        for i in 0..<news.count {
            if news[i].imageURL.pathExtension == "gif"{
                types.append("NewsRow")
            }else {
                types.append("ImageNewsRow")
            }
        }
        labelRemind.setHidden(true)
        table.setHidden(false)
        table.setRowTypes(types)
        
        for i in 0..<news.count {
            if let row = table.rowControllerAtIndex(i) as? NewsRow {
                row.labelTitle.setText(news[i].title)
                row.labelDate.setText(changeDate(news[i].date))
            } else if let row = table.rowControllerAtIndex(i) as? ImageNewsRow {
                row.labelTitle.setText(news[i].title)
                row.labelDate.setText(changeDate(news[i].date))
                let imgURL = "http:" + news[i].imageURL
                if let img = imageUrlCache[imgURL] {
                    row.imageNews.setImage(img)
                }else {
                    Alamofire.request(.GET, imgURL).response({ (_, _, data, _) -> Void in
                        let imgSave = UIImage(data: data!)
                        row.imageNews.setImage(imgSave)
                        self.imageUrlCache[imgURL] = imgSave
                    })
                }
                
            }
        }
    }
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let json = news[rowIndex].context
        if let context = json["intro"].string {
            pushControllerWithName("NextController", context: ["title": news[rowIndex].title, "context": context])
        }
    }
    
    func changeDate(date: String) -> String {
        let dater = NSDateFormatter()
        dater.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let newDate = dater.dateFromString(date)
        dater.dateFormat = "HH:mm"
        return dater.stringFromDate(newDate!)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        table.setHidden(true)
        labelRemind.setHidden(false)
        getNewsToHttp()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
