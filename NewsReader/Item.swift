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
    
    func convert_string_to_date(currentString: String) {
        // Set the date formatter and optionally set the formatted date from string
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = dateFormatter.date(from: currentString) {
           self.date = date
        }
    
   }
    
    func convert_date_to_string(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "MM/dd HH:mm"
        self.dateString = dateFormatter.string(from: self.date)
    }

}
