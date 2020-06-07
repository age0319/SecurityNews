//
//  MyParse.swift
//  NewsReader
//
//  Created by 上松晴信 on 2020/05/24.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class XMLHandler : NSObject,XMLParserDelegate{
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentstring = ""
    
    
    func downloadPararrel(completion: @escaping ([Item]?) -> ()){
        
        let dispatchGroup = DispatchGroup()
            
        for (_,value) in CommonSetting().sourceDict{
            
            print("start fetching",value)
            
            dispatchGroup.enter()
            
            let req_url = URL(string: value)
            let req = URLRequest(url: req_url!)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

            let task = session.dataTask(with: req, completionHandler: {
                (data, response, error) in
                session.finishTasksAndInvalidate()
                print("finish",data!.count)
                
                self.parser = XMLParser(data: data!)
                self.parser.delegate = self
                self.parser.parse()
               
                dispatchGroup.leave()
                   })
            
            task.resume()
            }
        dispatchGroup.notify(queue: .main){
    
            self.items = self.items.filter({ item -> Bool in
                !item.title.contains("最新記事一覧")
            })
             
            self.items = self.items.filter({ item -> Bool in
                if item.source.contains("Gigazine"){
                    return item.subject.contains("セキュリティ")
                }else{
                    return true
                }
             })
            
            self.items = self.items.sorted(by: {
                     $0.date.compare($1.date) == .orderedDescending
             })
            
            completion(self.items)
        }
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
            case "dc:subject":
                self.item?.subject = currentstring
            case "item":
                self.items.append(self.item!)
            default:
                break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
    
    }
    
}
