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
    var source = ""
    
    func convert_pubdate_date(currentString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = dateFormatter.date(from: currentString) {
           self.date = date
        }
   }
    
    func convert_dcdate_date(currentString: String){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: currentString){
            self.date = date
        }
    }
    
    func convert_date_to_string(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "MM/dd HH:mm"
        self.dateString = dateFormatter.string(from: self.date)
    }
    
    func check_source(){
        if self.link.contains("security-next.com"){
            self.source = "Security Next"
        }else if(self.link.contains("trendmicro")){
            self.source = "Trend Micro"
        }else if(self.link.contains("itmedia.co.jp")){
            self.source = "IT Media"
        }else if(self.link.contains("ccsi")){
            self.source = "CCSI"
        }else if(self.link.contains("ipa.go.jp")){
            self.source = "IPA"
        }else if(self.link.contains("scan.netsecurity.ne.jp")){
            self.source = "ScanNetSecurity"
        }else if(self.link.contains("www.lac.co.jp")){
            self.source = "LAC"
        }
    }

}
