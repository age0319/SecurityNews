//
//  Item.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/19.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class Item:NSObject, NSSecureCoding{
    
    static var supportsSecureCoding: Bool = true
    
    var title = ""
    var link = ""
    var dateString = ""
    var date = Date()
    var source = ""
    var isFavorite = Bool()
    //gigazineのカテゴリー
    var subject = ""
    override init() {
    }
    
    required init?(coder decoder: NSCoder) {
        if let title = decoder.decodeObject(forKey: "title") as? String{
            self.title = title
        }
        if let link = decoder.decodeObject(forKey: "link") as? String{
            self.link = link
        }
        if let dateString = decoder.decodeObject(forKey: "dateString") as? String{
            self.dateString = dateString
        }
        if let source = decoder.decodeObject(forKey: "source") as? String{
            self.source = source
        }
        self.isFavorite = decoder.decodeBool(forKey: "isFavorite")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.link, forKey: "link")
        coder.encode(self.dateString, forKey: "dateString")
        coder.encode(self.source,forKey: "source")
        coder.encode(self.isFavorite, forKey: "isFavorite")
    }
    
    func getLink() -> String{
        return self.link
    }
    
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
            self.source = "SecurityNext"
        }else if(self.link.contains("trendmicro")){
            self.source = "TrendMicro"
        }else if(self.link.contains("itmedia.co.jp")){
            self.source = "ITMedia"
        }else if(self.link.contains("ccsi")){
            self.source = "CCSI"
        }else if(self.link.contains("ipa.go.jp")){
            self.source = "IPA"
        }else if(self.link.contains("scan.netsecurity.ne.jp")){
            self.source = "ScanNetSecurity"
        }else if(self.link.contains("www.lac.co.jp")){
            self.source = "LAC"
        }else if(self.link.contains("techcrunch.com")){
            self.source = "TechCrunch"
        }else if(self.link.contains("gigazine.net")){
            self.source = "Gigazine"
        }
    }

}
