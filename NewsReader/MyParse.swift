//
//  MyParse.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/24.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class MyParse : NSObject,XMLParserDelegate{
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentstring = ""
    
    func startDownload() -> Array <Item>{
        self.items = []
        let urls = ["http://www.security-next.com/feed",
                    "http://feeds.trendmicro.com/TM-Securityblog/",
                    "https://rss.itmedia.co.jp/rss/2.0/news_security.xml",
                    "https://ccsi.jp/category/%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9/feed/",
                    "https://www.ipa.go.jp/security/rss/info.rdf",
                    "https://scan.netsecurity.ne.jp/rss/index.rdf",
                    "https://www.lac.co.jp/lacwatch/feed.xml"]
        
        for urlString in urls {
            if let url = URL(string: urlString){
                if let parser = XMLParser(contentsOf: url){
                    self.parser = parser
                    self.parser.delegate = self
                    self.parser.parse()
                }
            }
        }
        
        self.items = self.items.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        return self.items
    }
        
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentstring = ""
        if elementName == "item" {
            self.item = Item()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentstring += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "title":
            self.item?.title = currentstring
        case "link":
            self.item?.link = currentstring
            self.item?.check_source()
        case "pubDate":
            self.item?.convert_pubdate_date(currentString: currentstring)
            self.item?.convert_date_to_string()
        case "dc:date":
            self.item?.convert_dcdate_date(currentString: currentstring)
            self.item?.convert_date_to_string()
        case "item":
            self.items.append(self.item!)
        default:
            break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
    
    }
}
