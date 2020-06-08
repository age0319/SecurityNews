//
//  settings.swift
//  NewsReader
//
//  Created by haru on 2020/06/07.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class CommonSetting {
    
    var dataSource = [(String,String,String)]()
    
    init() {
        self.dataSource = [
            ("SecurityNext","http://www.security-next.com/feed","security-next.com"),
            ("TrendMicro","http://feeds.trendmicro.com/TM-Securityblog/","trendmicro"),
            ("CCSI","https://ccsi.jp/category/%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9/feed/","ccsi.jp"),
            ("IPA","https://www.ipa.go.jp/security/rss/info.rdf","ipa.go.jp"),
            ("ScanNetSecurity","https://scan.netsecurity.ne.jp/rss/index.rdf","scan.netsecurity"),
            ("LAC","https://www.lac.co.jp/lacwatch/feed.xml","lac.co.jp"),
            ("TechCrunch","https://jp.techcrunch.com/news/security/feed/","techcrunch.com"),
            ("Gigazine","https://gigazine.net/news/rss_2.0/","gigazine.net"),
            ("ITMedia","https://rss.itmedia.co.jp/rss/2.0/news_security.xml","itmedia.co.jp")
            ]
        }
    
    func loadSourceArray(key:String) -> [Source]{
             if let data = UserDefaults.standard.data(forKey: key){
                 return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Source]
             }else{
                return setDefaultSetting()
             }
         }
    
    func setDefaultSetting() -> [Source]{
        var sourceArray = [Source]()
        for i in self.dataSource{
            let source = Source()
            source.setData(name: i.0, url: i.1, id: i.2)
            sourceArray.append(source)
            }
        return sourceArray
    }
    
    func saveSourceArray(obj: [Source], key:String){
        let userDefaults = UserDefaults.standard
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: true)
            else{
                fatalError()
            }
        userDefaults.set(encodedData, forKey: key)
        }
    
    func loadItems(key:String) -> [Item]{
          if let data = UserDefaults.standard.data(forKey: key){
              return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Item]
          }else{
              let items = [Item]()
              return items
          }
      }
    
    func saveItems(items: [Item], key:String){
        let userDefaults = UserDefaults.standard
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: true)else{
            fatalError()
        }
        userDefaults.set(encodedData, forKey: key)
    }
    
    func trashItems(key:String){
        UserDefaults.standard.removeObject(forKey: key)
    }
}

class Source:NSObject, NSSecureCoding{
    static var supportsSecureCoding: Bool = true
    
    var name:String = ""
    var url:String = ""
    var id:String = ""
    
    override init(){
    }
    
    required init?(coder decoder: NSCoder) {
       if let name = decoder.decodeObject(forKey: "name") as? String{
           self.name = name
       }
       if let url = decoder.decodeObject(forKey: "url") as? String{
           self.url = url
       }
       if let id = decoder.decodeObject(forKey: "id") as? String{
           self.id = id
       }
        
    }
       
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.url, forKey: "url")
        coder.encode(self.id, forKey: "id")
    }
    
    func setData(name:String,url:String,id:String){
        self.name = name
        self.url = url
        self.id = id
    }
    
}
