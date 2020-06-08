//
//  ParseJSON.swift
//  NewsReader
//
//  Created by haru on 2020/06/02.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class JSONHandler {
    
    var items = [Item]()
    
    struct Source: Codable{
        let id:String?
        let name:String?
    }

    struct Article: Codable{
        let title: String?
        let description: String?
        let url: String?
        let source:Source?
        let publishedAt:String?
    }

    struct ResultJson: Codable{
        let articles:[Article]?
    }
    
    func updateFavs(){
              
       let favs = CommonSetting().loadItems(key: "fav")
       
       if favs.isEmpty {
           self.items.forEach { $0.isFavorite = false }
       }else{
          for i in favs{
              if let offset = self.items.firstIndex(where: {$0.title == i.title}) {
                  self.items[offset].isFavorite = true
              }
          }
       }
        return
    }
    

    func download(completion: @escaping ([Item]?) -> ()) {
        let urlString = CommonSetting().jsonSource
        let req_url = URL(string: urlString)
        let req = URLRequest(url: req_url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: req, completionHandler: {
           (data, response, error) in
            session.finishTasksAndInvalidate()
            self.items.removeAll()
            do{
                let decode = JSONDecoder()
                let json = try decode.decode(ResultJson.self, from: data!)
                let articles = json.articles
                for article in articles!{
                    let item = Item()
                    item.title = article.title!
                    item.link = article.url!
//                    item.desc = article.description!
                    item.source = article.source!.name!
                    item.convert_dcdate_date(currentString: article.publishedAt!)
                    item.convert_date_to_string()
                    self.items.append(item)
                }
                self.updateFavs()
                completion(self.items)
           }catch{
                print("error happened")
                completion(nil)
                return
           }
        })

        task.resume()
    
    }
}
