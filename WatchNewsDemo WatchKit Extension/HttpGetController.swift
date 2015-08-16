//
//  HttpGetController.swift
//  WatchNewsDemo
//
//  Created by 沈家瑜 on 15/8/14.
//  Copyright (c) 2015年 沈家瑜. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct News {
    let title: String
    let date: String
    let imageURL: String
    let context: JSON
}

protocol GetNewsDelegate {
    func getNews(news: [News])
}


class HttpGetController: NSObject {
    
    var delegate: GetNewsDelegate?
    func getHttp(url: String) {
        Alamofire.request(.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers) { (_, _, json, _) -> Void in
            var new = [News]()
            if let j = JSON(json!).array {
                for i in 0 ..< j.count {
                    if let title = j[i]["title"].string, date = j[i]["date"].string{
                        new.append(News(title: title, date: date, imageURL: j[i]["topic"].stringValue, context: j[i]))
                    }
                }
            }
            self.delegate?.getNews(new)
   
        }
    }
}
