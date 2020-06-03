//
//  ParseJSON.swift
//  NewsReader
//
//  Created by haru on 2020/06/02.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation

class JSONHandler {
    
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
        
    
    let urlString = "https://newsapi.org/v2/top-headlines?country=jp&category=technology&apiKey=9947436f9ee74ff2a49a3c7b8f60226e"

    func download(completion: @escaping ([Item]?) -> ()) {
        
        var items = [Item]()
        let req_url = URL(string: urlString)
        let req = URLRequest(url: req_url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: req, completionHandler: {
           (data, response, error) in
            session.finishTasksAndInvalidate()
            items.removeAll()
            do{
                let decode = JSONDecoder()
                let json = try decode.decode(ResultJson.self, from: data!)
                let articles = json.articles
                for article in articles!{
                    let item = Item()
                    item.title = article.title!
                    item.link = article.url!
                    item.desc = article.description!
                    item.source = article.source!.name!
                    item.convert_dcdate_date(currentString: article.publishedAt!)
                    item.convert_date_to_string()
                    items.append(item)
                completion(items)
                }
           }catch{
                print("error happened")
                completion(nil)
                return
           }
        })

        task.resume()
    }
}
