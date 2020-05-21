//
//  Item.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class Item {
    var title = ""
    var link = ""
    var dateString = ""
    var date: Date = Date()
    
   func convert_string_to_date() {
    // Set the date formatter and optionally set the formatted date from string
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
    print(self.dateString)
    if let date = dateFormatter.date(from: self.dateString) {
           self.date = date
       }
//    print(self.date)
    
   }
}
