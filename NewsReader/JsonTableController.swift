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
    @IBOutlet weak var articletitleLabel: UILabel!
    @IBOutlet weak var articletextLabel: UILabel!
    
}

struct Article: Codable{
    let title: String?
    let description: String?
    let url: String?
}

struct ResultJson: Codable{
    let articles:[Article]?
}


class JsonTableController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "JsonCell",
                                                   for: indexPath) as! JsonTableCell
          return cell
      }

    override func viewDidLoad() {
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
           
           do{
               let decode = JSONDecoder()
               let json = try decode.decode(ResultJson.self, from: data!)
               
               print(json)
           }catch{
               print("error happened")
           }
        })

        task.resume()
    }
    
}
