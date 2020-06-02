//
//  JSONTableController.swift
//  NewsReader
//
//  Created by haru on 2020/06/01.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import Foundation
import UIKit

class JsonTableCell: UITableViewCell {
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDesc: UILabel!
    
        
}

struct Article: Codable{
    let title: String?
    let description: String?
    let url: String?
}

struct ResultJson: Codable{
    let articles:[Article]?
}


class JsonTableController: UITableViewController{
    
    var items = [Item]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JsonCell",
                                                   for: indexPath) as! JsonTableCell
        cell.articleTitle.text = items[indexPath.row].title
        cell.articleDesc.text = items[indexPath.row].desc
        return cell
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        download()
    }
    
    func download(){
        let urlString = "https://newsapi.org/v2/top-headlines?country=jp&category=technology&apiKey=9947436f9ee74ff2a49a3c7b8f60226e"
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
                item.desc = article.description!
                self.items.append(item)
            }
            self.tableView.reloadData()
           }catch{
               print("error happened")
           }
        })

        task.resume()
    }
    
}
